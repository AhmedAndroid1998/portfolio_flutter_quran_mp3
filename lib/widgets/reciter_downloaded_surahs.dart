import 'dart:io';

import 'package:flutter/material.dart';

class ReciterDownloadedSurahsList extends StatelessWidget {
  final MapEntry<String, List<File>> currentReciter;
  final VoidCallback onBack;

  const ReciterDownloadedSurahsList(
      {super.key, required this.currentReciter, required this.onBack});

  @override
  Widget build(BuildContext context) {
    final reciterName = currentReciter.key;
    final files = currentReciter.value;

    if (files.isEmpty) {
      return const Center(
        child: Text(
          ' لا توجد سور محملة',
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      );
    }

    return Column(
      children: [
        Row(
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: onBack,
            ),
            Expanded(
              child: Text(
                reciterName,
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
          ],
        ),
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.all(10),
            separatorBuilder: (_, __) => const Divider(
              height: 1,
              color: Colors.grey,
            ),
            itemCount: files.length,
            itemBuilder: (BuildContext context, int index) {
              final file = files[index];
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
                  onPressed: () async {},
                ),
                onTap: () {},
              );
            },
          ),
        ),
      ],
    );
  }
}
