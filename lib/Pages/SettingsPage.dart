import 'package:flutter/material.dart';
import 'package:beykoz/Pages/AddUserPage.dart';
import 'package:beykoz/Pages/AddCoursePage.dart';
import 'package:beykoz/Pages/AddTeacherPage.dart';
import 'package:beykoz/Pages/AddDepartmentPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ayarlar'),
        backgroundColor: const Color(0xFF802629),
      ),
      body: ListView(
        children: [
          ListTile(
            leading: Icon(Icons.person_add, color: Color(0xFF802629)),
            title: Text('Kullanıcı Ekle'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddUserPage()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.person, color: Color(0xFF802629)),
            title: Text('Öğretmen Ekle'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddTeacherPage()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.add_box, color: Color(0xFF802629)),
            title: Text('Ders Ekle'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddCoursePage()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.school, color: Color(0xFF802629)),
            title: Text('Bölüm Ekle'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddDepartmentPage()),
              );
            },
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text('Haftalık Ders Programı', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Color(0xFF802629))),
          ),
          _WeeklyScheduleWidget(),
        ],
      ),
    );
  }
}

class _WeeklyScheduleWidget extends StatefulWidget {
  @override
  State<_WeeklyScheduleWidget> createState() => _WeeklyScheduleWidgetState();
}

class _WeeklyScheduleWidgetState extends State<_WeeklyScheduleWidget> {
  final List<String> days = ['Pazartesi', 'Salı', 'Çarşamba', 'Perşembe', 'Cuma'];
  final List<String> classOptions = ['1', '2', '3', '4'];
  String? selectedClass;
  String? selectedDepartment;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              Expanded(
                child: DropdownButtonFormField<String>(
                  value: selectedClass,
                  items: classOptions.map((c) => DropdownMenuItem(value: c, child: Text('$c. Sınıf'))).toList(),
                  onChanged: (val) => setState(() => selectedClass = val),
                  decoration: InputDecoration(labelText: 'Sınıf'),
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance.collection('departments').snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Center(child: CircularProgressIndicator());
                    }
                    final departments = snapshot.data!.docs.map((doc) => doc['name'] as String).toList();
                    return DropdownButtonFormField<String>(
                      value: selectedDepartment,
                      items: departments.map((d) => DropdownMenuItem(value: d, child: Text(d))).toList(),
                      onChanged: (val) => setState(() => selectedDepartment = val),
                      decoration: InputDecoration(labelText: 'Bölüm'),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        if (selectedClass != null && (selectedDepartment != null && selectedDepartment!.isNotEmpty))
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('courses')
                .where('class', isEqualTo: selectedClass)
                .where('department', isEqualTo: selectedDepartment)
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(child: CircularProgressIndicator());
              }
              final courses = snapshot.data!.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
              return Column(
                children: days.map((day) {
                  final dayCourses = courses.where((c) => c['day'] == day).toList();
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(day, style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF802629))),
                          ...dayCourses.map((c) => ListTile(
                                title: Text('${c['name']} (${c['code']})'),
                                subtitle: Text('${c['time']}'),
                              )),
                          if (dayCourses.isEmpty)
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text('Ders yok', style: TextStyle(color: Colors.grey)),
                            ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              );
            },
          ),
      ],
    );
  }
} 