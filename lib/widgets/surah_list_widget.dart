import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:quran_mp3/controllers/audio_controller.dart';
import 'package:quran_mp3/data/surah_and_reciters_list.dart';
import 'package:quran_mp3/screens/home_page.dart';

class SurahListWidget extends StatefulWidget {
  const SurahListWidget({super.key});

  @override
  State<SurahListWidget> createState() => _SurahListWidgetState();
}

class _SurahListWidgetState extends State<SurahListWidget> {
  List<String> surahList = surahNames;
  String? selectedSurah;
  List<String> filteredSurahList = [];
  final audioCtrl = Get.find<AudioController>();

  @override
  void initState() {
    super.initState();
    filteredSurahList = surahList;
  }

  ///since the filtering logic for both reciters and surahs is the same,
  ///I generalized the method and added a toggle var
  void _filterSurah(String query) {
    setState(() {
      filteredSurahList = query.isEmpty
          ? surahList
          : surahList
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
    print('✅ _buildSurahSection() is triggered');
    return Card(
      elevation: 5,
      child: Column(
        children: [
          TextFormField(
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.search),
            ),
            onChanged: (query) => _filterSurah(query), // 🔄 Filter live
          ),
          Expanded(
            //detect whether you’re building the reciters or the surahs list.
            // For reciters, use a FutureBuilder; for surahs, keep it static.
            child: Obx(
              () => buildListView(
                  list: filteredSurahList,
                  isRecitersList: false,
                  selectedItem: audioCtrl.selectedSurah.value,
                  onTap: (i) {
                    audioCtrl.setSurah(filteredSurahList[i]);
                  }),
            ),
          )
        ],
      ),
    );
  }
}

/// Extracted popup menu method
void showSurahOptionsMenu(BuildContext context, String surahName) {
  final audioCtrl = Get.find<AudioController>();
  if (audioCtrl.selectedReciter.isEmpty) {
    Fluttertoast.showToast(
      msg: "رجاء، اختر الشيخ أولا",
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.redAccent,
    );
    return;
  }

  final RenderBox renderBox = context.findRenderObject() as RenderBox;
  final Offset offset = renderBox.localToGlobal(Offset.zero);
  final Size size = renderBox.size;

  showMenu(
    context: context,
    position: RelativeRect.fromLTRB(
      offset.dx,
      offset.dy + size.height,
      offset.dx + size.width,
      offset.dy,
    ),
    items: [
      PopupMenuItem(
        value: 1,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            FittedBox(child: Text("قائمة الإستماع")),
            SizedBox(width: 5),
            Icon(Icons.playlist_add),
          ],
        ),
      ),
    ],
  ).then((value) {
    // Handle menu selection
    if (value == 1) {
      audioCtrl.addToCustomQueue(surahName);
    }
  });
}
