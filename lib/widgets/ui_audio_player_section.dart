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
          top: -25,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _MaterialCircleButton(
                icon: Icons.forward_10,
                onPressed: () {},
              ),
              const SizedBox(width: 5),
              _MaterialCircleButton(
                icon: Icons.play_arrow,
                radius: 28,
                elevation: 10,
                color: Colors.purpleAccent,
                onPressed: () {},
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
