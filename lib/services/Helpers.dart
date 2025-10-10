import 'dart:convert';

import 'package:flutter/services.dart';

///A utility class to provide procedure methods
final class Helpers {
  static Future<List<String>> extractReciters() async {
    //the following json file was the response to the URL query: https://www.mp3quran.net/api/v3/reciters?language=ar
    final jsonString =
        await rootBundle.loadString('assets/data/mp3_quran_API_reciters_list.json');
    final data = json.decode(jsonString);
    final reciters = data['reciters'] as List;
    List<String> recitersNames = [];
    for (var r in reciters) {
      for (var m in r['moshaf']) {
        ///I'll just extract the reciters who have the full quran record (114 surah)
        ///to avoid an expected error (chosing a non-recorded surah for a reciter)
        if (m['surah_total'] == 114) {
          //If a reciter has more than mushaf (e.g الحصري أو المنشاوي), append that to the name for clarity
          //var mushafType = m['name'];
          // print('✅ $mushafType');
          //mushafType = _cleanString(mushafType);

          var mushafType = (m['id'] != r['id'] ? '${m['name']}' : '');
          if (mushafType.isNotEmpty) {
            // print('✅ $mushafType');
            mushafType = ' (${cleanString(mushafType)})';
            // print('✅✅✅ $mushafType');
          }
          recitersNames.add(r['name'] + mushafType);
        }
      }
    }

    // print('✅✅✅✅✅ ${recitersNames.length}');
    return recitersNames;
  }

  ///Fixing some typo issues in the API data
  static String cleanString(String input) {
    return input
        .replaceAll('المصحف المجود - المصحف المجود', 'المصحف المجود')
        .replaceAll('المصحف المعلم - المصحف المعلم', 'المصحف المعلم')
        .trim();
    /* I noticed some typo issues in the API data like duplication and
      so on (e.g.  محمد أيوب - حفص عن عاصم -٤  so unnecessary " - 4" string
      (another ex: ماهر المعيقلي - المصحف المجود - المصحف المجود)
      I asked chatGpt to provide me a method to remove non-letter chars
      but it didn't work, I discussed a lot with him for the right solution
      but he couldn't figure it out (as you can see it commented below).
      I finally decided to quit (after spending around 2-3 hours on this task/commit alone), because this is not a big
      deal and it's not my main purpose, my purpose is to focus on functionality
      and ignore polishing and styling because they are doable.
      I also noticed that the data that has the problem are ONLY 2 strings
      so I just handled them
*/
  }

  /*

  /// Removes symbols but keeps spaces, and eliminates duplicated phrase patterns.
  static String _cleanString(String input) {
    // 1️⃣ Remove non-letter symbols (keep spaces)
    String lettersOnly =
        input.replaceAll(RegExp(r'[^a-zA-Z\u0600-\u06FF ]'), '').trim();

    // 2️⃣ Normalize multiple spaces into a single space
    lettersOnly = lettersOnly.replaceAll(RegExp(r'\s+'), ' ');

    // 3️⃣ Remove repeated phrase (case-insensitive, allows spaces)
    return _removeDuplicateWordIgnoreCase(lettersOnly);
  }

  static String _removeDuplicateWordIgnoreCase(String input) {
    final lower = input.toLowerCase().trim();

    //  ✅ Updated regex: allow spaces inside repeated phrase
    final match = RegExp(r'^([\u0600-\u06FFa-zA-Z ]+?)\1+$').firstMatch(lower);

    if (match != null) {
      final length = match.group(1)!.length;
      return input.substring(0, length).trim();
    }
    return input;
  }
   */
}
