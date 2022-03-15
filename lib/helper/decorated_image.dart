import 'package:flutter/material.dart';

class DecoratedImage extends StatelessWidget {
  final String image;
  final double? height;
  final double? width;
  final BoxFit fit;

  DecoratedImage({
    required this.image,
    this.height,
    this.width,
    this.fit = BoxFit.cover,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black26, width: 5),
        borderRadius: BorderRadius.circular(10),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(4),
        child: FadeInImage.assetNetwork(
          placeholder: 'assets/images/placeholder.jpg',
          fit: fit,
          image: image,
        ),
      ),
    );
  }
}
