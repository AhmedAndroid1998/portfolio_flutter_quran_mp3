import 'package:flutter/material.dart';
import 'package:quran_mp3/widgets/downloaded_files_tab.dart';
import 'package:quran_mp3/widgets/downloading_files_tab.dart';

class DownloadsSectionWidget extends StatelessWidget {
  const DownloadsSectionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Directionality(
          textDirection: TextDirection.rtl,
          child: Column(
            children: [
              Container(
                color: Colors.blueAccent,
                child: const TabBar(
                  indicatorColor: Colors.lightBlueAccent,
                  indicatorWeight: 3,
                  tabs: [
                    Tab(
                      text: 'الملفات المحملة',
                    ),
                    Tab(
                      text: 'جاري التحميل...',
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  color: Colors.white,
                  child: TabBarView(
                    children: [DownloadedFilesTab(), DownloadingFilesTab()],
                  ),
                ),
              )
            ],
          )),
    );
  }
}
