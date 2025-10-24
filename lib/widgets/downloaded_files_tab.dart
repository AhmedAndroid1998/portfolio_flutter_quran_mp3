import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quran_mp3/controllers/downloads_list_controler.dart';
import 'package:quran_mp3/widgets/reciter_downloaded_surahs.dart';

class DownloadedFilesTab extends StatelessWidget {
  DownloadedFilesTab({super.key});

  final controller = Get.find<DownloadsListController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final downloads = controller.downloads;

      if (downloads.isEmpty) {
        return const Center(
          child: Text(
            ' لا توجد سور محملة',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
        );
      }

      final reciterEntries = downloads.entries.toList();
      return !controller.selectedReciterItem.isNegative
          ? ReciterDownloadedSurahs(
              reciterName: reciterEntries[controller.selectedReciterItem.value].key,
              files: reciterEntries[controller.selectedReciterItem.value].value,
              onBack: () {
                controller.selectedReciterItem.value = -1;
              },
            )
          : ListView.separated(
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
                      final existingFiles =
                          files.where((f) => f.existsSync()).toList();

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
                    ///TODO: 1. Add a obs field, isReciterSelected, and use it
                    ///to conditionally load either above list or another
                    ///listTile that takes in the List<File> above as  a parameter
                    ///I suspect above conditional list will work as expected because when pressing the back button, it would return me to
                    ///back to the main list, but I'll programatically override the back button action to set isReciterSelected = false
                    ///
                    ///
                    ///TODO 2. It uses the individual delete() method in the downloadController
                    ///TODO 3. onTap() to play it from locale
                    ///
                    controller.selectedReciterItem.value = index;
                  },
                );
              },
            );
    });
  }
}
