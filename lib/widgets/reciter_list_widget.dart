import 'package:flutter/material.dart';
import 'package:quran_mp3/screens/home_page.dart';
import 'package:quran_mp3/services/Helpers.dart';

class ReciterListWidget extends StatefulWidget {
  const ReciterListWidget({super.key});

  @override
  State<ReciterListWidget> createState() => _ReciterListWidgetState();
}

class _ReciterListWidgetState extends State<ReciterListWidget> {
  late Future<List<String>> recitersFutureList;
  List<String> reciterList = [];
  int? selectedReciterIndex;
  List<String> filteredReciterList = [];

  @override
  void initState() {
    super.initState();
    recitersFutureList = Helpers.extractReciters();
  }

  ///since the filtering logic for both reciters and surahs is the same,
  ///I generalized the method and added a toggle var
  void _filterReciter(String query) {
    setState(() {
      filteredReciterList = query.isEmpty
          ? reciterList
          : reciterList
              .where((item) =>
                      item.contains(query) ||
                      item
                          .toLowerCase()
                          .contains(query.toLowerCase()) //safety for E search,
                  )
              .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    print('✅✅✅ _buildReciterSection() is triggered');
    return Card(
      elevation: 5,
      child: Column(
        children: [
          TextFormField(
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.search),
            ),
            onChanged: (query) => _filterReciter(query), // 🔄 Filter live
          ),
          Expanded(
              //detect whether you’re building the reciters or the surahs list.
              // For reciters, use a FutureBuilder; for surahs, keep it static.
              child: FutureBuilder<List<String>>(
            future: recitersFutureList,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text('No reciters found'));
              } else {
                // ✅ Assign once only if reciterList is empty
                if (reciterList.isEmpty) {
                  reciterList = snapshot.data!;
                  filteredReciterList = reciterList;
                }
                return buildListView(
                    list: filteredReciterList,
                    isRecitersList: true,
                    selectedItemIndex: selectedReciterIndex,
                    onTap: (i) {
                      setState(() {
                        selectedReciterIndex = i;
                      });
                    });
              }
            },
          ))
        ],
      ),
    );
  }
}
