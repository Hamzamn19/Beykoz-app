package com.beykoz.beykoz

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import android.bluetooth.BluetoothAdapter
import android.bluetooth.le.AdvertiseCallback
import android.bluetooth.le.AdvertiseData
import android.bluetooth.le.AdvertiseSettings
import android.bluetooth.le.BluetoothLeAdvertiser
import android.os.Build
import android.os.ParcelUuid
import androidx.annotation.NonNull
import androidx.annotation.RequiresApi
import android.content.pm.PackageManager
import android.util.Log

class MainActivity : FlutterActivity() {
    private val CHANNEL = "com.beykoz.beykoz/ble_advertise"
    private var advertiser: BluetoothLeAdvertiser? = null
    private var advertiseCallback: AdvertiseCallback? = null

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "startAdvertising") {
                val sessionCode = call.argument<String>("sessionCode")
                Log.d("BleAdvertising", "Starting advertising with code: $sessionCode")
                startAdvertising(sessionCode ?: "000000")
                result.success(null)
            } else if (call.method == "stopAdvertising") {
                Log.d("BleAdvertising", "Stopping advertising")
                stopAdvertising()
                result.success(null)
            } else {
                result.notImplemented()
            }
        }
    }

    private fun ensureBluetoothAdvertisePermission(): Boolean {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
            if (checkSelfPermission(android.Manifest.permission.BLUETOOTH_ADVERTISE) != PackageManager.PERMISSION_GRANTED) {
                Log.w("BleAdvertising", "BLUETOOTH_ADVERTISE permission not granted")
                requestPermissions(arrayOf(android.Manifest.permission.BLUETOOTH_ADVERTISE), 1001)
                return false
            }
        }
        return true
    }

    private fun startAdvertising(sessionCode: String) {
        if (!ensureBluetoothAdvertisePermission()) {
            Log.e("BleAdvertising", "Permission check failed")
            return
        }
        
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.LOLLIPOP) {
            Log.e("BleAdvertising", "BLE advertising requires API level 21+")
            return
        }
        
        val bluetoothAdapter = BluetoothAdapter.getDefaultAdapter()
        if (bluetoothAdapter == null) {
            Log.e("BleAdvertising", "Bluetooth adapter is null")
            return
        }
        
        if (!bluetoothAdapter.isEnabled) {
            Log.e("BleAdvertising", "Bluetooth is not enabled")
            return
        }
        
        advertiser = bluetoothAdapter.bluetoothLeAdvertiser
        if (advertiser == null) {
            Log.e("BleAdvertising", "BLE advertiser is null")
            return
        }
        
        val serviceUuid = ParcelUuid.fromString("00001234-0000-1000-8000-00805f9b34fb")
        val settings = AdvertiseSettings.Builder()
            .setAdvertiseMode(AdvertiseSettings.ADVERTISE_MODE_LOW_LATENCY)
            .setTxPowerLevel(AdvertiseSettings.ADVERTISE_TX_POWER_HIGH)
            .setConnectable(false)
            .build()
            
        val manufacturerData = sessionCode.toByteArray(Charsets.UTF_8)
        val data = AdvertiseData.Builder()
            .setIncludeDeviceName(false)
            .addServiceUuid(serviceUuid)
            .addManufacturerData(0x1234, manufacturerData)
            .build()
            
        advertiseCallback = object : AdvertiseCallback() {
            override fun onStartSuccess(settingsInEffect: AdvertiseSettings) {
                super.onStartSuccess(settingsInEffect)
                Log.d("BleAdvertising", "Advertising started successfully")
            }
            override fun onStartFailure(errorCode: Int) {
                super.onStartFailure(errorCode)
                val errorMessage = when (errorCode) {
                    ADVERTISE_FAILED_ALREADY_STARTED -> "Already started"
                    ADVERTISE_FAILED_DATA_TOO_LARGE -> "Data too large"
                    ADVERTISE_FAILED_TOO_MANY_ADVERTISERS -> "Too many advertisers"
                    ADVERTISE_FAILED_INTERNAL_ERROR -> "Internal error"
                    ADVERTISE_FAILED_FEATURE_UNSUPPORTED -> "Feature unsupported"
                    else -> "Unknown error: $errorCode"
                }
                Log.e("BleAdvertising", "Advertising failed: $errorMessage")
            }
        }
        
        try {
            advertiser?.startAdvertising(settings, data, advertiseCallback)
            Log.d("BleAdvertising", "Started BLE advertising with session code: $sessionCode")
        } catch (e: Exception) {
            Log.e("BleAdvertising", "Exception starting advertising: ${e.message}")
        }
    }

    private fun stopAdvertising() {
        try {
            advertiser?.stopAdvertising(advertiseCallback)
            Log.d("BleAdvertising", "Stopped BLE advertising")
        } catch (e: Exception) {
            Log.e("BleAdvertising", "Exception stopping advertising: ${e.message}")
        }
        advertiser = null
        advertiseCallback = null
    }

    override fun onRequestPermissionsResult(requestCode: Int, permissions: Array<out String>, grantResults: IntArray) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults)
        if (requestCode == 1001 && grantResults.isNotEmpty() && grantResults[0] == PackageManager.PERMISSION_GRANTED) {
            Log.d("BleAdvertising", "BLUETOOTH_ADVERTISE permission granted")
            // Optionally, you could retry advertising here if needed
        } else {
            Log.w("BleAdvertising", "BLUETOOTH_ADVERTISE permission denied")
        }
    }
}
