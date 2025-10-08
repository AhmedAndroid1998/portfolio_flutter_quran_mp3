import 'package:flutter/material.dart';

class AudioPlayerSection extends StatefulWidget {
  const AudioPlayerSection({super.key});

  @override
  State<AudioPlayerSection> createState() => _AudioPlayerSectionState();
}

class _AudioPlayerSectionState extends State<AudioPlayerSection> {
  double _currentValue = 0;
  final double _maxValue = 60;

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
                const Padding(
                  padding: EdgeInsets.only(top: 30.0),
                  child: Text(
                    'اختر اسم الشيخ والسورة',
                    style: TextStyle(fontSize: 18, fontStyle: FontStyle.italic),
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
          top: -20,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _CircleButton(Icons.forward_10),
              const SizedBox(width: 5),
              _CircleButton(Icons.play_arrow, radius: 28),
              const SizedBox(width: 5),
              _CircleButton(Icons.replay_10),
            ],
          ),
        ),
      ],
    );
  }

  Widget _CircleButton(IconData icon, {double radius = 24}) {
    return CircleAvatar(
      radius: radius,
      backgroundColor: Colors.blue.shade900,
      child: IconButton(
        onPressed: () {},
        icon: Icon(
          icon,
          color: Colors.white,
        ),
      ),
    );
  }
}
