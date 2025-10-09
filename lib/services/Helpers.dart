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
        if (m['surah_total'] == 114) recitersNames.add(r['name']);
      }
    }

    print('✅✅✅✅✅ ${recitersNames.length}');
    return recitersNames;
  }
}
