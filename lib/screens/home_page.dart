import 'package:flutter/material.dart';
import 'package:quran_mp3/data/surah_and_reciters_list.dart';
import 'package:quran_mp3/widgets/downloads-section.dart';
import 'package:quran_mp3/widgets/reciter_list_widget.dart';
import 'package:quran_mp3/widgets/surah_list_widget.dart';
import 'package:quran_mp3/widgets/ui_audio_player_section.dart';

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedSection = 0;

  IconData _selectedSectionIcon = Icons.cloud_download; // 0=List, 1=Downloads;

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
        actions: [
          IconButton(
            icon: Icon(_selectedSectionIcon),
            onPressed: () {
              setState(() {
                _selectedSection = _selectedSection == 0 ? 1 : 0;
                _selectedSectionIcon =
                    _selectedSection == 0 ? Icons.cloud_download : Icons.headphones;
              });
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: IndexedStack(
                  key: ValueKey(_selectedSection), //ensures correct animation
                  index: _selectedSection,
                  children: const [
                    Row(
                      children: [
                        Expanded(child: ReciterListWidget()),
                        SizedBox(width: 5),
                        Expanded(child: SurahListWidget()),
                      ],
                    ),
                    DownloadsSectionWidget()
                  ],
                ),
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
  required String? selectedItem,
  required void Function(int) onTap,
}) {
  return ListView.separated(
      itemCount: list.length,
      separatorBuilder: (_, __) => const Divider(
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
            //we compared with value instead of index, because index
            //will not match the correct item due to shortening & re-ordering caused by the filter to to the filteredList
            tileColor: selectedItem == item ? Colors.blue : null,
            onTap: () => onTap(index)

            /// Later: play audio from the API data
            );
      });
}
