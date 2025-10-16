import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:quran_mp3/controllers/audio_controller.dart';

class AudioPlayerSection extends StatefulWidget {
  const AudioPlayerSection({super.key});

  @override
  State<AudioPlayerSection> createState() => _AudioPlayerSectionState();
}

class _AudioPlayerSectionState extends State<AudioPlayerSection> {
  double _currentValue = 0;
  final double _maxValue = 60;

  final audioCtrl = Get.find<AudioController>();

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topCenter,
      clipBehavior: Clip.none, //to prevent clipping of Positioned widgets
      children: [
        Container(
          height: 170,
          width: double.infinity,
          child: Card(
            elevation: 10,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 30.0),
                  child: Obx(
                    () => Text(
                      audioCtrl.descriptionText.value,
                      style:
                          const TextStyle(fontSize: 18, fontStyle: FontStyle.italic),
                    ),
                  ),
                ),
                Directionality(
                  textDirection: TextDirection.ltr,

                  ///to change the direction of the Slider
                  child: Slider(
                      value: _currentValue,
                      onChanged: (value) {
                        setState(() {
                          _currentValue = value;
                        });
                      }),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.repeat),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.download),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.share),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
        Positioned(
          top: -25,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _MaterialCircleButton(
                icon: Icons.forward_10,
                onPressed: () {},
              ),
              const SizedBox(width: 5),
              Obx(
                () => _MaterialCircleButton(
                  icon: audioCtrl.playIcon.value,
                  radius: 28,
                  elevation: 10,
                  color: Colors.purpleAccent,
                  onPressed: () {
                    if (audioCtrl.selectedSurah.isEmpty ||
                        audioCtrl.selectedReciter.isEmpty) {
                      Fluttertoast.showToast(
                        msg: "رجاء، اختر الشيخ والسورة",
                        gravity: ToastGravity.BOTTOM,
                        backgroundColor: Colors.redAccent,
                      );
                    } else {
                      audioCtrl.isResumed.toggle();
                      audioCtrl.playIcon.value =
                          audioCtrl.isResumed.value ? Icons.pause : Icons.play_arrow;
                      audioCtrl.isResumed.isTrue
                          ? audioCtrl.play()
                          : audioCtrl.pause();
                    }
                  },
                ),
              ),
              const SizedBox(width: 5),
              _MaterialCircleButton(icon: Icons.replay_10, onPressed: () {}),
            ],
          ),
        ),
      ],
    );
  }

  ///adds a Material-like Shadow/drop effect for the custom _CircleButton below
  Widget _MaterialCircleButton(
      {required IconData icon,
      required void Function()? onPressed,
      double radius = 24,
      double elevation = 7,
      Color color = Colors.black}) {
    return Material(
      elevation: elevation,
      shadowColor: color,
      shape: CircleBorder(),
      child: _CircleButton(icon: icon, onPressed: onPressed, radius: radius),
    );
  }

  Widget _CircleButton(
      {required IconData icon, void Function()? onPressed, double radius = 24}) {
    return CircleAvatar(
      radius: radius,
      backgroundColor: Colors.blue.shade900,
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(
          icon,
          color: Colors.white,
        ),
      ),
    );
  }
}
