class NetWorkModel {
  String photo;
  String name;
  String phone;
  String? country;
  bool isSelect;

  NetWorkModel({
    required this.name,
    required this.phone,
    required this.photo,
     this.country,
    required this.isSelect,
  });
}
