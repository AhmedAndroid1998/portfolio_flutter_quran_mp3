import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quran_mp3/controllers/downloads_list_controler.dart';

import '../controllers/audio_controller.dart';
import '../controllers/download_controller.dart';

class DownloadButton extends StatelessWidget {
  DownloadButton({super.key});

  final audioCtrl = Get.find<AudioController>();
  final downloadCtrl = Get.find<DownloadController>();
  final downloadsListCtrl = Get.find<DownloadsListController>();

  @override
  Widget build(BuildContext context) {
    //Whenever user changes surah/reciter, check file state so you can load the appropriate button
    everAll(
      [audioCtrl.selectedSurah, audioCtrl.selectedReciter],
      (_) {
        final reciter = audioCtrl.selectedReciter.value;
        final surah = audioCtrl.selectedSurah.value;

        // Run only if both are selected
        if (reciter.isNotEmpty && surah.isNotEmpty) {
          downloadCtrl.checkIfDownloaded(reciter, surah);
        }
      },
    );

    return Obx(
      () {
        if (downloadCtrl.isDownloading.value) {
          //Show Progress
          return SizedBox(
            width: 32,
            height: 32,
            child: Stack(
              alignment: Alignment.center,
              children: [
                CircularProgressIndicator(
                  value: downloadCtrl.progress.value,
                  strokeWidth: 3,
                  color: Colors.red,
                ),
                Text(
                  (downloadCtrl.progress.value * 100).toStringAsFixed(0),
                  style: const TextStyle(fontSize: 10),
                ),
              ],
            ),
          );
        }
        if (downloadCtrl.isDownloaded.value) {
          return IconButton(
            onPressed: () async {
              await downloadCtrl.deleteFile(
                  audioCtrl.selectedReciter.value, audioCtrl.selectedSurah.value);
              await downloadsListCtrl.loadDownloads();
            },
            icon: const Icon(
              Icons.delete_forever,
              color: Colors.blueGrey,
            ),
          );
        }

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
            await downloadCtrl.downloadFile(
                audioCtrl.getAudioLink(audioCtrl.selectedSurah.value)!,
                audioCtrl.selectedReciter.value,
                audioCtrl.selectedSurah.value);
            await downloadsListCtrl.loadDownloads();
          },
          icon: const Icon(Icons.download),
        );
      },
    );
  }
}
