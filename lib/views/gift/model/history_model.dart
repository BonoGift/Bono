import 'package:intl/intl.dart';

class HistoryModel {
  int? id;
  dynamic date;
  String? senderName;
  String? senderImage;
  String? senderNumber;
  String? receiverName;
  String? receiverNumber;
  String? receiverImage;
  double? price;
  String? status;
  String? giftImage;
  bool isReceived = false;

  HistoryModel({
    this.id,
    this.date,
    this.giftImage,
    this.price,
    this.receiverImage,
    this.receiverName,
    this.receiverNumber,
    this.senderImage,
    this.senderName,
    this.senderNumber,
    this.status,
  });

  HistoryModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        date = format.format(json['date'].toDate()),
        giftImage = json['gift-image'],
        price = json['price'].toDouble(),
        receiverImage = json['receiver-image'],
        receiverName = json['receiver-name'],
        receiverNumber = json['receiver-number'],
        senderImage = json['sender-image'],
        senderName = json['sender-name'],
        senderNumber = json['sender-number'],
        status = json['status'];

  Map<String, dynamic> toJson() => {
        'id': id,
        'date': date,
        'gift-image': giftImage,
        'price': price,
        'receiver-image': receiverImage,
        'receiver-name': receiverName,
        'receiver-number': receiverNumber,
        'sender-image': senderImage,
        'sender-name': senderName,
        'sender-number': senderNumber,
        'status': status
      };

  static DateFormat format = DateFormat('dd-MMMM-yyyy');
}
