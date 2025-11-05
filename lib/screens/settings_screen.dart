import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quran_mp3/services/theme_manager.dart';
import 'package:restart_app/restart_app.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Settings'),
      ),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.palette),
            title: const Text('Theme'),
            subtitle:
                const Text('Change the app color theme. App will be restarted'),
            onTap: () => _showThemeDialog(context),
          )
        ],
      ),
    );
  }

  _showThemeDialog(BuildContext context) async {
    final colors = [
      Colors.red,
      Colors.pink,
      Colors.deepOrange,
      Colors.amber,
      Colors.yellow,
      Colors.green,
      Colors.teal,
      Colors.cyan,
      Colors.blue,
      Colors.indigo,
      Colors.purple,
      Colors.deepPurple,
      Colors.brown,
      Colors.grey,
      Colors.blueGrey,
    ];

    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        contentPadding: const EdgeInsets.all(60),
        content: SizedBox(
          width: double.maxFinite,
          child: GridView.builder(
            shrinkWrap: true, //so it will be just as high as its content
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
            ),
            itemCount: colors.length,
            itemBuilder: (context, index) {
              final color = colors[index];
              return GestureDetector(
                onTap: () async {
                  ThemeManager.saveColor(color).then((value) {
                    Navigator.pop(context);
                    Get.changeTheme(ThemeData(primarySwatch: color));

                    Restart.restartApp(); //for it to work, you should run the app
                    // in release mode using the command: flutter run --release
                    /*
                      in release mode, Flutter lets the system fully handle the process exit → relaunch cycle, so Restart.restartApp() behaves exactly as intended ✅
                      In debug, the Flutter runner blocks restarts to keep the dev session alive — so that’s why it looked like a shutdown instead.
                       */
                  });
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.done,
                    color: Colors.white,
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
