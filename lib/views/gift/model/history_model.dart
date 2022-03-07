import 'package:intl/intl.dart';

class HistoryModel {
  dynamic date;
  String senderName;
  String senderImage;
  String senderNumber;
  String receiverName;
  String receiverNumber;
  String receiverImage;
  double price;
  String trackingStatus;
  String giftImage;
  bool isReceived = false;

  HistoryModel({
    this.date = '',
    this.giftImage = '',
    this.price = 0.0,
    this.receiverImage = '',
    this.receiverName = '',
    this.receiverNumber = '',
    this.senderImage = '',
    this.senderName = '',
    this.senderNumber = '',
    this.trackingStatus = 'processing',
  });

  HistoryModel.fromJson(Map<String, dynamic> json)
      : date = format.format(json['date'].toDate()),
        giftImage = json['gift-image'],
        price = json['price'].toDouble(),
        receiverImage = json['receiver-image'],
        receiverName = json['receiver-name'],
        receiverNumber = json['receiver-number'],
        senderImage = json['sender-image'],
        senderName = json['sender-name'],
        senderNumber = json['sender-number'],
        trackingStatus = json['tracking-status'];

  Map<String, dynamic> toJson() => {
        'date': date,
        'gift-image': giftImage,
        'price': price,
        'receiver-image': receiverImage,
        'receiver-name': receiverName,
        'receiver-number': receiverNumber,
        'sender-image': senderImage,
        'sender-name': senderName,
        'sender-number': senderNumber,
        'tracking-status': trackingStatus
      };

  static DateFormat format = DateFormat('dd-MMMM-yyyy');
}
