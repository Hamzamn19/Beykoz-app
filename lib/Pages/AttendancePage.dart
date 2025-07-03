import 'package:beykoz/Services/ble_advertising_service.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'dart:async';
import 'package:permission_handler/permission_handler.dart';
import 'package:beykoz/Pages/TeacherAttendancePage.dart';
import 'package:beykoz/Pages/StudentAttendancePage.dart';

class AttendanceScreen extends StatefulWidget {
  final String? role;
  const AttendanceScreen({super.key, this.role});

  @override
  _AttendanceScreenState createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  String? _role; // 'teacher' or 'student'
  String? _sessionCode;
  DiscoveredDevice? _advertisedDevice;
  bool _isAdvertising = false;
  late FlutterReactiveBle _ble;
  late Uuid _serviceUuid;
  late Uuid _charUuid;
  StreamSubscription<GenericFailure>? _advertiseSub;
  final TextEditingController _sessionCodeController = TextEditingController();
  bool _isScanning = false;
  String? _scanResultMessage;
  final List<String> _debugLogs = []; // Add debug logging
  bool _permissionsGranted = false;

  @override
  void initState() {
    super.initState();
    _ble = FlutterReactiveBle();
    _addDebugLog('BLE service initialized');
    _checkAndRequestPermissions();
  }

  @override
  void dispose() {
    _stopAdvertising();
    super.dispose();
  }

  Future<void> _checkAndRequestPermissions() async {
    _addDebugLog('Checking permissions...');
    
    // For BLE functionality, we primarily need location permissions
    // Bluetooth permissions are often handled differently on different Android versions
    var locationStatus = await Permission.location.status;
    var locationWhenInUseStatus = await Permission.locationWhenInUse.status;
    
    _addDebugLog('Location: $locationStatus');
    _addDebugLog('Location When In Use: $locationWhenInUseStatus');
    
    // Request location permissions (required for BLE scanning)
    if (locationStatus != PermissionStatus.granted) {
      locationStatus = await Permission.location.request();
      _addDebugLog('Location request result: $locationStatus');
    }
    
    if (locationWhenInUseStatus != PermissionStatus.granted) {
      locationWhenInUseStatus = await Permission.locationWhenInUse.request();
      _addDebugLog('Location When In Use request result: $locationWhenInUseStatus');
    }
    
    // Check Bluetooth permissions but don't fail if they're denied
    // Many devices handle Bluetooth permissions differently
    var bluetoothStatus = await Permission.bluetooth.status;
    var bluetoothScanStatus = await Permission.bluetoothScan.status;
    var bluetoothConnectStatus = await Permission.bluetoothConnect.status;
    var bluetoothAdvertiseStatus = await Permission.bluetoothAdvertise.status;
    
    _addDebugLog('Bluetooth: $bluetoothStatus');
    _addDebugLog('Bluetooth Scan: $bluetoothScanStatus');
    _addDebugLog('Bluetooth Connect: $bluetoothConnectStatus');
    _addDebugLog('Bluetooth Advertise: $bluetoothAdvertiseStatus');
    
    // Try to request Bluetooth permissions but don't block if denied
    if (bluetoothStatus != PermissionStatus.granted) {
      bluetoothStatus = await Permission.bluetooth.request();
      _addDebugLog('Bluetooth request result: $bluetoothStatus');
    }
    
    if (bluetoothScanStatus != PermissionStatus.granted) {
      bluetoothScanStatus = await Permission.bluetoothScan.request();
      _addDebugLog('Bluetooth Scan request result: $bluetoothScanStatus');
    }
    
    if (bluetoothConnectStatus != PermissionStatus.granted) {
      bluetoothConnectStatus = await Permission.bluetoothConnect.request();
      _addDebugLog('Bluetooth Connect request result: $bluetoothConnectStatus');
    }
    
    if (bluetoothAdvertiseStatus != PermissionStatus.granted) {
      bluetoothAdvertiseStatus = await Permission.bluetoothAdvertise.request();
      _addDebugLog('Bluetooth Advertise request result: $bluetoothAdvertiseStatus');
    }
    
    // Consider permissions granted if we have location permissions
    // Bluetooth permissions are often handled by the system automatically
    bool hasLocationPermissions = locationStatus == PermissionStatus.granted || 
                                 locationWhenInUseStatus == PermissionStatus.granted;
    
    setState(() {
      _permissionsGranted = hasLocationPermissions;
    });
    
    if (_permissionsGranted) {
      _addDebugLog('Location permissions granted - BLE should work!');
    } else {
      _addDebugLog('Location permissions denied. BLE scanning will not work.');
      _addDebugLog('Please enable location services and grant location permission.');
    }
  }

