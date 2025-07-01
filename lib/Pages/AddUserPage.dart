import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddUserPage extends StatefulWidget {
  @override
  _AddUserPageState createState() => _AddUserPageState();
}

class _AddUserPageState extends State<AddUserPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _surnameController = TextEditingController();
  final TextEditingController _numberController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _departmentController = TextEditingController();
  String? _selectedClass;
  final List<String> _classOptions = ['1', '2', '3', '4'];
  bool _isLoading = false;
  String? _successMessage;
  String? _errorMessage;
  String? _selectedDepartment;
  String? _selectedRole;
  final List<String> _roleOptions = ['Student', 'Teacher', 'Developer'];

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
    _numberController.dispose();
    _emailController.dispose();
    _departmentController.dispose();
    super.dispose();
  }

  void _updateEmail() {
    final name = _nameController.text.trim().toLowerCase().replaceAll(' ', '');
    final surname = _surnameController.text.trim().toLowerCase().replaceAll(' ', '');
    if (name.isNotEmpty && surname.isNotEmpty) {
      _emailController.text = '$name$surname@ogrenci.beykoz.edu.tr';
    } else {
      _emailController.text = '';
    }
    setState(() {});
  }

  Future<void> _addUser() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _isLoading = true;
      _successMessage = null;
      _errorMessage = null;
    });
    try {
      await FirebaseFirestore.instance.collection('students').doc(_numberController.text.trim()).set({
        'name': _nameController.text.trim(),
        'surname': _surnameController.text.trim(),
        'studentNumber': _numberController.text.trim(),
        'email': _emailController.text.trim(),
        'department': _selectedDepartment,
        'class': _selectedClass,
        'role': _selectedRole,
      });
      setState(() {
        _successMessage = 'Kullanıcı başarıyla eklendi!';
        _isLoading = false;
        _nameController.clear();
        _surnameController.clear();
        _numberController.clear();
        _emailController.clear();
        _selectedDepartment = null;
        _selectedClass = null;
        _selectedRole = null;
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
        title: Text('Kullanıcı Ekle'),
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
                controller: _numberController,
                decoration: InputDecoration(labelText: 'Öğrenci Numarası'),
                validator: (value) => value == null || value.isEmpty ? 'Numara giriniz' : null,
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Mail Adresi'),
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
              DropdownButtonFormField<String>(
                value: _selectedClass,
                items: _classOptions.map((c) => DropdownMenuItem(value: c, child: Text('$c. Sınıf'))).toList(),
                onChanged: (val) => setState(() => _selectedClass = val),
                decoration: InputDecoration(labelText: 'Sınıf'),
                validator: (value) => value == null || value.isEmpty ? 'Sınıf seçiniz' : null,
              ),
              SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedRole,
                items: _roleOptions.map((r) => DropdownMenuItem(value: r, child: Text(r))).toList(),
                onChanged: (val) => setState(() => _selectedRole = val),
                decoration: InputDecoration(labelText: 'Rol'),
                validator: (value) => value == null || value.isEmpty ? 'Rol seçiniz' : null,
              ),
              SizedBox(height: 24),
              ElevatedButton(
                onPressed: _isLoading ? null : _addUser,
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