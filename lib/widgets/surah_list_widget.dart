import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:quran_mp3/controllers/audio_controller.dart';
import 'package:quran_mp3/controllers/download_controller.dart';
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
  final scrollCtrl = ScrollController();

  @override
  void initState() {
    super.initState();
    filteredSurahList = surahList;

    ever(audioCtrl.selectedSurah, (selectedItem) {
      print('ever() is called 👈 👈 👈 👈 👈 👈 👈 ');
      if (selectedItem.isNotEmpty) {
        final index = filteredSurahList.indexOf(selectedItem);
        if (index != -1) {
          scrollCtrl.animateTo(index * 56,
              duration: const Duration(milliseconds: 400), curve: Curves.easeInOut);
        }
      }
    });
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
                  },
                  scrollController: scrollCtrl),
            ),
          )
        ],
      ),
    );
  }
}

/// Extracted popup menu method
Future<void> showSurahOptionsMenu(BuildContext context, String surahName) async {
  final audioCtrl = Get.find<AudioController>();
  final downloadCtrl = Get.find<DownloadController>();

  if (audioCtrl.selectedReciter.isEmpty) {
    Fluttertoast.showToast(
      msg: "رجاء، اختر الشيخ أولا",
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.redAccent,
    );
    return;
  }

  // Now it's safe to do async work
  await downloadCtrl.checkIfDownloaded(audioCtrl.selectedReciter.value, surahName);
  final isAlreadyDownloaded = downloadCtrl.isDownloaded.value;

  final RenderBox renderBox = context.findRenderObject() as RenderBox;
  final Offset offset = renderBox.localToGlobal(Offset.zero);
  final Size size = renderBox.size;

  // And now show the menu
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
        padding: EdgeInsets.all(5),
        value: 1,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text("أضف لقائمة الإستماع"),
            SizedBox(width: 10),
            Icon(Icons.playlist_add),
          ],
        ),
      ),
      PopupMenuItem(
        padding: EdgeInsets.all(5),
        value: 2,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text("مشاركة"),
            SizedBox(width: 10),
            Icon(Icons.share),
          ],
        ),
      ),
      PopupMenuItem(
        padding: EdgeInsets.all(5),
        value: 3,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            isAlreadyDownloaded ? Text("حذف") : Text("تحميل"),
            SizedBox(width: 10),
            isAlreadyDownloaded ? Icon(Icons.delete) : Icon(Icons.download)
          ],
        ),
      ),
    ],
  ).then((value) async {
    // Handle menu selection
    if (value == 1) {
      audioCtrl.addToCustomQueue(surahName);
      //display the custom playlist and add this surah item to it
      audioCtrl.playlistMode.value = PlaylistMode.custom;
      audioCtrl.playlistModeIcon.value = Icons.playlist_add;
      //turn off the repeat if it's turned on
      audioCtrl.repeatPlaying.value = audioCtrl.repeatPlaying.isTrue ? false : false;
    } else if (value == 2) {
    } else if (value == 3) {
      isAlreadyDownloaded
          ? await downloadCtrl.deleteFile(audioCtrl.selectedReciter.value, surahName)
          : await downloadCtrl.downloadFile(audioCtrl.getAudioLink(surahName)!,
              audioCtrl.selectedReciter.value, surahName);
    }
  });
}
