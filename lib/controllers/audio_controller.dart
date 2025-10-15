import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AudioController extends GetxController {
  var selectedSurah = ''.obs;
  var selectedReciter = ''.obs;

  ///holds the base server URL for all surah recordings for the selectedReciter
  var selectedServer = ''.obs;
  var isPlaying = false.obs;

  var playIcon = Icons.play_arrow.obs;

  var descriptionText = 'اختر اسم الشيخ والسورة'.obs;

  void setSurah(String surahName) {
    selectedSurah.value = surahName;
    print('selectedSurah.value: ${selectedSurah.value}');
    print('selectedReciter.value: ${selectedReciter.value}');
    if (selectedReciter.isNotEmpty) {
      descriptionText.value =
          'سورة ${selectedSurah.value} - ${selectedReciter.value}';
    }
  }

  void setReciter(String reciterName) {
    selectedReciter.value = reciterName;
    print('selectedReciter.value: ${selectedReciter.value}');
    print('selectedSurah.value: ${selectedSurah.value}');
    if (selectedSurah.isNotEmpty) {
      descriptionText.value =
          'سورة ${selectedSurah.value} - ${selectedReciter.value}';
    }
  }

  void togglePlayback() {
    print('✅✅✅✅ $isPlaying');
    playIcon.value = isPlaying.value ? Icons.pause : Icons.play_arrow;
  }
}
