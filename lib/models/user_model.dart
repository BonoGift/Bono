class UserModel {
  final String phoneNumber;
  final String name;
  final DateTime dobFormat;
  final String email;
  final String imageUrl;
  final String country;
  final String city;
  final String villa;
  final String buildingName;
  final String area;
  final String street;
  final String profileUrl;

  UserModel({
    required this.phoneNumber,
    required this.name,
    required this.dobFormat,
    required this.email,
    required this.imageUrl,
    required this.country,
    required this.city,
    required this.villa,
    required this.buildingName,
    required this.area,
    required this.street,
    required this.profileUrl,
  });

  Map<String, dynamic> toMap() {
    return {
      'city': city,
      'country': country,
      'email': email,
      'area': area,
      'buildingName': buildingName,
      'dobFormat': dobFormat,
      'name': name,
      'phone': phoneNumber,
      'villa': villa,
      'street': street,
      'image url': imageUrl,
      'profile_url': profileUrl,
    };
  }

  factory UserModel.fromDocument(Map<String, dynamic> docs) {
    return UserModel(
      city: docs['city'],
      country: docs['country'],
      email: docs['email'],
      area: docs['area'],
      buildingName: docs['buildingName'],
      dobFormat: docs['dobFormat'].toDate(),
      name: docs['name'],
      phoneNumber: docs['phone'],
      villa: docs['villa'],
      street: docs['street'],
      imageUrl: docs['image url'],
      profileUrl: docs['profile_url'],
    );
  }
}
