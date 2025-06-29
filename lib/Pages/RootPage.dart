import 'package:beykoz/Pages/AttendancePage.dart';
import 'package:beykoz/Pages/HomePage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:webview_flutter/webview_flutter.dart';
import 'dart:convert';
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
                    color: selectedIndex == 2
                        ? Color(0xFF802629)
                        : Colors.white,
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
              Center(child: Image.asset('assets/images/logo.png', height: 80)),
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
                      builder: (context) =>
                          WebViewPage(url: 'https://online.beykoz.edu.tr'),
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
                      builder: (context) =>
                          WebViewPage(url: 'https://ois.beykoz.edu.tr/'),
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

class WebViewPage extends StatefulWidget {
  final String url;

  const WebViewPage({Key? key, required this.url}) : super(key: key);

  @override
  _WebViewPageState createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage> {
  late WebViewController _webViewController;

  @override
  void initState() {
    super.initState();
    // No need to call _solveAndFillCaptcha here, it will be done on page load
  }

  Future<String?> solveCaptchaBase64(String base64, {int retry = 0}) async {
    const String ngrokUrl = 'https://7386-94-103-124-251.ngrok-free.app';
    try {
      final response = await http.post(
        Uri.parse('$ngrokUrl/solve_captcha_base64'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'image_base64': base64}),
      );
      print('Captcha server response: ${response.statusCode} ${response.body}');
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final captcha = data['captcha'];
        // تحقق من أن الكابتشا 4 خانات أو أكثر
        if (captcha != null && captcha is String && captcha.length >= 4) {
          return captcha;
        } else if (retry < 3) {
          print('Captcha too short, retrying... (attempt ${retry + 2})');
          // أعد المحاولة بعد فترة قصيرة
          await Future.delayed(Duration(milliseconds: 700));
          return await solveCaptchaBase64(base64, retry: retry + 1);
        } else {
          print('Captcha too short after retries.');
          return null;
        }
      } else {
        // Show error details in a SnackBar for debugging
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Server error: ${response.statusCode}\n${response.body}',
              ),
              backgroundColor: Colors.red,
              duration: Duration(seconds: 5),
            ),
          );
        }
        print(
          'Failed to solve CAPTCHA: ${response.statusCode} ${response.body}',
        );
        return null;
      }
    } catch (e) {
      print('Error solving CAPTCHA: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Exception while connecting to server: $e'),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 5),
          ),
        );
      }
      return null;
    }
  }

  void _extractAndSolveCaptcha() async {
    String js = """
      (function() {
        var img = document.getElementById('img_captcha');
        if (!img) {
          if (window.Flutter) window.Flutter.postMessage("NO_IMG_FOUND");
          return;
        }
        function sendImage() {
          try {
            var canvas = document.createElement('canvas');
            canvas.width = img.naturalWidth || img.width;
            canvas.height = img.naturalHeight || img.height;
            var ctx = canvas.getContext('2d');
            ctx.drawImage(img, 0, 0, canvas.width, canvas.height);
            var dataURL = canvas.toDataURL('image/png');
            if (window.Flutter) window.Flutter.postMessage(dataURL.replace(/^data:image\\/png;base64,/, ''));
          } catch (e) {
            if (window.Flutter) window.Flutter.postMessage("CAPTCHA_CAPTURE_ERROR:" + e);
          }
        }
        // مراقبة تغيّر src للصورة
        var lastSrc = img.src;
        var observer = new MutationObserver(function(mutations) {
          mutations.forEach(function(mutation) {
            if (mutation.type === 'attributes' && mutation.attributeName === 'src') {
              if (img.src !== lastSrc) {
                lastSrc = img.src;
                // انتظر حتى يتم تحميل الصورة الجديدة
                if (!img.complete || img.naturalWidth === 0) {
                  img.onload = function() { sendImage(); };
                  return;
                }
                sendImage();
              }
            }
          });
        });
        observer.observe(img, { attributes: true, attributeFilter: ['src'] });

        // إرسال الصورة أول مرة
        if (!img.complete || img.naturalWidth === 0) {
          img.onload = function() { sendImage(); };
          return;
        }
        sendImage();
      })();
    """;
    await _webViewController.runJavaScript(js);
  }

  void _fillCaptchaField(String captcha) async {
    String js = "document.getElementById('captcha').value = '$captcha';";
    await _webViewController.runJavaScript(js);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('CAPTCHA sent successfully!'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.url.contains('ois') ? 'OIS' : 'OnlineBeykoz'),
      ),
      body: WebViewWidget(
        controller: _webViewController = WebViewController()
          ..setJavaScriptMode(JavaScriptMode.unrestricted)
          ..setNavigationDelegate(
            NavigationDelegate(
              onPageFinished: (String url) {
                if (widget.url == 'https://ois.beykoz.edu.tr/') {
                  _extractAndSolveCaptcha();
                }
              },
            ),
          )
          ..addJavaScriptChannel(
            'Flutter',
            onMessageReceived: (JavaScriptMessage message) async {
              print("Received from JS: ${message.message}");
              if (message.message == "NO_IMG_FOUND") {
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('CAPTCHA image not found on the page!'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
                return;
              }
              String base64 = message.message;
              String? captcha = await solveCaptchaBase64(base64);
              if (captcha != null) {
                _fillCaptchaField(captcha);
              } else if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Failed to solve CAPTCHA!'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
          )
          ..setOnConsoleMessage((message) {
            print('WebView Console: ${message.message}');
          })
          ..setUserAgent(
            'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36',
          )
          ..loadRequest(Uri.parse(widget.url)),
      ),
    );
  }
}
