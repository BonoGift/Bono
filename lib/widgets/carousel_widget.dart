import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../config/constants.dart';
import '../models/wcmp_api/vendor_product.dart';

class CarouselWidget extends StatefulWidget {
  final List<Images> images;
  final int initialPage;

  const CarouselWidget({
    Key? key,
    required this.images,
    required this.initialPage,
  }) : super(key: key);

  @override
  _CarouselWidgetState createState() => _CarouselWidgetState();
}

class _CarouselWidgetState extends State<CarouselWidget> {
  late int initialPage;
  final CarouselController _controller = CarouselController();

  @override
  void initState() {
    super.initState();
    initialPage = widget.initialPage;
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      height: getHeight(context),
      child: Stack(
        children: [
          CarouselSlider(
            carouselController: _controller,
            items: _getCarouselItemsWidget(widget.images),
            options: CarouselOptions(
              initialPage: widget.initialPage,
              height: double.infinity,
              viewportFraction: 1.0,
              enlargeCenterPage: false,
              onPageChanged: (index, reason) {
                setState(() {
                  initialPage = index;
                });
              },
            ),
          ),
          Positioned(
            bottom: 24,
            left: 0,
            right: 0,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 500),
              child: Wrap(
                alignment: WrapAlignment.center,
                spacing: 8,
                children: widget.images.map((element) {
                  int index = widget.images.indexOf(element);
                  return Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: initialPage == index ? Colors.yellow : Colors.grey,
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          Positioned(
            top: 16,
            left: 16,
            child: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: const Icon(
                Icons.close_sharp,
                size: 24,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _getCarouselItemsWidget(List<Images> items) {
    return items.map((e) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: CachedNetworkImage(
          imageUrl: e.src ?? '',
          progressIndicatorBuilder: (context, url, progress) => SizedBox(
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
        ),
      );
    }).toList();
  }

}
