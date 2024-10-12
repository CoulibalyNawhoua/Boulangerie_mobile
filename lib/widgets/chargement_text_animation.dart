import 'dart:async';

import 'package:flutter/material.dart';

class ChargementTextAnimation extends StatefulWidget {
  const ChargementTextAnimation({super.key});

  @override
  State<ChargementTextAnimation> createState() => _ChargementTextAnimationState();
}

class _ChargementTextAnimationState extends State<ChargementTextAnimation> {
  late Timer timer;
  int pointCount = 0;

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  void startTimer() {
    const Duration duration = Duration(milliseconds: 500);
    timer = Timer.periodic(duration, (Timer t) {
      setState(() {
        pointCount = (pointCount + 1) % 4;
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "Chargement",
          style: TextStyle(fontSize: 18),
        ),
        for (int i = 0; i < pointCount; i++)
          const Text(
            '.',
            style: TextStyle(fontSize: 18),
          ),
      ],
    );
  }
   @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }
}