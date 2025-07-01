import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddCoursePage extends StatefulWidget {
  @override
  _AddCoursePageState createState() => _AddCoursePageState();
}

class _AddCoursePageState extends State<AddCoursePage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _codeController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  final TextEditingController _departmentController = TextEditingController();
  String? _selectedDay;
  final List<String> _days = ['Pazartesi', 'Salı', 'Çarşamba', 'Perşembe', 'Cuma'];
  bool _isLoading = false;
  String? _successMessage;
  String? _errorMessage;
  String? _selectedClass;
  final List<String> _classOptions = ['1', '2', '3', '4'];
  String? _selectedDepartment;

  Future<void> _addCourse() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _isLoading = true;
      _successMessage = null;
      _errorMessage = null;
    });
    try {
      final code = _codeController.text.trim();
      await FirebaseFirestore.instance.collection('courses')
        .doc(code)
        .set({
          'name': _nameController.text.trim(),
          'code': code,
          'time': _timeController.text.trim(),
          'day': _selectedDay,
          'department': _selectedDepartment,
          'class': _selectedClass,
        });
      setState(() {
        _successMessage = 'Ders başarıyla eklendi!';
        _isLoading = false;
        _nameController.clear();
        _codeController.clear();
        _timeController.clear();
        _selectedDay = null;
        _selectedDepartment = null;
        _selectedClass = null;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Bir hata oluştu: $e';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ders Ekle'),
        backgroundColor: const Color(0xFF802629),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Ders Adı'),
                validator: (value) => value == null || value.isEmpty ? 'Ders adı giriniz' : null,
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _codeController,
                decoration: InputDecoration(labelText: 'Ders Kodu'),
                validator: (value) => value == null || value.isEmpty ? 'Ders kodu giriniz' : null,
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _timeController,
                decoration: InputDecoration(labelText: 'Ders Saatleri (örn: 09:00-10:50)'),
                validator: (value) => value == null || value.isEmpty ? 'Ders saatleri giriniz' : null,
              ),
              SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedDay,
                items: _days.map((d) => DropdownMenuItem(value: d, child: Text(d))).toList(),
                onChanged: (val) => setState(() => _selectedDay = val),
                decoration: InputDecoration(labelText: 'Ders Günü'),
                validator: (value) => value == null || value.isEmpty ? 'Ders günü seçiniz' : null,
              ),
              SizedBox(height: 16),
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection('departments').snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(child: CircularProgressIndicator());
                  }
                  final departments = snapshot.data!.docs.map((doc) => doc['name'] as String).toList();
                  return DropdownButtonFormField<String>(
                    value: _selectedDepartment,
                    items: departments.map((d) => DropdownMenuItem(value: d, child: Text(d))).toList(),
                    onChanged: (val) => setState(() => _selectedDepartment = val),
                    decoration: InputDecoration(labelText: 'Bölüm'),
                    validator: (value) => value == null || value.isEmpty ? 'Bölüm seçiniz' : null,
                  );
                },
              ),
              SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedClass,
                items: _classOptions.map((c) => DropdownMenuItem(value: c, child: Text('$c. Sınıf'))).toList(),
                onChanged: (val) => setState(() => _selectedClass = val),
                decoration: InputDecoration(labelText: 'Sınıf'),
                validator: (value) => value == null || value.isEmpty ? 'Sınıf seçiniz' : null,
              ),
              SizedBox(height: 24),
              ElevatedButton(
                onPressed: _isLoading ? null : _addCourse,
                child: _isLoading ? CircularProgressIndicator(color: Colors.white) : Text('Ekle'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF802629),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
              if (_successMessage != null) ...[
                SizedBox(height: 16),
                Text(_successMessage!, style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
              ],
              if (_errorMessage != null) ...[
                SizedBox(height: 16),
                Text(_errorMessage!, style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
              ],
            ],
          ),
        ),
      ),
    );
  }
} 