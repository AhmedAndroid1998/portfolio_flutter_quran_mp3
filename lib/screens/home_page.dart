import 'package:flutter/material.dart';
import 'package:quran_mp3/data/surah_and_reciters_list.dart';
import 'package:quran_mp3/widgets/reciter_list_widget.dart';
import 'package:quran_mp3/widgets/surah_list_widget.dart';
import 'package:quran_mp3/widgets/ui_audio_player_section.dart';

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white.withOpacity(.8),
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
      body: const Padding(
        padding: EdgeInsets.all(10.0),
        child: Column(
          children: [
            Expanded(
              child: Row(
                children: [
                  Expanded(child: ReciterListWidget()),
                  SizedBox(width: 5),
                  Expanded(child: SurahListWidget()),
                ],
              ),
            ),
            SizedBox(height: 30),
            AudioPlayerSection(),
          ],
        ),
      ),
    );
  }
}

Widget buildListView({
  required List<String> list,
  required bool isRecitersList,
  required int? selectedItemIndex,
  required void Function(int) onTap,
}) {
  return ListView.separated(
      itemCount: list.length,
      separatorBuilder: (context, index) => const Divider(
            height: 1,
            color: Colors.grey,
          ),
      itemBuilder: (context, index) {
        final item = list[index];

        return ListTile(
            title: Text(
              isRecitersList ? item : '${surahNames.indexOf(item) + 1}\t\t\t$item',
              textDirection: TextDirection.rtl,
              style: const TextStyle(
                fontSize: 18,
              ),
            ),
            tileColor: selectedItemIndex == index ? Colors.blue : null,
            onTap: () => onTap

            /// Later: play audio from the API data
            );
      });
}
