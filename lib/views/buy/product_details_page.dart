import 'package:bono_gifts/config/constants.dart';
import 'package:bono_gifts/widgets/carousel_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

enum ProductDetailsTab { detailsTab, descTab, aboutSellerTab }

class ProductDetailsPage extends StatefulWidget {
  const ProductDetailsPage({Key? key}) : super(key: key);

  @override
  _ProductDetailsPageState createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  int _selectedIndex = 0;
  ProductDetailsTab _selectedTab = ProductDetailsTab.detailsTab;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                padding: const EdgeInsets.only(left: 16, top: 16),
                child: const Icon(
                  Icons.arrow_back_ios,
                  color: Colors.black,
                  size: 28,
                ),
              ),
            ),
            _getTitleWidget(title: 'Chocolate Cake'),
            Container(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Column(
                children: [
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _getProductBasicInfoWidget(title: 'Size', info: '1k'),
                      _getProductBasicInfoWidget(title: 'Quantity', info: '11'),
                      _getProductBasicInfoWidget(title: 'Price', info: '30\$', textColor: Colors.blue),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _getProductImagesWidget(context),
                ],
              ),
            ),
            _getShipmentInfoWidget(),
            _getTabWidget(),
            _getDividerWidget(),
            _getDetailsInfoWidget(),
            _getDescriptionInfoWidget(),
            _getAboutInfoWidget(),
          ],
        ),
      ),
    );
  }

  Widget _getProductImagesWidget(BuildContext context) {
    return SizedBox(
      height: getHeight(context) * 0.35,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 8,
            child: InkWell(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return StatefulBuilder(
                      builder: (
                        BuildContext context,
                        void Function(void Function()) setState,
                      ) {
                        return CarouselWidget(
                          images: dummyImageList,
                          initialPage: _selectedIndex,
                        );
                      },
                    );
                  },
                );
              },
              child: CachedNetworkImage(
                imageUrl: dummyImageList[_selectedIndex],
                height: getHeight(context) * 0.35,
                fit: BoxFit.fill,
                progressIndicatorBuilder: (context, url, progress) => SizedBox(
                  height: getHeight(context) * 0.35,
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
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            flex: 2,
            child: ListView.separated(
              itemCount: dummyImageList.length,
              shrinkWrap: true,
              padding: const EdgeInsets.all(0),
              itemBuilder: (BuildContext context, int index) {
                return InkWell(
                  onTap: () {
                    _selectedIndex = index;
                    setState(() {});
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.blue, width: _selectedIndex == index ? 2 : 0),
                    ),
                    child: Stack(
                      children: [
                        CachedNetworkImage(
                          imageUrl: dummyImageList[index],
                          height: ((getHeight(context) * 0.35) / 5) - 8,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          progressIndicatorBuilder: (context, url, progress) => SizedBox(
                            height: getHeight(context) * 0.35 - 8,
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
                        if (_selectedIndex != index)
                          Positioned(
                            left: 0,
                            right: 0,
                            child: Container(
                              color: Colors.white.withOpacity(0.4),
                              height: ((getHeight(context) * 0.35) / 5) - 8,
                            ),
                          )
                      ],
                    ),
                  ),
                );
              },
              separatorBuilder: (BuildContext context, int index) {
                return const SizedBox(height: 9);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _getTitleWidget({required String title}) {
    return Center(
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _getAboutInfoWidget() {
    return Visibility(
      visible: _selectedTab == ProductDetailsTab.aboutSellerTab,
      child: Container(
        padding: const EdgeInsets.only(left: 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _getRichTextWidget(
              title: 'About',
              info: 'For Product Multimedia,',
            ),
            _getRichTextWidget(
              title: 'Refresh Rate',
              info: '60 Hz',
            ),
            _getRichTextWidget(
              title: 'Brand Sceptre',
              info: '',
            ),
            _getRichTextWidget(
              title: 'Screen Size',
              info: '24 inches',
            ),
            _getRichTextWidget(
              title: 'Special Feature',
              info: 'Blue Light Filter,',
            ),
            _getRichTextWidget(
              title: 'Tilt Adjustment,',
              info: 'Flicker-Free, Build-In speaker',
            ),
          ],
        ),
      ),
    );
  }

  Widget _getDescriptionInfoWidget() {
    return Visibility(
      visible: _selectedTab == ProductDetailsTab.descTab,
      child: Container(
        padding: const EdgeInsets.only(left: 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _getRichTextWidget(
              title: 'Description',
              info: 'For Product Multimedia,',
            ),
            _getRichTextWidget(
              title: 'Refresh Rate',
              info: '60 Hz',
            ),
            _getRichTextWidget(
              title: 'Brand Sceptre',
              info: '',
            ),
            _getRichTextWidget(
              title: 'Screen Size',
              info: '24 inches',
            ),
            _getRichTextWidget(
              title: 'Special Feature',
              info: 'Blue Light Filter,',
            ),
            _getRichTextWidget(
              title: 'Tilt Adjustment,',
              info: 'Flicker-Free, Build-In speaker',
            ),
          ],
        ),
      ),
    );
  }

  Widget _getDetailsInfoWidget() {
    return Visibility(
      visible: _selectedTab == ProductDetailsTab.detailsTab,
      child: Container(
        padding: const EdgeInsets.only(left: 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _getRichTextWidget(
              title: 'Specific Uses',
              info: 'For Product Multimedia,',
            ),
            _getRichTextWidget(
              title: 'Refresh Rate',
              info: '60 Hz',
            ),
            _getRichTextWidget(
              title: 'Brand Sceptre',
              info: '',
            ),
            _getRichTextWidget(
              title: 'Screen Size',
              info: '24 inches',
            ),
            _getRichTextWidget(
              title: 'Special Feature',
              info: 'Blue Light Filter,',
            ),
            _getRichTextWidget(
              title: 'Tilt Adjustment,',
              info: 'Flicker-Free, Build-In speaker',
            ),
          ],
        ),
      ),
    );
  }

  Widget _getRichTextWidget({
    required String title,
    required String info,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 3),
      width: getWidth(context) * 0.7,
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: '$title ',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            TextSpan(
              text: info,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _getShipmentInfoWidget() {
    return Container(
      color: Colors.black.withOpacity(0.55),
      padding: const EdgeInsets.symmetric(vertical: 4),
      width: double.infinity,
      child: Center(
        child: RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: 'SHIPMENT = Standard Delivery ',
                style: const TextStyle(
                  fontSize: 13,
                ),
              ),
              TextSpan(
                text: '(7USD)',
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.blue[300],
                ),
              ),
              TextSpan(
                text: ': 3 hrs to 24 hrs',
                style: TextStyle(
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _getProductBasicInfoWidget({
    required String title,
    required String info,
    Color? textColor,
  }) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: '$title: ',
            style: const TextStyle(
              color: Colors.black,
              fontSize: 15,
            ),
          ),
          TextSpan(
            text: info,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: textColor ?? Colors.black,
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }

  Widget _getDividerWidget() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: const Divider(
        thickness: 1.0,
        color: Colors.grey,
      ),
    );
  }

  Widget _getTabWidget() {
    return Container(
      padding: const EdgeInsets.only(top: 24, left: 16, right: 16),
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _getTabTextWidget(
              title: 'Details',
              targetTab: ProductDetailsTab.detailsTab,
            ),
            _getTabTextWidget(
              title: 'Description',
              targetTab: ProductDetailsTab.descTab,
            ),
            _getTabTextWidget(
              title: 'About',
              targetTab: ProductDetailsTab.aboutSellerTab,
            ),
          ],
        ),
      ),
    );
  }

  Widget _getTabTextWidget({
    required String title,
    required ProductDetailsTab targetTab,
  }) {
    return InkWell(
      onTap: () {
        _selectedTab = targetTab;
        setState(() {});
      },
      child: SizedBox(
        width: 100,
        child: Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 15,
            color: _selectedTab == targetTab ? Colors.blue : Colors.grey,
            fontWeight: _selectedTab == targetTab ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}
