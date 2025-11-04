import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

class UiFunctionsUtils {
  static Future<void> showShareDialog(BuildContext context, String reciter,
      String surah, bool isLocal, String? filePath, String? link) async {
    await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('مشاركة الملف'),
        content: Text(isLocal
            ? 'لقد قمت بتحميل هذه السورة. هل تريد مشاركة الملف أم الرابط فقط؟'
            : 'لم يتم تنزيل الملف، هل تريد مشاركة الرابط؟'),
        actions: [
          TextButton(
            child: Text(isLocal ? 'مشاركة الملف' : 'نعم'),
            onPressed: () async {
              Navigator.of(ctx).pop();
              isLocal
                  ? await Share.shareXFiles([XFile(filePath!)],
                      subject: 'Listen to $surah - $reciter')
                  : await Share.share(link!, subject: 'Listen to $surah - $reciter');
            },
          ),
          ElevatedButton(
            child: Text(isLocal ? 'مشاركة الرابط' : 'لا'),
            onPressed: () async {
              Navigator.of(ctx).pop();
              if (isLocal) {
                await Share.share(link!, subject: 'Listen to $surah - $reciter');
              }
            },
          )
        ],
      ),
    );
  }
}
