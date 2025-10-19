import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';

import '../services/permission_service.dart';

class DownloadController extends GetxController {
  var isDownloading = false.obs;
  var isDownloaded = false.obs;
  var progress = 0.0.obs;
  final _dio = Dio();

  Future<void> checkIfDownloaded(String folder, String fileName) async {
    final appDir = await getApplicationDocumentsDirectory();
    final filePath = '${appDir.path}/QuranMp3/$folder/$fileName.mp3';
    isDownloaded.value = await File(filePath).exists();
  }

  Future<void> downloadFile(String url, String folder, String fileName) async {
    //First, Check for storage permission first
    final hasPermission = await PermissionService.requestStoragePermission();
    if (!hasPermission) return;

    // ✅ Now safe to proceed with downloading
    isDownloading.value = true;
    progress.value = 0.0;

    //Get app dir
    final appDir = await getApplicationDocumentsDirectory();
    final reciterFolder = Directory('${appDir.path}/QuranMp3/$folder');
    if (!await reciterFolder.exists()) {
      await reciterFolder.create(recursive: true);
      print('✅✅✅✅✅✅✅✅ reciterFolder path: ${reciterFolder.path}');
    }

    //File path
    final filePath = '${reciterFolder.path}/$fileName.mp3';

    final stopwatch = Stopwatch()..start();
    try {
      _dio.download(
        url,
        filePath,
        onReceiveProgress: (received, total) {
          if (total > 0) {
            progress.value = received / total;
            // print('Percentage: ${(received / total * 100).toStringAsFixed(0)}');
          }
        },
      );
      Fluttertoast.showToast(
          msg: "تم حفظ السورة بنجاح",
          backgroundColor: Colors.green,
          textColor: Colors.white,
          gravity: ToastGravity.BOTTOM_RIGHT);

      stopwatch.stop();

      // 🕐 Ensure visible duration (e.g., at least 2 seconds)
      final elapsed = stopwatch.elapsedMilliseconds;
      if (elapsed < 2000) {
        await Future.delayed(Duration(milliseconds: 2000 - elapsed));
      }

      isDownloading.value = false;
      isDownloaded.value = true;
    } catch (e) {
      Get.snackbar("خطأ", "فشل التحميل",
          duration: const Duration(seconds: 2),
          backgroundColor: Colors.white54,
          colorText: Colors.red,
          snackPosition: SnackPosition.BOTTOM);
      isDownloading.value = false;
      print("❌ Download failed: $e");
    }
  }

  Future<void> deleteFile(String folder, String fileName) async {
    print('❌❌❌ trying to delete.....');
    final appDir = await getApplicationDocumentsDirectory();
    final file = File('${appDir.path}/QuranMp3/$folder/$fileName.mp3');
    if (await file.exists()) {
      await file.delete();
      isDownloaded.value = false;
      print('❌❌❌ File exists');
    } else {
      print('❌❌❌ File DOES NOT exists');
    }
  }
}
