import 'dart:io';

import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';

class DownloadsListController extends GetxController {
  var downloads = <String, List<File>>{}.obs; //{reciterFolder: [list of surah files]

  @override
  void onInit() {
    super.onInit();
    loadDownloads();
  }

  Future<void> loadDownloads() async {
    final appDir = await getApplicationDocumentsDirectory();
    final quranDir = Directory('${appDir.path}/QuranMp3');

    if (!await quranDir.exists()) {
      downloads.clear();
      return;
    }

    final reciterDirs = quranDir.listSync().whereType<Directory>();
    final Map<String, List<File>> temp = {};

    for (var dir in reciterDirs) {
      final files = dir
          .listSync()
          .whereType<File>()
          .where((file) => file.path.endsWith('.mp3'))
          .toList();
      if (files.isNotEmpty) {
        temp[dir.path.split('/').last] = files;
      }
    }

    downloads.value = temp;
    print('✅✅###✅✅ ${downloads.value.toString()}');
  }
}
