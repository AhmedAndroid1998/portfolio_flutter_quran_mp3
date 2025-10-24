import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quran_mp3/controllers/audio_controller.dart';
import 'package:quran_mp3/controllers/download_controller.dart';
import 'package:quran_mp3/controllers/downloads_list_controler.dart';

import 'screens/home_page.dart';

void main() {
  // Register the controllers globally once
  Get.put(
      DownloadController()); //register first because AudioController depends  on it
  Get.put(
      DownloadsListController()); //register first because AudioController depends  on it
  Get.put(AudioController());

  runApp(GetMaterialApp(
    home: QuranAudioLibraryApp(),
  ));
}

class QuranAudioLibraryApp extends StatelessWidget {
  const QuranAudioLibraryApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Quran_MP3',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: MyHomePage(),
    );
  }
}
