import 'package:bono_gifts/config/constants.dart';
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
            Expanded(
              child: DecoratedImage(
                image: history.giftImage!,
                width: getWidth(context) * 0.25,
                height: getWidth(context) * 0.25,
              ),
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.only(left: 10.0, right: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    PrimaryText(
                      text: giftStatus(history.isReceived),
                      maxLines: 2,
                      fontSize: 13,
                      color: history.isReceived ? Colors.deepPurple : Colors.blue,
                    ),
                    PrimaryText(
                      text: 'Status: ${history.status}',
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
            Expanded(
              flex: 1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ClipOval(
                    child: FadeInImage.assetNetwork(height: 60, width: 60, placeholder: 'assets/images/placeholder.jpg', fit: BoxFit.cover, image: history.isReceived ? history.senderImage! : history.receiverImage!),
                  ),
                  const SizedBox(height: 8),
                  Flexible(
                    child: PrimaryText(
                      text: history.isReceived ? history.senderName! : history.receiverName!,
                      fontSize: 9,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 8),
                ],
              ),
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
