import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:quran_mp3/data/surah_and_reciters_list.dart';
import 'package:quran_mp3/services/reciters_service.dart';

import 'download_controller.dart';

class AudioController extends GetxController {
  var selectedSurah = ''.obs;
  var selectedReciter = ''.obs;

  ///holds the base server URL for all surah recordings for the selectedReciter
  var selectedServer = ''.obs;
  var isResumed = false.obs;
  var isNewSelection = false.obs;

  var playIcon = Icons.play_arrow.obs;

  var choiceText = 'اختر اسم الشيخ والسورة'.obs;

  late final AudioPlayer _audioPlayer;

  var currentPosition = Duration.zero.obs;
  var totalDuration = Duration.zero.obs;
  var timing = '00:00 / 00:00'.obs;

  var isCompleted = false.obs;

  var hasFinishedLoading = false.obs;

  final downloadCtrl = Get.find<DownloadController>();

  var repeatPlaying = false.obs;

  var playlistMode = 0
      .obs; //0 => no_playlist (default), 1 => queue all next surah for the selected reciter, 2 => personalized/custom queue
  var playlistModeIcon = Icons.playlist_remove.obs;

  @override
  void onInit() {
    super.onInit();
    _audioPlayer = AudioPlayer();

    _audioPlayer.onDurationChanged.listen((d) {
      hasFinishedLoading.value = true;
      choiceText.value = 'سورة ${selectedSurah.value} - ${selectedReciter.value}';
      print('✅✅✅✅ onDurationChanged: ${d.inSeconds}');
      totalDuration.value = d;
    });
    _audioPlayer.onPositionChanged.listen((p) {
      currentPosition.value = p;
      updateTiming();
    });
    _audioPlayer.onPlayerComplete.listen((_) {
      print('✅✅✅✅✅✅✅✅✅ onPlayerComplete');
      isCompleted.value = true;
      isResumed.value = false;
      playIcon.value = Icons.play_arrow;

      if (repeatPlaying.isTrue) {
        playNew();
      }
    });
  }

  void setSurah(String surahName) {
    selectedSurah.value = surahName;
    print('selectedSurah.value: ${selectedSurah.value}');
    print('selectedReciter.value: ${selectedReciter.value}');
    if (selectedReciter.isNotEmpty) {
      choiceText.value = 'سورة ${selectedSurah.value} - ${selectedReciter.value}';

      isNewSelection.value = true;
      if (isResumed.isTrue) playNew();
    }
  }

  void setReciter(String reciterName) {
    selectedReciter.value = reciterName;
    print('selectedReciter.value: ${selectedReciter.value}');
    print('selectedSurah.value: ${selectedSurah.value}');
    if (selectedSurah.isNotEmpty) {
      choiceText.value = 'سورة ${selectedSurah.value} - ${selectedReciter.value}';

      isNewSelection.value = true;
      if (isResumed.isTrue) playNew();
    }
  }

  Future<void> togglePlayback() async {
    //Check that the user had made a choice (selected a reciter & a surah)
    if (selectedSurah.isEmpty || selectedReciter.isEmpty) {
      Fluttertoast.showToast(
        msg: "رجاء، اختر الشيخ والسورة",
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.redAccent,
      );
      return;
    }

    // if already playing -> pause
    if (isResumed.isTrue) {
      await pause();
      // if playback previously completed, restart from beginning
    } else if (isCompleted.isTrue) {
      //I tried to seek it to Duration.zero and then resume playback
      //as a more efficient solution than the quite bit intensive playNew() function, but
      //in audio_players, Calling seek while in “completed” state does not automatically reset playback.
      //resume() resumes only if the state is paused, not completed.
      await playNew();
    } else if (isNewSelection.isTrue) {
      await playNew();
      isNewSelection.value = false;
    } else {
      await resume();
    }
  }

  Future<void> pause() async {
    await _audioPlayer.pause();
    isResumed.value = false;
    playIcon.value = Icons.play_arrow;
  }

  Future<void> resume() async {
    await _audioPlayer.resume();
    isResumed.value = true;
    playIcon.value = Icons.pause;
  }

  Future<void> playNew() async {
    isResumed.value = true;
    playIcon.value = Icons.pause;
    isCompleted.value = false;

    await _audioPlayer
        .stop(); //necessary to avoid errors, e.g. switching between different audio source
    //Release the previous audio stream &️ Reset playback position to 0.

    //Play from the local storage, otherwise, stream online
    final isAlreadyDownloaded = downloadCtrl.isDownloaded.value;
    String audioSource;
    if (isAlreadyDownloaded) {
      //offline playback
      print('✅🕌🕌🕌 offline playback');
      final appDir = await getApplicationDocumentsDirectory();
      audioSource =
          '${appDir.path}/QuranMp3/${selectedReciter.value}/${selectedSurah.value}.mp3';
      await _audioPlayer.play(DeviceFileSource(audioSource));
    } else {
      //online  streaming
      print('✅🕌🕌 online streaming');
      //before streaming finished loading, show a transient loading text "loading" and ../.. in duration
      hasFinishedLoading.value = false;
      choiceText.value = 'جاري التحميل البيانات ...';
      timing.value = '.. / ..';
      audioSource = getAudioLink()!;
      await _audioPlayer.play(UrlSource(audioSource));
    }
  }

  String? getAudioLink() {
    final server = RecitersService.recitations[selectedReciter.value];

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

  void updateTiming() {
    final trackCurrentPosFormatted = _formatDuration(currentPosition.value);
    final trackTotalDurationFormatted = _formatDuration(totalDuration.value);

    //if (audioCtrl.isResumed.isFalse)
    timing.value = '$trackTotalDurationFormatted / $trackCurrentPosFormatted';
  }

  String _formatDuration(Duration d) {
    final h = d.inHours.remainder(60);
    final hours = h.toString().padLeft(2, '0');
    final minutes = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return h > 0 ? '$hours:$minutes:$seconds' : '$minutes:$seconds';
  }

  void toggleRepeat() {
    repeatPlaying.value = !repeatPlaying.value;
  }

  void togglePlaylist() {
    switch (playlistMode.value) {
      case 0:
        playlistMode.value = 1;
        playlistModeIcon.value = Icons.playlist_play;
        break;
      case 1:
        playlistMode.value = 2;
        playlistModeIcon.value = Icons.playlist_add;
        break;
      case 2:
        playlistMode.value = 0;
        playlistModeIcon.value = Icons.playlist_remove;
        break;
    }
  }
}
