import 'package:flutter/material.dart';

class CourseSchedulePage extends StatelessWidget {
  const CourseSchedulePage({super.key});

  // Data for the course list
  final List<Map<String, String>> courses = const [
    {
      'code': '60311YEO02-CMP2021',
      'name': 'Competing Development Program I',
      'instructor': 'OĞUZHAN ÜÇKARDEŞ',
      'credit': '1',
    },
    {
      'code': '60311YEO02-ENG101',
      'name': 'Advanced English I',
      'instructor': 'MUHAMMET GÜNDÜZ',
      'credit': '4',
    },
    {
      'code': '60331YAB02-PHY101',
      'name': 'Physics I',
      'instructor': 'ÜNAL BEGÜM FATMA DEMİREL',
      'credit': '3',
    },
    {
      'code': '60331YAB02-PHY101I',
      'name': 'Physics Laboratory I',
      'instructor': 'SERDAR GÖKÇE',
      'credit': '1',
    },
    {
      'code': '60541ITA02-MTH201',
      'name': 'Calculus I',
      'instructor': 'DÜRDANE YILMAZ',
      'credit': '3',
    },
    {
      'code': '60611ITA02-ICT201',
      'name': 'Information and Communication',
      'instructor': 'ÜNAL BEGÜM FATMA DEMİREL',
      'credit': '1',
    },
    {
      'code': '60611YEG02-CMP231',
      'name': 'Introduction to Programming',
      'instructor': 'RAHİME YILMAZ',
      'credit': '3',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ders Programı'),
        backgroundColor: const Color(0xFF802629), // Beykoz primary color
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: 20),
            _buildStudentInfo(),
            const SizedBox(height: 20),
            _buildScheduleTable(context),
            const SizedBox(height: 20),
            _buildCourseList(), // The improved course list
            const SizedBox(height: 20),
            _buildAdvisorInfo(),
          ],
        ),
      ),
    );
  }

  // Header section with University name and title
  Widget _buildHeader() {
    return Column(
      children: [
        // Image.asset('assets/images/logo.png', height: 60),
        const SizedBox(height: 8),
        const Text(
          'BEYKOZ UNIVERSITY',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        const Text('(Directorate of Student Affairs)'),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
          color: Colors.blue[100],
          child: const Text(
            'Course Program',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ),
      ],
    );
  }

  // Student Information Table
  Widget _buildStudentInfo() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            _buildInfoRow(
              'National ID',
              '11111111111',
              'Faculty',
              'Faculty of Engineering and Architecture',
            ),
            _buildInfoRow(
              'Student ID',
              '1111111111',
              'Department',
              'Department of Computer Engineering',
            ),
            _buildInfoRow(
              'Name',
              'aisha',
              'Programme',
              'Computer Engineering (in English)',
            ),
            _buildInfoRow(
              'Surname',
              'yilmaz',
              'Education Level',
              'Formal Education',
            ),
            _buildInfoRow('Registration Date', '09.02.2023', '', ''),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(
    String label1,
    String value1,
    String label2,
    String value2,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label1,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(flex: 3, child: Text(value1)),
          const SizedBox(width: 10),
          Expanded(
            flex: 2,
            child: Text(
              label2,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(flex: 4, child: Text(value2)),
        ],
      ),
    );
  }

  // Weekly Schedule Section (Already improved)
  Widget _buildScheduleTable(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Weekly Schedule",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDayColumn("MONDAY", [
                _buildCourseCell(
                  '60331YAB02-PHY101\nPhysics 1',
                  'Lisans Yerleskesi L102 1\n11:00 - 13:00',
                ),
                _buildCourseCell(
                  '60611ITA02-CNT321\nInformation and Communication Technologies',
                  'Lisans Yerleskesi 705-Bilgisayar Lab. 7\n13:00 - 15:00',
                ),
                _buildCourseCell(
                  '60311YEO02-ENG101\nAdvanced English 1',
                  'Kavacik Yerleskesi 101 1\n15:00 - 17:00',
                ),
              ]),
              _buildDayColumn("TUESDAY", [
                _buildCourseCell(
                  '60541ITA02-MTH201\nCalculus I',
                  'Lisans Yerleskesi L202 2\n13:00 - 15:00',
                ),
                _buildCourseCell(
                  '60311YEO02-ENG102 I\nAdvanced English 1',
                  'Online Beykoz Online Beykoz\n18:00 - 20:00',
                ),
              ]),
              _buildDayColumn("WEDNESDAY", [
                _buildCourseCell(
                  '60541ITA02-MTH201\nCalculus I',
                  'Lisans Yerleskesi L401 4\n09:00 - 11:00',
                ),
                _buildCourseCell(
                  '60611YEG02-CMP231\nIntroduction to Programming',
                  'Lisans Yerleskesi L202 2\n11:00 - 13:00',
                ),
                _buildCourseCell(
                  '60331YAB02-PHY101\nPhysics I',
                  'Lisans Yerleskesi L102 3\n13:00 - 15:00',
                ),
              ]),
              _buildDayColumn("THURSDAY", [
                _buildCourseCell(
                  '60611ITA02-ICT2021\nInformation and Communication Technologies',
                  'Lisans Yerleskesi 606-Bilgisayar Lab. 6\n09:00 - 11:00',
                ),
              ]),
              _buildDayColumn("FRIDAY", [
                _buildCourseCell(
                  '60611YEG02-CMP201\nIntroduction to Programming',
                  'Lisans Yerleskesi 303-Bilgisayar Lab. 3\n09:00 - 11:00',
                ),
                _buildCourseCell(
                  '60331YAB02-PHY101I\nPhysics Laboratory I',
                  'Lisans Ek Yerleske U102-Fizik Laboratuvan 6\n11:00 - 13:00',
                ),
              ]),
              _buildDayColumn("SATURDAY", [
                _buildCourseCell(
                  '60311YEO02-CMP2021\nCompeting Development Program I',
                  'Online Beykoz Online Beykoz\n11:00 - 12:00',
                ),
              ]),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDayColumn(String title, List<Widget> children) {
    return Container(
      width: 160,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          const Divider(height: 1),
          ...children,
        ],
      ),
    );
  }

  Widget _buildCourseCell(String title, String subtitle) {
    return Card(
      elevation: 1,
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 6),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: const TextStyle(fontSize: 11, color: Colors.black54),
            ),
          ],
        ),
      ),
    );
  }

  // --- START: IMPROVED COURSE LIST SECTION ---

  Widget _buildCourseList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Course List",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        // Create a list of widgets from the course data
        ...courses.map((course) => _buildCourseRowCard(course)).toList(),
      ],
    );
  }

  // New widget to build a beautiful card for each course
  Widget _buildCourseRowCard(Map<String, String> course) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12.0),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Text(
                    course['name']!,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Color(0xFF802629),
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    "${course['credit']!} C",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            const Divider(height: 15),
            Text(
              course['code']!,
              style: TextStyle(color: Colors.grey[600], fontSize: 12),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.person_outline, size: 16, color: Colors.grey),
                const SizedBox(width: 8),
                Text(course['instructor']!),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // --- END: IMPROVED COURSE LIST SECTION ---

  // Advisor Info section
  Widget _buildAdvisorInfo() {
    return Container(
      padding: const EdgeInsets.all(8),
      color: Colors.grey[200],
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'ADVISOR: NEVDAT EKREM ÜNAL',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
