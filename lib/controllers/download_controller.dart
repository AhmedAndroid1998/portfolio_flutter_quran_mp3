import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';

import '../services/permission_service.dart';

///Modal representing one ongoing or completed  download
class DownloadItem {
  final String surah;
  final String reciter;

  /// 0.0 → 1.0
  final RxDouble progress;
  var downloadingProgress = ''.obs;
  final RxBool isDownloaded;

  DownloadItem({
    required this.surah,
    required this.reciter,
    double initialProgress = 0.0,
    bool downloaded = false,
  })  : progress = initialProgress.obs,
        isDownloaded = downloaded.obs;
}

class DownloadController extends GetxController {
  var isDownloading = false.obs;
  var isDownloaded = false.obs;

  /// 0.0 → 1.0
  var progress = 0.0.obs;
  final _dio = Dio();

  /// Track all active downloads for the "Downloading" tab
  final downloads = <DownloadItem>[].obs;

  Future<void> checkIfDownloaded(String folder, String fileName) async {
    print('✅✅✅✅✅✅✅ checkIfDownloaded');
    final appDir = await getApplicationDocumentsDirectory();
    final filePath = '${appDir.path}/QuranMp3/$folder/$fileName.mp3';
    isDownloaded.value = await File(filePath).exists();
  }

  /// Add a download entry for UI tracking
  void addDownloadEntry(String reciter, String surah) {
    final item = DownloadItem(reciter: reciter, surah: surah);
    downloads.add(item);
  }

  Future<void> downloadFile(String url, String folder, String fileName) async {
    //First, Check for storage permission first
    final hasPermission = await PermissionService.requestStoragePermission();
    if (!hasPermission) return;

    // ✅ Now safe to proceed with downloading
    isDownloading.value = true;
    progress.value = 0.0;

    // Add to observable list for "DownloadingFilesTab"
    addDownloadEntry(folder, fileName);
    final currentItem = downloads.last;

    //Get app dir
    final appDir = await getApplicationDocumentsDirectory();
    final reciterFolder = Directory('${appDir.path}/QuranMp3/$folder');
    if (!await reciterFolder.exists()) {
      await reciterFolder.create(recursive: true);
      //print('✅✅✅✅✅✅✅✅ reciterFolder path: ${reciterFolder.path}');
    }

    //File path
    final filePath = '${reciterFolder.path}/$fileName.mp3';

    try {
      progress.value = 0.0;

      await _dio.download(
        url,
        filePath,
        onReceiveProgress: (received, total) {
          if (total > 0) {
            final value = received / total;
            progress.value = value;
            currentItem.progress.value = value;

            final progressSizeInKB = received / 1024;
            final progressSizeInMB = received / (1024 * 1024);

            final totalSizeInKB = total / 1024;
            final totalSizeInMB = total / (1024 * 1024);

            currentItem.downloadingProgress.value = progressSizeInMB >= 1
                ? 'MB ${progressSizeInMB.toStringAsFixed(2)}   من MB ${totalSizeInMB.toStringAsFixed(2)}'
                : 'KB ${progressSizeInKB.toStringAsFixed(2)}  من KB ${totalSizeInKB.toStringAsFixed(2)}';
          }
        },
      );

      isDownloading.value = false;
      isDownloaded.value = true;
      currentItem.isDownloaded.value = true;

      Fluttertoast.showToast(
          msg: "تم حفظ السورة بنجاح",
          backgroundColor: Colors.green,
          textColor: Colors.white,
          gravity: ToastGravity.BOTTOM_RIGHT);
    } catch (e) {
      Get.snackbar("خطأ", "فشل التحميل",
          duration: const Duration(seconds: 2),
          backgroundColor: Colors.white54,
          colorText: Colors.red,
          snackPosition: SnackPosition.BOTTOM);
      isDownloading.value = false;
      print("❌ Download failed: $e");
      downloads.remove(currentItem);
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
