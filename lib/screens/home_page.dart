import 'package:flutter/material.dart';
import 'package:quran_mp3/data/reciters_list.dart';
import 'package:quran_mp3/data/surah_list.dart';
import 'package:quran_mp3/widgets/ui_audio_player_section.dart';

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List filteredReciterList = recitersList;
  List filteredSurahList = surahList;
  int? selectedReciterIndex;
  int? selectedSurahIndex;

  ///since the filtering logic for both reciters and surahs is the same,
  ///I generalized the method and added a toggle var
  void _filter(bool isReciter, String query) {
    setState(() {
      List list = isReciter ? recitersList : surahList;

      List filteredList = query.isEmpty
          ? list
          : list
              .where((item) =>
                      item.name.contains(query) ||
                      item.name
                          .toLowerCase()
                          .contains(query.toLowerCase()) //safety for E search,
                  )
              .toList();

      if (isReciter) {
        filteredReciterList = filteredList;
      } else {
        filteredSurahList = filteredList;
      }
    });
  }

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
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Expanded(
              child: Row(
                children: [
                  Expanded(
                      child: _buildReciterSection(
                          filteredReciterList, screenHeight, true)),
                  const SizedBox(width: 5),
                  Expanded(
                      child: _buildReciterSection(
                          filteredSurahList, screenHeight, false)),
                ],
              ),
            ),
            const SizedBox(height: 30),
            AudioPlayerSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildReciterSection(List list,
      [double? screenHeight, bool isRecitersList = true]) {
    return Card(
      elevation: 5,
      child: Column(
        children: [
          TextFormField(
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.search),
            ),
            onChanged: (query) => _filter(isRecitersList, query), // 🔄 Filter live
          ),
          Expanded(
            child: ListView.separated(
                itemCount: list.length,
                separatorBuilder: (context, index) => const Divider(
                      height: 1,
                      color: Colors.grey,
                    ),
                itemBuilder: (context, index) {
                  final item = list[index];

                  // Use ID for comparison - assuming your items have an 'id' field
                  // If they don't, we'll use the name as a fallback
                  final String itemId = item.name;

                  final bool isSelected = isRecitersList
                      ? selectedReciterIndex == index
                      : selectedSurahIndex == index;

                  return ListTile(
                    title: Text(
                      isRecitersList ? item.name : '${index + 1}\t\t\t${item.name}',
                      textDirection: TextDirection.rtl,
                      style: const TextStyle(
                        fontSize: 18,
                      ),
                    ),
                    tileColor: isSelected ? Colors.blue : null,
                    onTap: () {
                      setState(() {
                        if (isRecitersList) {
                          selectedReciterIndex = index;
                        } else {
                          selectedSurahIndex = index;
                        }
                      });

                      /// Later: play audio from the API data
                    },
                  );
                }),
          )
        ],
      ),
    );
  }
}
