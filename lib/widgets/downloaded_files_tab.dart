import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quran_mp3/controllers/downloads_list_controler.dart';

class DownloadedFilesTab extends StatelessWidget {
  DownloadedFilesTab({super.key});

  final controller = Get.find<DownloadsListController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final downloads = controller.downloads;

      if (controller.downloads.isEmpty) {
        return const Center(
          child: Text(
            ' لا توجد سور محملة',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
        );
      }

      final recitersEntries = downloads.entries.toList();
      return controller.selectedReciterItem.isNegative
          ? recitersFilesList()
          : reciterSurahsList(
              context: context,
              currentReciter: recitersEntries[controller.selectedReciterItem.value],
            );
    });
  }

  Widget recitersFilesList() {
    final downloads = controller.downloads;
    final reciterEntries = downloads.entries.toList();

    return ListView.separated(
      padding: const EdgeInsets.all(10),
      separatorBuilder: (_, __) => const Divider(
        height: 1,
        color: Colors.grey,
      ),
      itemCount: reciterEntries.length,
      itemBuilder: (BuildContext context, int index) {
        final reciter = reciterEntries[index].key;
        final files = reciterEntries[index].value;

        return ListTile(
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                reciter,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontSize: 21,
                    ),
              ),
              Text('عدد السور: ' + '${files.length}'),
            ],
          ),
          trailing: IconButton(
            icon: const Icon(Icons.delete_forever, color: Colors.redAccent),
            onPressed: () async {
              //f.existsSync() ensures we skip already-deleted files
              final existingFiles = files.where((f) => f.existsSync()).toList();

              for (final file in existingFiles) {
                try {
                  await file.delete();
                } catch (e) {
                  debugPrint('Failed to delete ${file.path}: $e');
                }
              }

              // Remove the reciter entry after deleting. This updates your observable map, so the UI refreshes automatically.
              controller.downloads.remove(reciter);
            },
          ),
          onTap: () {
            controller.selectedReciterItem.value = index;
          },
        );
      },
    );
  }

  Widget reciterSurahsList(
      {required BuildContext context,
      required MapEntry<String, List<File>> currentReciter}) {
    final reciterName = currentReciter.key;
    final surahList = currentReciter.value;

    if (surahList.isEmpty) {
      controller.selectedReciterItem.value = -1; //returns to the reciters list
    }

    return WillPopScope(
      ///Allow us to override the back button behavior
      onWillPop: () async {
        if (!controller.selectedReciterItem.isNegative) {
          // If a reciter is currently opened, go back to the reciters list instead of popping the route
          controller.selectedReciterItem.value = -1;
          return false; // prevent route pop
        }
        return true; // allow normal navigation (exit screen)
      },
      child: Column(
        children: [
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  controller.selectedReciterItem.value = -1;
                },
              ),
              Expanded(
                child: Text(
                  reciterName,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
            ],
          ),
          // const Divider(
          //   height: 1,
          //   color: Colors.black87,
          // ),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.all(10),
              separatorBuilder: (_, __) => const Divider(
                height: 1,
                color: Colors.grey,
              ),
              itemCount: surahList.length,
              itemBuilder: (BuildContext context, int index) {
                final file = surahList[index];
                final length = file.length();

                return ListTile(
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        file.path.split('/').last,
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              fontSize: 21,
                            ),
                      ),
                      Text('size:' + '${13.5}'),
                    ],
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete_forever, color: Colors.redAccent),
                    onPressed: () async {
                      if (index >= surahList.length) return; //safety check

                      final fileToDelete = surahList[index];
                      if (await fileToDelete.exists()) {
                        await fileToDelete.delete();
                      }
                      if (surahList.length == 1) {
                        surahList.clear();
                        controller.downloads.remove(currentReciter.key);
                        controller.selectedReciterItem.value =
                            -1; //returns to the reciters list
                      } else {
                        surahList.removeAt(index);
                        controller.downloads[reciterName] =
                            List<File>.from(surahList);
                      }
                    },
                  ),
                  onTap: () async {},
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