  void _addDebugLog(String message) {
    if (!mounted) return;
    setState(() {
      _debugLogs.add('${DateTime.now().toString().substring(11, 19)}: $message');
      if (_debugLogs.length > 10) {
        _debugLogs.removeAt(0);
      }
    });
  }

  void _startAdvertising() async {
    try {
      // Generate a random 6-digit session code
      final code = (Random().nextInt(900000) + 100000).toString();
      _addDebugLog('Starting advertising with code: $code');
      if (!mounted) return;
      setState(() {
        _sessionCode = code;
        _isAdvertising = true;
      });
      await BleAdvertisingService.startAdvertising(code);
      _addDebugLog('Advertising started successfully');
    } catch (e) {
      _addDebugLog('Error starting advertising: $e');
      if (!mounted) return;
      setState(() {
        _isAdvertising = false;
        _sessionCode = null;
      });
    }
  }

  void _stopAdvertising() async {
    try {
      await BleAdvertisingService.stopAdvertising();
      _addDebugLog('Advertising stopped');
      if (!mounted) return;
      setState(() {
        _isAdvertising = false;
        _sessionCode = null;
      });
    } catch (e) {
      _addDebugLog('Error stopping advertising: $e');
    }
  }

  void _scanForTeacher() async {
    if (!_permissionsGranted) {
      if (!mounted) return;
      setState(() {
        _scanResultMessage = 'Gerekli izinler verilmedi. Lütfen uygulama ayarlarından izinleri kontrol edin.';
      });
      _addDebugLog('Scan failed: permissions not granted');
      return;
    }
    
    final code = _sessionCodeController.text.trim();
    if (code.length != 6) {
      if (!mounted) return;
      setState(() {
        _scanResultMessage = 'Lütfen 6 haneli bir oturum kodu girin.';
      });
      return;
    }
    
    _addDebugLog('Starting scan for code: $code');
    if (!mounted) return;
    setState(() {
      _isScanning = true;
      _scanResultMessage = null;
    });
    
    final serviceUuid = Uuid.parse('00001234-0000-1000-8000-00805f9b34fb');
    final ble = FlutterReactiveBle();
    bool found = false;
    late StreamSubscription<DiscoveredDevice> subscription;
    
    subscription = ble.scanForDevices(withServices: [serviceUuid], scanMode: ScanMode.lowLatency).listen((device) {
      _addDebugLog('Found device: ${device.name} (${device.id})');
      _addDebugLog('Device services: ${device.serviceUuids}');
      
      // Check manufacturer data for session code
      final manufacturerData = device.manufacturerData;
      if (manufacturerData.isNotEmpty) {
        _addDebugLog('Raw manufacturer data length: ${manufacturerData.length}');
        _addDebugLog('Raw manufacturer data: ${manufacturerData.map((b) => b.toRadixString(16).padLeft(2, '0')).join(' ')}');
        
        // Manufacturer data format: [Company ID (2 bytes)] + [Data]
        // Company ID 0x1234 = [0x34, 0x12] (little endian)
        if (manufacturerData.length >= 3) {
          // Check if this is our company ID (0x1234)
          final companyId = manufacturerData[0] | (manufacturerData[1] << 8);
          _addDebugLog('Company ID: 0x${companyId.toRadixString(16).padLeft(4, '0')}');
          
          if (companyId == 0x1234) {
            // Extract the data portion (skip first 2 bytes)
            final dataBytes = manufacturerData.sublist(2);
            final codeStr = String.fromCharCodes(dataBytes);
            _addDebugLog('Extracted session code: $codeStr');
            
            if (codeStr == code) {
              found = true;
              if (!mounted) return;
              setState(() {
                _isScanning = false;
                _scanResultMessage = 'Yoklama başarıyla bulundu!';
              });
              _addDebugLog('Session code matched! Attendance successful.');
              subscription.cancel();
            } else {
              _addDebugLog('Session code mismatch: expected $code, got $codeStr');
            }
          } else {
            _addDebugLog('Wrong company ID, skipping device');
          }
        } else {
          _addDebugLog('Manufacturer data too short');
        }
      } else {
        _addDebugLog('No manufacturer data found');
      }
    }, onError: (e) {
      _addDebugLog('Scan error: $e');
      if (!mounted) return;
      setState(() {
        _isScanning = false;
        _scanResultMessage = 'Tarama sırasında hata oluştu: $e';
      });
    });
    
    // Timeout after 15 seconds (increased from 10)
    await Future.delayed(const Duration(seconds: 15));
    if (!found) {
      await subscription.cancel();
      if (!mounted) return;
      setState(() {
        _isScanning = false;
        _scanResultMessage = 'Yakındaki öğretmen bulunamadı.';
      });
      _addDebugLog('Scan timeout - no matching device found');
    }
  }

