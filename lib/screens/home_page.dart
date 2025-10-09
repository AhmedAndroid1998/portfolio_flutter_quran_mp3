import 'package:flutter/material.dart';
import 'package:quran_mp3/data/surah_and_reciters_list.dart';
import 'package:quran_mp3/services/Helpers.dart';
import 'package:quran_mp3/widgets/ui_audio_player_section.dart';

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<String> surahList = surahNames;
  late Future<List<String>> recitersFutureList;
  late List<String> reciterList;
  int? selectedReciterIndex;
  int? selectedSurahIndex;

  @override
  void initState() {
    super.initState();

    // Simulating async load of reciters from local JSON or API
    recitersFutureList = Helpers.extractReciters();
  }

  ///since the filtering logic for both reciters and surahs is the same,
  ///I generalized the method and added a toggle var
  void _filter(bool isReciter, String query) {
    setState(() {
      List<String> list = isReciter ? reciterList : surahList;

      List<String> filteredList = query.isEmpty
          ? list
          : list
              .where((item) =>
                      item.contains(query) ||
                      item
                          .toLowerCase()
                          .contains(query.toLowerCase()) //safety for E search,
                  )
              .toList();

      if (isReciter) {
        reciterList = filteredList;
      } else {
        surahList = filteredList;
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
                          recitersFutureList, screenHeight, true)),
                  const SizedBox(width: 5),
                  Expanded(
                      child: _buildReciterSection(surahList, screenHeight, false)),
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

  Widget _buildReciterSection(dynamic list,
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
              //detect whether you’re building the reciters or the surahs list.
              // For reciters, use a FutureBuilder; for surahs, keep it static.
              child: isRecitersList
                  ? FutureBuilder<List<String>>(
                      future: recitersFutureList,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Center(child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Center(child: Text('Error: ${snapshot.error}'));
                        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                          return const Center(child: Text('No reciters found'));
                        } else {
                          reciterList = snapshot.data!;
                          return _buildListView(reciterList, isRecitersList);
                        }
                      },
                    )
                  : _buildListView(list, isRecitersList))
        ],
      ),
    );
  }

  Widget _buildListView(List<String> list, bool isRecitersList) {
    return ListView.separated(
        itemCount: list.length,
        separatorBuilder: (context, index) => const Divider(
              height: 1,
              color: Colors.grey,
            ),
        itemBuilder: (context, index) {
          final item = list[index];

          final bool isSelected = isRecitersList
              ? selectedReciterIndex == index
              : selectedSurahIndex == index;

          return ListTile(
            title: Text(
              isRecitersList ? item : '${index + 1}\t\t\t$item',
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
        });
  }
}
