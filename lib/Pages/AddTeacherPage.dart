import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddTeacherPage extends StatefulWidget {
  @override
  _AddTeacherPageState createState() => _AddTeacherPageState();
}

class _AddTeacherPageState extends State<AddTeacherPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _surnameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _assignedClassesController = TextEditingController();
  bool _isLoading = false;
  String? _successMessage;
  String? _errorMessage;
  String? _selectedDepartment;
  List<String> _selectedCourses = [];

  @override
  void initState() {
    super.initState();
    _nameController.addListener(_updateEmail);
    _surnameController.addListener(_updateEmail);
  }

  @override
  void dispose() {
    _nameController.removeListener(_updateEmail);
    _surnameController.removeListener(_updateEmail);
    _nameController.dispose();
    _surnameController.dispose();
    _emailController.dispose();
    _assignedClassesController.dispose();
    super.dispose();
  }

  void _updateEmail() {
    final name = _nameController.text.trim().toLowerCase().replaceAll(' ', '');
    final surname = _surnameController.text.trim().toLowerCase().replaceAll(' ', '');
    if (name.isNotEmpty && surname.isNotEmpty) {
      _emailController.text = '$name$surname@beykoz.edu.tr';
    } else {
      _emailController.text = '';
    }
    setState(() {});
  }

  Future<void> _addTeacher() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _isLoading = true;
      _successMessage = null;
      _errorMessage = null;
    });
    try {
      final email = _emailController.text.trim();
      await FirebaseFirestore.instance.collection('teachers')
        .doc(email)
        .set({
          'name': _nameController.text.trim(),
          'surname': _surnameController.text.trim(),
          'email': email,
          'department': _selectedDepartment,
          'assignedClasses': _selectedCourses,
        });
      setState(() {
        _successMessage = 'Öğretmen başarıyla eklendi!';
        _isLoading = false;
        _nameController.clear();
        _surnameController.clear();
        _emailController.clear();
        _selectedDepartment = null;
        _assignedClassesController.clear();
        _selectedCourses = [];
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
        title: Text('Öğretmen Ekle'),
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
                decoration: InputDecoration(labelText: 'İsim'),
                validator: (value) => value == null || value.isEmpty ? 'İsim giriniz' : null,
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _surnameController,
                decoration: InputDecoration(labelText: 'Soyisim'),
                validator: (value) => value == null || value.isEmpty ? 'Soyisim giriniz' : null,
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Mail'),
                readOnly: true,
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
              Text('Verdiği Dersler', style: TextStyle(fontWeight: FontWeight.bold)),
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection('courses').snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(child: CircularProgressIndicator());
                  }
                  final courses = snapshot.data!.docs.map((doc) => doc['code'] as String).toList();
                  return Column(
                    children: courses.map((code) => CheckboxListTile(
                      value: _selectedCourses.contains(code),
                      title: Text(code),
                      onChanged: (val) {
                        setState(() {
                          if (val == true) {
                            _selectedCourses.add(code);
                          } else {
                            _selectedCourses.remove(code);
                          }
                        });
                      },
                    )).toList(),
                  );
                },
              ),
              SizedBox(height: 24),
              ElevatedButton(
                onPressed: _isLoading ? null : _addTeacher,
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