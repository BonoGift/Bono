class HistoryModel {
  String date;
  String senderName;
  String senderImage;
  String senderNumber;
  String receiverName;
  String receiverNumber;
  String receiverImage;
  double price;
  String trackingStatus;
  String giftImage;

  HistoryModel(
      {this.date = '',
      this.giftImage = '',
      this.price = 0.0,
      this.receiverImage = '',
      this.receiverName = '',
      this.receiverNumber = '',
      this.senderImage = '',
      this.senderName = '',
      this.senderNumber = '',
      this.trackingStatus = 'processing'});
}
