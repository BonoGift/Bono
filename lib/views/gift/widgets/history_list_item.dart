import 'package:bono_gifts/helper/decorated_container.dart';
import 'package:bono_gifts/helper/decorated_image.dart';
import 'package:bono_gifts/views/gift/model/history_model.dart';
import 'package:bono_gifts/views/gift/widgets/primary_text.dart';
import 'package:flutter/material.dart';

class HistoryListItem extends StatelessWidget {
  final HistoryModel history;

  HistoryListItem({required this.history});

  @override
  Widget build(BuildContext context) {
    final double _height = MediaQuery.of(context).size.height;
    return DecoratedContainer(
      height: _height * 0.18,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            DecoratedImage(
              image: history.giftImage,
              width: 110,
              height: _height * 0.13,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 10.0, right: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    PrimaryText(
                      text: giftStatus(history.isReceived),
                      maxLines: 2,
                      fontSize: 13,
                      color: Colors.blue,
                    ),
                    PrimaryText(
                      text: 'Tracking Status: ${history.trackingStatus}',
                      fontSize: 13,
                      maxLines: 2,
                    ),
                    PrimaryText(
                      text: history.date.toString(),
                      fontSize: 13,
                    ),
                    PrimaryText(
                      text: '\$${history.price}',
                      fontSize: 13,
                    ),
                  ],
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.linear_scale_sharp,
                  color: Colors.black54,
                  size: 28,
                ),
                ClipOval(
                  child: FadeInImage.assetNetwork(
                      height: 60,
                      width: 60,
                      placeholder: 'assets/images/placeholder.jpg',
                      fit: BoxFit.cover,
                      image: history.isReceived
                          ? history.senderImage
                          : history.receiverImage),
                ),
                const SizedBox(
                  height: 8,
                ),
                Flexible(
                  child: PrimaryText(
                    text: history.isReceived
                        ? history.senderName
                        : history.receiverName,
                    fontSize: 9,
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  String giftStatus(bool isReceived) {
    if (isReceived) {
      return 'You received gift from: ';
    } else {
      return 'You sent gift to: ';
    }
  }
}
