import 'package:flutter/material.dart';
import 'package:quran_mp3/data/reciters_list.dart';
import 'package:quran_mp3/data/surah_list.dart';

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List filteredReciterList = recitersList;
  List filteredSurahList = surahList;
  int? selectedReciterIndex;
  int? selectedSurahIndex;

  void _filterReciter(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredReciterList = recitersList;
      } else {
        filteredReciterList = recitersList
            .where((surah) =>
                    surah.name.contains(query) ||
                    surah.name
                        .toLowerCase()
                        .contains(query.toLowerCase()) //safety for E search,
                )
            .toList();
      }
    });
  }

  void _filterSurah(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredSurahList = surahList;
      } else {
        filteredSurahList = surahList
            .where((surah) =>
                    surah.name.contains(query) ||
                    surah.name
                        .toLowerCase()
                        .contains(query.toLowerCase()) //safety for E search,
                )
            .toList();
      }
    });
  }

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
            const SizedBox(
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
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.search),
            ),
            onChanged: _filterReciter, // 🔄 Filter live
          ),
          Expanded(
            child: ListView.separated(
                itemCount: filteredReciterList.length,
                separatorBuilder: (context, index) => const Divider(
                      height: 1,
                      color: Colors.grey,
                    ),
                itemBuilder: (context, index) {
                  final reciter = filteredReciterList[index];
                  final isSelected = selectedReciterIndex == index;
                  return ListTile(
                    title: Text(
                      reciter.name,
                      textDirection: TextDirection.rtl,
                      style: const TextStyle(
                        fontSize: 18,
                      ),
                    ),
                    tileColor: isSelected ? Colors.blue : null,
                    onTap: () {
                      setState(() {
                        selectedReciterIndex = index;
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

  Widget _buildSurahSection() {
    return Card(
      elevation: 10,
      child: Column(
        children: [
          TextFormField(
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.search),
            ),
            onChanged: _filterSurah,
          ),
          Expanded(
            child: ListView.separated(
                itemCount: filteredSurahList.length,
                separatorBuilder: (context, index) => const Divider(
                      height: 1,
                      color: Colors.grey,
                    ),
                itemBuilder: (context, index) {
                  final surah = filteredSurahList[index];
                  final isSelected = selectedSurahIndex == index;
                  return ListTile(
                    title: Text(
                      '${index + 1}\t\t\t${surah.name}',
                      textDirection: TextDirection.rtl,
                      style: const TextStyle(
                        fontSize: 18,
                      ),
                    ),
                    tileColor: isSelected ? Colors.blue : null,
                    onTap: () {
                      setState(() {
                        selectedSurahIndex = index;
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