  Future<void> _openAppSettings() async {
    await openAppSettings();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          SizedBox(height: 24),
          Center(
            child: Image.asset(
              'assets/images/logo.png',
              height: 64,
            ),
          ),
          SizedBox(height: 16),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildRoleSelector(),
                  const SizedBox(height: 16),
                  _buildPermissionStatus(),
                  const SizedBox(height: 16),
                  const SizedBox(height: 16),
                  _buildDebugLogs(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRoleSelector() {
    return Card(
      color: const Color(0xFFECECEC),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Rolünüzü Seçin',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF802629),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildRoleButton('Öğretmen', 'teacher'),
                _buildRoleButton('Öğrenci', 'student'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRoleButton(String label, String value) {
    final bool selected = _role == value;
    return ElevatedButton(
      onPressed: () {
        if (value == 'teacher') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => TeacherAttendancePage()),
          );
        } else if (value == 'student') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => StudentAttendancePage()),
          );
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: selected ? const Color(0xFF802629) : const Color(0xFFECECEC),
        foregroundColor: selected ? Colors.white : const Color(0xFF802629),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      ),
      child: Text(label, style: const TextStyle(fontSize: 16)),
    );
  }

  Widget _buildDebugLogs() {
    return Card(
      color: const Color(0xFFF5F5F5),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Debug Logs',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF802629),
              ),
            ),
            const SizedBox(height: 8),
            Container(
              height: 120,
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.black87,
                borderRadius: BorderRadius.circular(8),
              ),
              child: ListView.builder(
                itemCount: _debugLogs.length,
                itemBuilder: (context, index) {
                  return Text(
                    _debugLogs[index],
                    style: const TextStyle(
                      color: Colors.green,
                      fontSize: 12,
                      fontFamily: 'monospace',
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPermissionStatus() {
    return Card(
      color: _permissionsGranted ? const Color(0xFFE8F5E8) : const Color(0xFFFFEBEE),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  _permissionsGranted ? Icons.check_circle : Icons.warning,
                  color: _permissionsGranted ? Colors.green : Colors.orange,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    _permissionsGranted 
                      ? 'Konum izni verildi - BLE çalışabilir' 
                      : 'Konum izni gerekli (BLE tarama için)',
                    style: TextStyle(
                      color: _permissionsGranted ? Colors.green : Colors.orange,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            if (!_permissionsGranted) ...[
              const SizedBox(height: 8),
              const Text(
                'Bluetooth Low Energy taraması için konum izni gereklidir. '
                'Lütfen konum servislerini etkinleştirin ve konum iznini verin.',
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: _checkAndRequestPermissions,
                      child: const Text('İzin Ver'),
                    ),
                  ),
                  TextButton(
                    onPressed: _openAppSettings,
                    child: const Text('Ayarlar'),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
} 