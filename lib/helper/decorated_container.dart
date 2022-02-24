import 'package:flutter/material.dart';

class DecoratedContainer extends StatelessWidget {
  final double? height;
  final Widget child;
  DecoratedContainer({required this.height, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(color: Colors.grey[100], boxShadow: const [
        BoxShadow(
          color: Colors.black12,
          blurRadius: 6,
          spreadRadius: 0,
          offset: Offset(0, 6),
        )
      ]),
      child: child,
    );
  }
}
