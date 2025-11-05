import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quran_mp3/controllers/presented_section_controller.dart';
import 'package:quran_mp3/data/surah_and_reciters_list.dart';
import 'package:quran_mp3/screens/settings_screen.dart';
import 'package:quran_mp3/widgets/downloads-section.dart';
import 'package:quran_mp3/widgets/reciter_list_widget.dart';
import 'package:quran_mp3/widgets/surah_list_widget.dart';
import 'package:quran_mp3/widgets/ui_audio_player_section.dart';

import '../controllers/downloads_list_controler.dart';

class MyHomePage extends StatelessWidget {
  final presentedSectionCtrl = Get.put(PresentedSectionController());

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      ///Allow us to override the back button behavior
      onWillPop: () async {
        return onBackButtonPressed();
      },
      child: Scaffold(
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
              icon: const Icon(Icons.settings),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => SettingsScreen(),
                  ),
                );
              },
            ),
            Obx(
              () => IconButton(
                icon: Icon(presentedSectionCtrl.selectSectionIcon.value),
                onPressed: () {
                  presentedSectionCtrl.toggleSection();
                },
              ),
            ),
            IconButton(
              icon: const Icon(Icons.power_settings_new),
              onPressed: () {
                exit(0); // This will completely close the app. Not recommended
              },
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              Expanded(
                child: Obx(() {
                  final isDownloadsSection =
                      presentedSectionCtrl.selectedSection.value == 1;

                  return Stack(
                    children: [
                      // Reciters + Surahs Section
                      AnimatedSlide(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                        offset: isDownloadsSection
                            ? const Offset(-1.1, 0.0) // slide out to left
                            : Offset.zero, // visible
                        child: const Row(
                          children: [
                            Expanded(child: SurahListWidget()),
                            Expanded(child: ReciterListWidget()),
                          ],
                        ),
                      ),

                      // Downloads Section
                      AnimatedSlide(
                        duration: const Duration(milliseconds: 400),
                        curve: Curves.easeInOut,
                        offset: isDownloadsSection
                            ? Offset.zero // visible
                            : const Offset(1.1, 0.0), // slide out to right
                        child: DownloadsSectionWidget(),
                      ),
                    ],
                  );
                }),
              ),
              SizedBox(height: 30),
              AudioPlayerSection(),
            ],
          ),
        ),
      ),
    );
  }

  bool onBackButtonPressed() {
    final isDownloads = presentedSectionCtrl.selectedSection.value == 1;

    // Check if DownloadsSectionWidget wants to handle the back press first
    if (isDownloads) {
      final downloadsController = Get.find<DownloadsListController>();
      if (!downloadsController.selectedReciterItem.isNegative) {
        // inside a reciter’s surah list, go back to reciters list
        downloadsController.selectedReciterItem.value = -1;
        return false;
      }
    }

    // Otherwise, handle at main level (go back to main section)
    if (isDownloads) {
      presentedSectionCtrl.toggleSection(); // go back to Reciters section
      return false;
    }

    // Allow default system back if already in main Reciters section
    return true;
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

        ///setting the popup menu on ListTile's onLongPress wasn't
        ///positioned correctly, that's why I needed GestureDetector
        ///along with Builder's context to position it properly (underneath)
        return Builder(builder: (context) {
          return GestureDetector(
            onLongPress:
                isRecitersList ? null : () => showSurahOptionsMenu(context, item),
            child: ListTile(
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
              onTap: () => onTap(index),
            ),
          );
        });
      });
}
