import 'package:bono_gifts/models/network_model.dart';

class BirthdayNetworkModel {
  String? month;
  List<NetWorkModel> items;
  int? sequence;

  BirthdayNetworkModel({
    this.month,
    required this.items,
    this.sequence,
  });
}