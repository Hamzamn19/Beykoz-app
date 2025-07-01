import 'package:flutter/material.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'dart:async';

class StudentAttendancePage extends StatefulWidget {
  @override
  _StudentAttendancePageState createState() => _StudentAttendancePageState();
}

class _StudentAttendancePageState extends State<StudentAttendancePage> {
  final TextEditingController _sessionCodeController = TextEditingController();
  bool _isScanning = false;
  String? _scanResultMessage;

  void _scanForTeacher() async {
    final code = _sessionCodeController.text.trim();
    if (code.length != 6) {
      setState(() {
        _scanResultMessage = 'Lütfen 6 haneli bir oturum kodu girin.';
      });
      return;
    }
    setState(() {
      _isScanning = true;
      _scanResultMessage = null;
    });
    final serviceUuid = Uuid.parse('00001234-0000-1000-8000-00805f9b34fb');
    final ble = FlutterReactiveBle();
    bool found = false;
    late StreamSubscription<DiscoveredDevice> subscription;
    subscription = ble.scanForDevices(withServices: [serviceUuid], scanMode: ScanMode.lowLatency).listen((device) {
      final manufacturerData = device.manufacturerData;
      if (manufacturerData != null && manufacturerData.isNotEmpty) {
        if (manufacturerData.length >= 3) {
          final companyId = manufacturerData[0] | (manufacturerData[1] << 8);
          if (companyId == 0x1234) {
            final dataBytes = manufacturerData.sublist(2);
            final codeStr = String.fromCharCodes(dataBytes);
            if (codeStr == code) {
              found = true;
              setState(() {
                _isScanning = false;
                _scanResultMessage = 'Yoklama başarıyla bulundu!';
              });
              subscription.cancel();
            }
          }
        }
      }
    }, onError: (e) {
      setState(() {
        _isScanning = false;
        _scanResultMessage = 'Tarama sırasında hata oluştu: $e';
      });
    });
    await Future.delayed(const Duration(seconds: 15));
    if (!found) {
      await subscription.cancel();
      setState(() {
        _isScanning = false;
        _scanResultMessage = 'Yakındaki öğretmen bulunamadı.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Yoklamaya Katıl'),
        backgroundColor: const Color(0xFF802629),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Yoklamaya Katıl',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF802629),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _sessionCodeController,
              decoration: InputDecoration(
                labelText: 'Oturum Kodu',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Color(0xFF802629)),
                ),
              ),
              keyboardType: TextInputType.number,
              maxLength: 6,
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _isScanning ? null : _scanForTeacher,
              icon: const Icon(Icons.bluetooth_searching),
              label: Text(_isScanning ? 'Taranıyor...' : 'Katıl'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF802629),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
            if (_scanResultMessage != null) ...[
              const SizedBox(height: 16),
              Text(
                _scanResultMessage!,
                style: TextStyle(
                  color: _scanResultMessage == 'Yoklama başarıyla bulundu!'
                      ? Colors.green
                      : Colors.red,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ],
        ),
      ),
    );
  }
} 