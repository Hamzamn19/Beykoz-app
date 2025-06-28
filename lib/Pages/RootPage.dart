import 'package:beykoz/Pages/AttendancePage.dart';
import 'package:beykoz/Pages/HomePage.dart';
import 'package:flutter/material.dart';
import 'NewsPage.dart';
import 'ProfilePage.dart';

class RootScreen extends StatefulWidget {
  const RootScreen({Key? key}) : super(key: key);

  @override
  State<RootScreen> createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    DesignedHomePage(),
    NewsPage(),
    AttendanceScreen(),
    WebviewPageSelector(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _pages[_selectedIndex],
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 24.0),
              child: CustomNavBar(
                selectedIndex: _selectedIndex,
                onTabSelected: (index) {
                  setState(() {
                    _selectedIndex = index;
                  });
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CustomNavBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onTabSelected;

  const CustomNavBar({
    Key? key,
    required this.selectedIndex,
    required this.onTabSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    return SizedBox(
      width: width,
      height: 90,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // NavBar background
          Positioned(
            bottom: 0,
            left: width * 0.04,
            right: width * 0.04,
            child: Container(
              height: 60,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(32),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.15),
                    blurRadius: 24,
                    spreadRadius: 2,
                    offset: Offset(0, 8),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _NavBarIcon(
                    icon: Icons.home,
                    selected: selectedIndex == 0,
                    onTap: () => onTabSelected(0),
                  ),
                  _NavBarIcon(
                    icon: Icons.article,
                    selected: selectedIndex == 1,
                    onTap: () => onTabSelected(1),
                  ),
                  const SizedBox(width: 48), // Space for center button
                  _NavBarIcon(
                    icon: Icons.language,
                    selected: selectedIndex == 3,
                    onTap: () => onTabSelected(3),
                  ),
                  _NavBarIcon(
                    icon: Icons.person,
                    selected: selectedIndex == 4,
                    onTap: () => onTabSelected(4),
                  ),
                ],
              ),
            ),
          ),
          // Center Floating Button (Attendance)
          Positioned(
            bottom: 18,
            child: GestureDetector(
              onTap: () => onTabSelected(2),
              child: PhysicalModel(
                color: Colors.white,
                elevation: 8,
                shape: BoxShape.circle,
                shadowColor: Colors.black.withOpacity(0.2),
                child: Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: selectedIndex == 2 ? Color(0xFF802629) : Colors.white,
                    border: Border.all(color: Colors.white, width: 4),
                  ),
                  child: Icon(
                    Icons.qr_code,
                    size: 32,
                    color: selectedIndex == 2 ? Colors.white : Colors.grey,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _NavBarIcon extends StatelessWidget {
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  const _NavBarIcon({
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10.0),
        child: Icon(
          icon,
          color: selected ? Color(0xFF802629) : Colors.grey.withOpacity(0.4),
          size: 28,
        ),
      ),
    );
  }
}

class WebviewPageSelector extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF8F8F8),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 48),
              Center(
                child: Image.asset(
                  'assets/images/logo.png',
                  height: 80,
                ),
              ),
              SizedBox(height: 24),
              Text(
                'Web Portals',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF802629),
                  letterSpacing: 1.2,
                ),
              ),
              SizedBox(height: 32),
              _MinimalButton(
                label: 'OnlineBeykoz',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => WebViewPage(url: 'https://online.beykoz.edu.tr'),
                    ),
                  );
                },
              ),
              SizedBox(height: 20),
              _MinimalButton(
                label: 'OIS',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => WebViewPage(url: 'https://ois.beykoz.edu.tr/'),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MinimalButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  const _MinimalButton({required this.label, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      elevation: 2,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onPressed,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 18),
          alignment: Alignment.center,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Color(0xFF802629),
              letterSpacing: 1.1,
            ),
          ),
        ),
      ),
    );
  }
} 