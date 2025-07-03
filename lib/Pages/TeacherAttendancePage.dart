import 'package:flutter/material.dart';
import 'package:beykoz/Services/ble_advertising_service.dart';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';

class TeacherAttendancePage extends StatefulWidget {
  const TeacherAttendancePage({super.key});

  @override
  _TeacherAttendancePageState createState() => _TeacherAttendancePageState();
}

class _TeacherAttendancePageState extends State<TeacherAttendancePage> {
  String? _sessionCode;
  bool _isAdvertising = false;
  String? _selectedClass;
  final List<String> _classOptions = ['1', '2', '3', '4'];
  String? _attendanceDocId; // Firestore attendance doc id
  DateTime? _endTime;
  Timer? _timer;
  Duration _remaining = Duration.zero;

  void _addDebugLog(String message) {}
  // Not: Gerekirse debug logları ana sayfadan parametre olarak alınabilir.

  void _startAdvertising() async {
    if (_selectedClass == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lütfen önce sınıf seçin!'), backgroundColor: Colors.red),
      );
      return;
    }
    try {
      final code = (Random().nextInt(900000) + 100000).toString();
      final now = DateTime.now();
      final endTime = now.add(Duration(minutes: 10));
      setState(() {
        _sessionCode = code;
        _isAdvertising = true;
        _endTime = endTime;
      });
      // Firestore'da yoklama oturumu oluştur
      final docRef = await FirebaseFirestore.instance.collection('attendances').add({
        'class': _selectedClass,
        'sessionCode': code,
        'present': <String>[],
        'timestamp': FieldValue.serverTimestamp(),
        'endTime': endTime.toIso8601String(),
      });
      _attendanceDocId = docRef.id;
      _startTimer();
      await BleAdvertisingService.startAdvertising(code);
    } catch (e) {
      setState(() {
        _isAdvertising = false;
        _sessionCode = null;
        _attendanceDocId = null;
        _endTime = null;
      });
    }
  }

  void _stopAdvertising() async {
    try {
      await BleAdvertisingService.stopAdvertising();
      _timer?.cancel();
      setState(() {
        _isAdvertising = false;
        _sessionCode = null;
        _attendanceDocId = null;
        _endTime = null;
        _remaining = Duration.zero;
      });
    } catch (e) {}
  }

  void _startTimer() {
    _timer?.cancel();
    _updateRemaining();
    _timer = Timer.periodic(Duration(seconds: 1), (_) => _updateRemaining());
  }

  void _updateRemaining() {
    if (_endTime == null) return;
    final now = DateTime.now();
    final diff = _endTime!.difference(now);
    setState(() {
      _remaining = diff.isNegative ? Duration.zero : diff;
    });
    if (diff.isNegative) {
      _timer?.cancel();
    }
  }

  Future<void> _extendTime() async {
    if (_attendanceDocId == null || _endTime == null) return;
    final newEndTime = _endTime!.add(Duration(minutes: 10));
    await FirebaseFirestore.instance.collection('attendances').doc(_attendanceDocId).update({
      'endTime': newEndTime.toIso8601String(),
    });
    setState(() {
      _endTime = newEndTime;
    });
    _startTimer();
  }

  @override
  void dispose() {
    _stopAdvertising();
    _timer?.cancel();
    super.dispose();
  }

  Widget _buildClassSelector() {
    return DropdownButtonFormField<String>(
      value: _selectedClass,
      items: _classOptions.map((c) => DropdownMenuItem(value: c, child: Text('$c. Sınıf'))).toList(),
      onChanged: _isAdvertising ? null : (val) => setState(() => _selectedClass = val),
      decoration: InputDecoration(labelText: 'Sınıf Seç'),
    );
  }

  Widget _buildStudentList() {
    if (_selectedClass == null || !_isAdvertising) {
      return SizedBox.shrink();
    }
    // attendances belgesi ve öğrenciler stream ile izleniyor
    return Expanded(
      child: Card(
        margin: const EdgeInsets.only(top: 24),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${_selectedClass!}. Sınıf Öğrenci Listesi',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF802629),
                ),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('students')
                      .where('class', isEqualTo: _selectedClass)
                      .snapshots(),
                  builder: (context, studentSnap) {
                    if (studentSnap.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }
                    if (!studentSnap.hasData || studentSnap.data!.docs.isEmpty) {
                      return Center(child: Text('Bu sınıfta öğrenci yok.'));
                    }
                    // attendances stream
                    return StreamBuilder<DocumentSnapshot>(
                      stream: _attendanceDocId != null
                          ? FirebaseFirestore.instance.collection('attendances').doc(_attendanceDocId).snapshots()
                          : const Stream.empty(),
                      builder: (context, attendanceSnap) {
                        final presentList = (attendanceSnap.data?.data() as Map<String, dynamic>?)?['present'] as List<dynamic>? ?? [];
                        final students = studentSnap.data!.docs;
                        return ListView.builder(
                          itemCount: students.length,
                          itemBuilder: (context, index) {
                            final data = students[index].data() as Map<String, dynamic>;
                            final studentNumber = data['studentNumber'] ?? '-';
                            final isPresent = presentList.contains(studentNumber);
                            return ListTile(
                              leading: CircleAvatar(
                                backgroundColor: isPresent ? Colors.green : Colors.red,
                                child: Text(data['name']?[0] ?? '?', style: TextStyle(color: Colors.white)),
                              ),
                              title: Text('${data['name'] ?? '-'} ${data['surname'] ?? ''}'),
                              subtitle: Text('No: $studentNumber\nMail: ${data['email'] ?? '-'}'),
                              trailing: Text(isPresent ? 'Var' : 'Yok', style: TextStyle(color: isPresent ? Colors.green : Colors.red, fontWeight: FontWeight.bold)),
                            );
                          },
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTimerAndExtendButton() {
    if (!_isAdvertising || _endTime == null) return SizedBox.shrink();
    final min = _remaining.inMinutes.remainder(60).toString().padLeft(2, '0');
    final sec = _remaining.inSeconds.remainder(60).toString().padLeft(2, '0');
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Kalan Süre: $min:$sec', style: TextStyle(fontSize: 18, color: Color(0xFF802629), fontWeight: FontWeight.bold)),
          const SizedBox(width: 24),
          ElevatedButton.icon(
            onPressed: _extendTime,
            icon: Icon(Icons.add),
            label: Text('10 dk ekle'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF802629),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Yoklama Başlat'),
        backgroundColor: const Color(0xFF802629),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Yoklama Başlat',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF802629),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            _buildClassSelector(),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _isAdvertising ? _stopAdvertising : _startAdvertising,
              icon: Icon(_isAdvertising ? Icons.stop : Icons.bluetooth),
              label: Text(_isAdvertising ? 'Yayınlamayı Durdur' : 'Yoklama Başlat'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF802629),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
            if (_isAdvertising && _sessionCode != null) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Color(0xFF802629), width: 1),
                ),
                child: Center(
                  child: Text(
                    'Oturum Kodu: $_sessionCode',
                    style: const TextStyle(fontSize: 18, color: Color(0xFF802629)),
                  ),
                ),
              ),
              _buildTimerAndExtendButton(),
            ],
            // Öğrenci listesi
            _buildStudentList(),
          ],
        ),
      ),
    );
  }
} 