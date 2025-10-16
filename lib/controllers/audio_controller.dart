import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quran_mp3/controllers/reciters_controller.dart';
import 'package:quran_mp3/data/surah_and_reciters_list.dart';

class AudioController extends GetxController {
  var selectedSurah = ''.obs;
  var selectedReciter = ''.obs;

  ///holds the base server URL for all surah recordings for the selectedReciter
  var selectedServer = ''.obs;
  var isResumed = false.obs;
  var isNewSelection = false.obs;

  var playIcon = Icons.play_arrow.obs;

  var descriptionText = 'اختر اسم الشيخ والسورة'.obs;

  final recitersCtrl = Get.put(RecitersController());

  late final AudioPlayer _audioPlayer;

  @override
  void onInit() {
    super.onInit();
    _audioPlayer = AudioPlayer();
  }

  void setSurah(String surahName) {
    selectedSurah.value = surahName;
    print('selectedSurah.value: ${selectedSurah.value}');
    print('selectedReciter.value: ${selectedReciter.value}');
    if (selectedReciter.isNotEmpty) {
      descriptionText.value =
          'سورة ${selectedSurah.value} - ${selectedReciter.value}';

      isNewSelection.value = true;
      if (isResumed.isTrue) playNew();
    }
  }

  void setReciter(String reciterName) {
    selectedReciter.value = reciterName;
    print('selectedReciter.value: ${selectedReciter.value}');
    print('selectedSurah.value: ${selectedSurah.value}');
    if (selectedSurah.isNotEmpty) {
      descriptionText.value =
          'سورة ${selectedSurah.value} - ${selectedReciter.value}';

      isNewSelection.value = true;
      if (isResumed.isTrue) playNew();
    }
  }

  Future<void> play() async {
    if (isNewSelection.isTrue) {
      playNew();
      isNewSelection.value = false;
    } else {
      await _audioPlayer.resume();
    }
  }

  Future<void> pause() async {
    _audioPlayer.pause();
  }

  Future<void> playNew() async {
    final audioUrl = getRecitationLink();
    await _audioPlayer.play(UrlSource(audioUrl!));
  }

  String? getRecitationLink() {
    final server = recitersCtrl.recitations[selectedReciter.value];

    if (server!.isNotEmpty && selectedSurah.isNotEmpty) {
      final s = surahNames.indexOf(selectedSurah.value) + 1;
      final surahString = s.toString().padLeft(3, '0');
      final audioUrl = '$server$surahString.mp3';
      print('✅✅✅ audioUrl: $audioUrl');
      return audioUrl;
    }
  }
}
