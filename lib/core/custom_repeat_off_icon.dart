import 'package:flutter/material.dart';

///there is no official Icons.repeat_off in the Flutter Icons class,
///since this this is the only icon I want, instead of adding an entire dependency to my app,
///I created a custom
Widget repeatOff() {
  return Stack(
    alignment: Alignment.center,
    children: [
      const Icon(
        Icons.repeat,
        color: Colors.black87,
      ),
      Transform.rotate(
        angle: 0.8, // angle of the slash
        child: Container(
          width: 24,
          height: 2,
          color: Colors.black87,
        ),
      ),
    ],
  );
}
