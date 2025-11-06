import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quran_mp3/controllers/audio_controller.dart';
import 'package:quran_mp3/controllers/download_controller.dart';
import 'package:quran_mp3/controllers/downloads_list_controler.dart';
import 'package:quran_mp3/screens/home_page.dart';
import 'package:quran_mp3/services/theme_manager.dart';

Future<void> main() async {
  // Register the controllers globally once
  Get.put(
      DownloadController()); //register first because AudioController depends  on it
  Get.put(DownloadsListController());
  Get.put(AudioController());

  WidgetsFlutterBinding.ensureInitialized();
  final savedColor = await ThemeManager.loadColor();
  runApp(QuranAudioLibraryApp(themeColor: savedColor));
}

class QuranAudioLibraryApp extends StatelessWidget {
  final Color themeColor;
  const QuranAudioLibraryApp({super.key, required this.themeColor});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Quran_MP3',
      theme: ThemeData(
        primaryColor: themeColor,
        colorScheme: ColorScheme.fromSeed(seedColor: themeColor),
        // AppBar color
        appBarTheme: AppBarTheme(
          backgroundColor: themeColor,
          iconTheme: const IconThemeData(color: Colors.white),
          titleTextStyle: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        floatingActionButtonTheme:
            FloatingActionButtonThemeData(backgroundColor: themeColor),
      ),
      home: MyHomePage(),
    );
  }
}
