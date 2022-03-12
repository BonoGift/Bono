import 'dart:math' as math;

import 'package:bono_gifts/config/constants.dart';
import 'package:flutter/material.dart';

class LoadingGiftsWidget extends StatefulWidget {
  const LoadingGiftsWidget({Key? key}) : super(key: key);

  @override
  State<LoadingGiftsWidget> createState() => _LoadingGiftsWidgetState();
}

class _LoadingGiftsWidgetState extends State<LoadingGiftsWidget> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    _controller = AnimationController(
      duration: const Duration(milliseconds: 5000),
      vsync: this,
    )
      ..forward()
      ..addListener(() {
        if (_controller.isCompleted) {
          _controller.repeat();
        }
      });
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              "Searching for Gifts...",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: Color(0xFF2081dc)),
            ),
            const SizedBox(height: 16.0),
            Image.asset(
              'assets/images/icons/robot.png',
              width: getWidth(context) * 0.25,
            ),
          ],
        ),
        AnimatedBuilder(
          animation: _controller,
          child: Image.asset(
            'assets/images/icons/giftboxes.png',
            width: getWidth(context) * 0.7,
          ),
          builder: (context, child) => Transform.rotate(
            angle: _controller.value * 2 * math.pi,
            child: child,
          ),
        )
      ],
    );
  }
}
