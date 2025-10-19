import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:quran_mp3/controllers/audio_controller.dart';
import 'package:quran_mp3/controllers/download_controller.dart';

import 'screens/home_page.dart';

void main() {
  // Register the controllers globally once
  Get.put(AudioController());
  Get.put(DownloadController());

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

      /// the app will be Arabic-first.
      supportedLocales: const [Locale('ar')],
      locale: const Locale('ar'),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: MyHomePage(),
    );
  }
}
