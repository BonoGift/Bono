import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ClipOvalImageWidget extends StatelessWidget {
  final String imageUrl;
  final double? imageWidth;
  final double? imageHeight;

  const ClipOvalImageWidget({
    Key? key,
    required this.imageUrl,
    this.imageWidth,
    this.imageHeight,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: CachedNetworkImage(
        imageUrl: imageUrl,
        width: imageWidth ?? 40,
        height: imageHeight ?? 40,
        fit: BoxFit.cover,
        progressIndicatorBuilder: (context, url, progress) => SizedBox(
          width: imageWidth ?? 40,
          height: imageHeight ?? 40,
          child: Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.white,
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.grey,
              ),
            ),
          ),
        ),
        errorWidget: (BuildContext context, String url, dynamic error) {
          return ClipOval(
            child: Image.asset(
              'assets/images/profile.png',
              width: imageWidth ?? 40,
              height: imageHeight ?? 40,
            ),
          );
        },
      ),
    );
  }
}
