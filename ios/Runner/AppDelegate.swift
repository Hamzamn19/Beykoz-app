import Flutter
import UIKit
import CoreBluetooth

@main
@objc class AppDelegate: FlutterAppDelegate {
  var peripheralManager: CBPeripheralManager?
  var advertisementData: [String: Any]?

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
    let channel = FlutterMethodChannel(name: "com.beykoz.beykoz/ble_advertise",
                                       binaryMessenger: controller.binaryMessenger)
    channel.setMethodCallHandler({ [weak self] (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
      if call.method == "startAdvertising" {
        if let args = call.arguments as? [String: Any], let sessionCode = args["sessionCode"] as? String {
          self?.startAdvertising(sessionCode: sessionCode)
          result(nil)
        } else {
          result(FlutterError(code: "INVALID_ARGUMENT", message: "Missing sessionCode", details: nil))
        }
      } else if call.method == "stopAdvertising" {
        self?.stopAdvertising()
        result(nil)
      } else {
        result(FlutterMethodNotImplemented)
      }
    })
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  func startAdvertising(sessionCode: String) {
    if peripheralManager == nil {
      peripheralManager = CBPeripheralManager(delegate: nil, queue: nil)
    }
    // Create a 128-bit UUID from the session code (pad to 32 chars)
    let uuidStr = "0000\(sessionCode)-0000-1000-8000-00805f9b34fb"
    let serviceUUID = CBUUID(string: uuidStr)
    advertisementData = [
      CBAdvertisementDataServiceUUIDsKey: [serviceUUID],
      CBAdvertisementDataLocalNameKey: "BeykozAttendance"
    ]
    peripheralManager?.stopAdvertising()
    peripheralManager?.startAdvertising(advertisementData)
  }

  func stopAdvertising() {
    peripheralManager?.stopAdvertising()
  }
}
