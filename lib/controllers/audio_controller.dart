import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:quran_mp3/controllers/reciters_controller.dart';
import 'package:quran_mp3/data/surah_and_reciters_list.dart';
import 'package:quran_mp3/services/permission_service.dart';

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

  var currentPosition = Duration.zero.obs;
  var totalDuration = Duration.zero.obs;
  var isCompleted = false.obs;

  final _dio = Dio();

  @override
  void onInit() {
    super.onInit();
    _audioPlayer = AudioPlayer();

    _audioPlayer.onDurationChanged.listen((d) {
      print('✅✅✅✅ onDurationChanged: ${d.inSeconds}');
      totalDuration.value = d;
    });
    _audioPlayer.onPositionChanged.listen((p) => currentPosition.value = p);
    _audioPlayer.onPlayerComplete.listen((_) {
      print('✅✅✅✅✅✅✅✅✅ onPlayerComplete');
      isCompleted.value = true;
      isResumed.value = false;
      playIcon.value = Icons.play_arrow;
    });
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
    // if playback previously completed, restart from beginning
    if (isCompleted.isTrue) {
      //I tried to seek it to Duration.zero and then resume playback
      //as a more efficient solution than the quite bit intensive playNew() function, but it didn't work
      await playNew();
    } else if (isNewSelection.isTrue) {
      await playNew();
      isNewSelection.value = false;
    } else {
      await _audioPlayer.resume();
    }

    isResumed.value = true;
    playIcon.value = Icons.pause;
  }

  Future<void> pause() async {
    await _audioPlayer.pause();
    isResumed.value = false;
    playIcon.value = Icons.play_arrow;
  }

  Future<void> playNew() async {
    isCompleted.value = false;
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
    return null;
  }

  Future<void> seekForward() async {
    final position = await _audioPlayer.getCurrentPosition();
    final duration = await _audioPlayer.getDuration();

    if (position != null && duration != null) {
      final newPosition = position + const Duration(seconds: 10);
      if (newPosition < duration) {
        await _audioPlayer.seek(newPosition);
      } else {
        await _audioPlayer.seek(duration);
      }
    }
  }

  Future<void> seekBackward() async {
    final position = await _audioPlayer.getCurrentPosition();
    if (position != null) {
      final newPosition = position - const Duration(seconds: 10);
      await _audioPlayer
          .seek(newPosition < Duration.zero ? Duration.zero : newPosition);
    }
  }

  Future<void> seekTo(Duration duration) async {
    await _audioPlayer.seek(duration);
  }

  Future<void> download() async {
    if (selectedSurah.isEmpty || selectedReciter.isEmpty) {
      // Fluttertoast.showToast(
      //   msg: "رجاء، اختر الشيخ والسورة",
      //   gravity: ToastGravity.BOTTOM,
      //   backgroundColor: Colors.redAccent,
      // );
      Get.snackbar("تنبيه", "رجاءً اختر الشيخ والسورة أولاً",
          duration: const Duration(seconds: 2),
          backgroundColor: Colors.white,
          colorText: Colors.red,
          snackPosition: SnackPosition.BOTTOM);
      return;
    }

    //Check for storage permission
    final hasPermission = await PermissionService.requestStoragePermission();
    if (!hasPermission) return;

    // ✅ Now safe to proceed with downloading
    //Get app dir
    final appDir = await getApplicationDocumentsDirectory();
    //rather than downloading every file in a single dir, we'll create
    // a folder for each reciter, so it's organized and easy to manage
    final reciterFolder =
        Directory('${appDir.path}/QuranMp3/${selectedReciter.value}');
    if (!await reciterFolder.exists()) {
      await reciterFolder.create(recursive: true);
      print('✅✅✅✅✅✅✅✅ reciterFolder path: ${reciterFolder.path}');
    }

    //File path
    final filePath = '${reciterFolder.path}/${selectedSurah.value}.mp3';
    try {
      _dio.download(
        getRecitationLink()!,
        filePath,
        onReceiveProgress: (received, total) {
          if (total > 0) {
            //  print('Percentage: ${(received / total * 100).toStringAsFixed(0)}');
          }
        },
      );
      Get.snackbar("اكتمل التحميل", "تم حفظ السورة بنجاح",
          duration: const Duration(seconds: 2),
          backgroundColor: Colors.white54,
          colorText: Colors.green,
          snackPosition: SnackPosition.BOTTOM);
    } catch (e) {
      Get.snackbar("خطأ", "فشل التحميل",
          duration: const Duration(seconds: 2),
          backgroundColor: Colors.white54,
          colorText: Colors.red,
          snackPosition: SnackPosition.BOTTOM);
    }
  }
}
