import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quran_mp3/controllers/download_controller.dart';

class DownloadingFilesTab extends StatelessWidget {
  DownloadingFilesTab({super.key});

  final downloadCtrl = Get.find<DownloadController>();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        final downloads = downloadCtrl.downloads;

        if (downloads.isEmpty) {
          return const Center(child: Text('لا توجد تحميلات حالية'));
        }

        return ListView.separated(
            padding: const EdgeInsets.all(10),
            itemCount: downloads.length,
            separatorBuilder: (_, __) => const Divider(
                  height: 1,
                  color: Colors.grey,
                ),
            itemBuilder: (context, index) {
              final item = downloads[index];

              return ListTile(
                title: Text(
                  '${item.surah} - ${item.reciter}',
                  style: Theme.of(context)
                      .textTheme
                      .headlineSmall
                      ?.copyWith(fontSize: 18),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Obx(
                      () {
                        if (item.isDownloaded.isTrue) {
                          return const Padding(
                            padding: EdgeInsets.only(top: 8.0),
                            child: Text(
                              'تم التحميل',
                              style: TextStyle(color: Colors.grey),
                            ),
                          );
                        } else {
                          return Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                LinearProgressIndicator(
                                  value: item.progress.value,
                                  backgroundColor: Colors.grey.shade300,
                                ),
                                Text('جاري التحميل ...' +
                                    item.downloadingProgress.value)
                              ],
                            ),
                          );
                        }
                      },
                    ),
                  ],
                ),
                trailing: Obx(
                  () {
                    return IconButton(
                      onPressed: () async {
                        if (item.isDownloaded.isFalse) {
                          ///here, I want to cancel the download  process
                        }
                      },
                      icon: Icon(
                        item.isDownloaded.isTrue
                            ? Icons.download_done_rounded
                            : Icons.cancel_rounded,
                        color: item.isDownloaded.isTrue
                            ? Colors.greenAccent
                            : Colors.blueGrey,
                      ),
                    );
                  },
                ),
              );
            });
      },
    );
  }
}
