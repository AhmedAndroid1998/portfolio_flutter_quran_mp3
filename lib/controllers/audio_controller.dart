import 'package:get/get.dart';

class AudioController extends GetxController {
  var selectedSurah = ''.obs;
  var selectedReciter = ''.obs;

  ///holds the base server URL for all surah recordings for the selectedReciter
  var selectedServer = ''.obs;
  var isPlaying = false.obs;

  void setSurah(String surahName) {
    selectedSurah.value = surahName;
    print('selectedSurah.value: ${selectedSurah.value}');
    print('selectedReciter.value: ${selectedReciter.value}');
  }

  void setReciter(String reciterName) {
    selectedReciter.value = reciterName;
    print('selectedReciter.value: ${selectedReciter.value}');
    print('selectedSurah.value: ${selectedSurah.value}');
  }
}
