import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quran_mp3/controllers/audio_controller.dart';
import 'package:quran_mp3/widgets/download_button.dart';

import '../core/custom_repeat_off_icon.dart';
import 'playlist_queue_widget.dart';

class AudioPlayerSection extends StatefulWidget {
  const AudioPlayerSection({super.key});

  @override
  State<AudioPlayerSection> createState() => _AudioPlayerSectionState();
}

class _AudioPlayerSectionState extends State<AudioPlayerSection> {
  final audioCtrl = Get.find<AudioController>();

  late double trackTotalDuration;
  late double trackCurrentPos;

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
                      audioCtrl.choiceText.value,
                      style:
                          const TextStyle(fontSize: 18, fontStyle: FontStyle.italic),
                    ),
                  ),
                ),
                Obx(
                  () {
                    final trackCurrentPos =
                        audioCtrl.currentPosition.value.inSeconds.toDouble();
                    final trackTotalDuration =
                        audioCtrl.totalDuration.value.inSeconds.toDouble();

                    return Slider(
                        min: 0,
                        max: trackTotalDuration,
                        value: trackCurrentPos,
                        onChanged: (value) {
                          audioCtrl.seekTo(Duration(seconds: value.toInt()));
                        });
                  },
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Obx(
                          () => IconButton(
                            onPressed: () {
                              audioCtrl.togglePlaylist();
                            },
                            icon: Icon(audioCtrl.playlistModeIcon.value),
                          ),
                        ),
                        DownloadButton(),
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.share),
                        ),
                        Obx(
                          () => IconButton(
                            onPressed: () => audioCtrl.toggleRepeat(),
                            icon: audioCtrl.repeatPlaying.isFalse
                                ? repeatOff()
                                : const Icon(Icons.repeat),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.only(right: 20),
                      child: Obx(
                        () => Text(audioCtrl.timing.value),
                      ),
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
                onPressed: () {
                  audioCtrl.seekForward();
                },
              ),
              const SizedBox(width: 5),
              Obx(
                () => _MaterialCircleButton(
                  icon: audioCtrl.playIcon.value,
                  radius: 28,
                  elevation: 10,
                  color: Colors.purpleAccent,
                  onPressed: () async {
                    audioCtrl.togglePlayback();
                  },
                ),
              ),
              const SizedBox(width: 5),
              _MaterialCircleButton(
                icon: Icons.replay_10,
                onPressed: () {
                  audioCtrl.seekBackward();
                },
              ),
            ],
          ),
        ),
        Positioned(
          top: -25,
          right: 10,
          child: IconButton(
            onPressed: () {
              final renderBox = context.findRenderObject() as RenderBox;
              final offset = renderBox.localToGlobal(Offset.zero);

              List<PlaylistItem> list = [
                PlaylistItem(
                    suraNumber: "1",
                    suraName: "الفاتحة",
                    reciterName: "أبو بكر الشاطري"),
                PlaylistItem(
                    suraNumber: "2",
                    suraName: "البقرة",
                    reciterName: "أحمد بن علي العجمي"),
              ];

              showPlaylistPopupMenuOverlay(
                context,
                list,
                () => setState(() {
                  list.clear();
                }),
                offset,
              );
            },
            icon: Icon(
              Icons.playlist_add_circle_rounded,
              color: Colors.deepPurpleAccent,
              size: 40,
            ),
          ),
        )
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
