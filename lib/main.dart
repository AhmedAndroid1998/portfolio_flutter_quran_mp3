import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:quran_mp3/data/reciters_list.dart';
import 'package:quran_mp3/data/surah_list.dart';

void main() {
  runApp(const QuranAudioLibraryApp());
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

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'القرآن الكريم - المكتبة الصوتية',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          children: [
            Expanded(child: _buildReciterSection()),
            SizedBox(
              width: 10,
            ),
            Expanded(child: _buildSurahSection()),
          ],
        ),
      ),
    );
  }

  Widget _buildReciterSection() {
    return Card(
      elevation: 10,
      child: Column(
        children: [
          TextFormField(
            decoration: const InputDecoration(icon: Icon(Icons.search)),
          ),
          Expanded(
            child: ListView.separated(
                itemCount: recitersList.length,
                separatorBuilder: (context, index) => const Divider(
                      height: 1,
                      color: Colors.grey,
                    ),
                itemBuilder: (context, index) {
                  final reciter = recitersList[index];
                  return ListTile(
                    title: Text(
                      reciter.name,
                      textDirection: TextDirection.rtl,
                    ),
                  );
                }),
          )
        ],
      ),
    );
  }

  Widget _buildSurahSection() {
    return Card(
      elevation: 10,
      child: Column(
        children: [
          TextFormField(
            decoration: const InputDecoration(icon: Icon(Icons.search)),
          ),
          Expanded(
            child: ListView.separated(
                itemCount: surahList.length,
                separatorBuilder: (context, index) => const Divider(
                      height: 1,
                      color: Colors.grey,
                    ),
                itemBuilder: (context, index) {
                  final surah = surahList[index];
                  return ListTile(
                    title: Text(
                      '${index + 1}\t\t\t${surah.name}',
                      textDirection: TextDirection.rtl,
                    ),
                  );
                }),
          )
        ],
      ),
    );
  }
}
