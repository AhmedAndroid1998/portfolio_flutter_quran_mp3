import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quran_mp3/controllers/presented_section_controller.dart';
import 'package:quran_mp3/data/surah_and_reciters_list.dart';
import 'package:quran_mp3/widgets/downloads-section.dart';
import 'package:quran_mp3/widgets/reciter_list_widget.dart';
import 'package:quran_mp3/widgets/surah_list_widget.dart';
import 'package:quran_mp3/widgets/ui_audio_player_section.dart';

class MyHomePage extends StatelessWidget {
  final presentedSectionCtrl = Get.put(PresentedSectionController());

  late final _reciterAndSurahSection = const Row(
    children: [
      Expanded(child: ReciterListWidget()),
      Expanded(child: SurahListWidget()),
    ],
  );

  late final _downloadsSection = const DownloadsSectionWidget();

  final _pageController = PageController();

  @override
  Widget build(BuildContext context) {
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
          Obx(
            () => IconButton(
              icon: Icon(presentedSectionCtrl.selectSectionIcon.value),
              onPressed: () {
                presentedSectionCtrl.toggleSection();
              },
            ),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Expanded(
              child: Obx(
                () => IndexedStack(
                  index: presentedSectionCtrl.selectedSection.value,
                  children: const [
                    Row(
                      children: [
                        Expanded(child: ReciterListWidget()),
                        Expanded(child: SurahListWidget()),
                      ],
                    ),
                    DownloadsSectionWidget(),
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
