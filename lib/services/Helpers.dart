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
          final mushafType = (m['id'] != r['id'] ? ' -  ${m['name']}' : '');
          recitersNames.add(r['name'] + mushafType);
        }
      }
    }

    print('✅✅✅✅✅ ${recitersNames.length}');
    return recitersNames;
  }
}
