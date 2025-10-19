import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

///Instead of extracting permission request to a method (modularization)
///inside audio_controllers, it would be better to extract it in an entire utility class
///as permissions are multiple, so maintaining them in methods inside the AudioController
///is messy. Also, such separation aids clean code (single responsibility)
class PermissionService {
  ///Request permission (Android) using the permission_handler dependency
  static Future<bool> requestStoragePermission() async {
    print('✅✅✅✅✅✅✅✅ requestStoragePermission()');

    if (!Platform.isAndroid) return true;

    //Extract the SDK version number from Platform.version (e.g. "34 (Android 14)" → 34)
    //final sdk = int.tryParse(Platform.version.split(' ').first) ?? 0;
    ///Above line is not correct, we can’t directly get sdk from Dart without a plugin —
    ///so the most reliable solution is to use device_info_plus dependency/plugin
    final androidInfo = await DeviceInfoPlugin().androidInfo;
    final sdk = androidInfo.version.sdkInt;

    /// Android 12 and below use legacy storage permission, whereas Android +13 uses media-specific permissions.
    Permission permission = sdk >= 33 ? Permission.audio : Permission.storage;

    // Check current status
    final status = await permission.status;

    // 🟥 Case 1: Permanently denied → tell user to enable manually
    if (status.isPermanentlyDenied) {
      print('✅✅✅✅✅✅✅✅ case 1: status.isPermanentlyDenied');
      Get.snackbar(
        "تنبيه",
        "يجب تفعيل الإذن من إعدادات التطبيق يدويًا",
        duration: const Duration(seconds: 3),
        backgroundColor: Colors.white,
        colorText: Colors.red,
        snackPosition: SnackPosition.BOTTOM,
        mainButton: TextButton(
          onPressed: () => openAppSettings(),
          child: const Text("فتح الإعدادات"),
        ),
      );
      return false;
    }

    // 🟡 Case 2: Request if not yet granted
    if (!status.isGranted) {
      print('✅✅✅✅✅✅✅✅ case 2: !status.isGranted');

      final result = await permission.request();
      return result.isGranted;
    }

    print('✅✅✅✅✅✅✅✅ case 3: Already granted, should return true');
    // 🟢 Case 3: Already granted
    return true;
  }
}
