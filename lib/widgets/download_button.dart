import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/audio_controller.dart';
import '../controllers/download_controller.dart';

class DownloadButton extends StatelessWidget {
  DownloadButton({super.key});

  final audioCtrl = Get.find<AudioController>();
  final downloadCtrl = Get.find<DownloadController>();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        if (downloadCtrl.isDownloading.value) {
          //Show Progress
          return SizedBox(
            width: 32,
            height: 32,
            child: Stack(
              children: [
                CircularProgressIndicator(
                  value: downloadCtrl.progress.value,
                  strokeWidth: 3,
                ),
                Text(
                  (downloadCtrl.progress.value * 100).toStringAsFixed(0),
                  style: const TextStyle(fontSize: 10),
                ),
              ],
            ),
          );
        } else if (downloadCtrl.isDownloaded.value) {
          return IconButton(onPressed: () {}, icon: Icon(Icons.delete));
        } else {
          return IconButton(
            onPressed: () async {
              if (audioCtrl.selectedSurah.isEmpty ||
                  audioCtrl.selectedReciter.isEmpty) {
                Get.snackbar("تنبيه", "رجاءً اختر الشيخ والسورة أولاً",
                    duration: const Duration(seconds: 2),
                    backgroundColor: Colors.white,
                    colorText: Colors.red,
                    snackPosition: SnackPosition.BOTTOM);
                return;
              }
              await downloadCtrl.downloadFile(audioCtrl.getAudioLink()!,
                  audioCtrl.selectedReciter.value, audioCtrl.selectedSurah.value);
            },
            icon: const Icon(Icons.download),
          );
        }
      },
    );
  }
}
