class MoveListModel {
  String photo;
  String name;
  String phone;
  String? country;
  int status;

  MoveListModel({
    required this.name,
    required this.phone,
    required this.photo,
    this.country,
    required this.status,
  });
}
