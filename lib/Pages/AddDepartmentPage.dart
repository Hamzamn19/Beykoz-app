import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddDepartmentPage extends StatefulWidget {
  const AddDepartmentPage({super.key});

  @override
  _AddDepartmentPageState createState() => _AddDepartmentPageState();
}

class _AddDepartmentPageState extends State<AddDepartmentPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  bool _isLoading = false;
  String? _successMessage;
  String? _errorMessage;

  Future<void> _addDepartment() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _isLoading = true;
      _successMessage = null;
      _errorMessage = null;
    });
    try {
      final name = _nameController.text.trim();
      await FirebaseFirestore.instance.collection('departments').doc(name).set({'name': name});
      setState(() {
        _successMessage = 'Bölüm başarıyla eklendi!';
        _isLoading = false;
        _nameController.clear();
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
        title: Text('Bölüm Ekle'),
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
                decoration: InputDecoration(labelText: 'Bölüm Adı'),
                validator: (value) => value == null || value.isEmpty ? 'Bölüm adı giriniz' : null,
              ),
              SizedBox(height: 24),
              ElevatedButton(
                onPressed: _isLoading ? null : _addDepartment,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF802629),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: _isLoading ? CircularProgressIndicator(color: Colors.white) : Text('Ekle'),
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