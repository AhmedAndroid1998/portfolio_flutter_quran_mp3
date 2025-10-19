import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quran_mp3/controllers/audio_controller.dart';
import 'package:quran_mp3/controllers/reciters_controller.dart';
import 'package:quran_mp3/screens/home_page.dart';

class ReciterListWidget extends StatefulWidget {
  const ReciterListWidget({super.key});

  @override
  State<ReciterListWidget> createState() => _ReciterListWidgetState();
}

class _ReciterListWidgetState extends State<ReciterListWidget> {
  ///The key is the reciter and the value is the base url for the 'server' where all of his recitations are stored
  late Future<Map<String, String>> recitationsFutureList;
  List<String> reciterList = [];
  String? selectedReciter;
  List<String> filteredReciterList = [];
  final audioCtrl = Get.find<AudioController>();

  @override
  void initState() {
    super.initState();
    recitationsFutureList = RecitersService.extractRecitations();
  }

  ///since the filtering logic for both reciters and surahs is the same,
  ///I generalized the method and added a toggle var
  void _filterReciter(String query) {
    setState(() {
      filteredReciterList = query.isEmpty
          ? reciterList
          : reciterList
              .where((item) =>
                      item.contains(query) ||
                      item
                          .toLowerCase()
                          .contains(query.toLowerCase()) //safety for E search,
                  )
              .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    print('✅✅✅ _buildReciterSection() is triggered');
    return Card(
      elevation: 5,
      child: Column(
        children: [
          TextFormField(
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.search),
            ),
            onChanged: (query) => _filterReciter(query), // 🔄 Filter live
          ),
          Expanded(
              //detect whether you’re building the reciters or the surahs list.
              // For reciters, use a FutureBuilder; for surahs, keep it static.
              child: FutureBuilder<Map<String, String>>(
            future: recitationsFutureList,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text('No reciters found'));
              } else {
                // ✅ Assign once only if reciterList is empty
                if (reciterList.isEmpty) {
                  reciterList = snapshot.data!.keys.toList();
                  filteredReciterList = reciterList;
                }
                return Obx(
                  () => buildListView(
                      list: filteredReciterList,
                      isRecitersList: true,
                      selectedItem: audioCtrl.selectedReciter.value,
                      onTap: (i) {
                        audioCtrl.setReciter(filteredReciterList[i]);
                        print(RecitersService.recitations[filteredReciterList[i]]);
                      }),
                );
              }
            },
          ))
        ],
      ),
    );
  }
}
