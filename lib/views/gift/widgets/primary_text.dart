import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PrimaryText extends StatelessWidget {
  final String text;
  final Color color;
  final int maxLines;
  final double fontSize;
  final TextAlign textAlign;
  final FontWeight? fontWeight;

  PrimaryText({
    required this.text,
    this.color = Colors.black,
    this.fontSize = 20,
    this.textAlign = TextAlign.start,
    this.maxLines = 1,
    this.fontWeight,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      maxLines: maxLines,
      overflow: TextOverflow.ellipsis,
      textAlign: textAlign,
      style: TextStyle(
        color: color,
        fontSize: fontSize,
        fontWeight: fontWeight ?? FontWeight.w500,
      ),
    );
  }
}
