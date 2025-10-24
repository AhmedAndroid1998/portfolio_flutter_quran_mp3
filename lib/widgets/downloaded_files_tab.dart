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

      if (downloads.isEmpty) {
        return const Center(
          child: Text(
            ' لا توجد سور محملة',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
        );
      }

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
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  softWrap: true,
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
          );
        },
      );
    });
  }
}
