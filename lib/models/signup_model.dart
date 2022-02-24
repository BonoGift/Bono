
class SignUpModel{
  String phone;
  String dob;
  String address;
  String name;
  String? email;
  String country;
  String? image;

  SignUpModel({required this.phone,required this.dob,
    required this.address,required this.name,this.email,required this.country,this.image});

  Map<String, dynamic> toMap(){
  return{
    'phone':phone,
    'dob':dob,
    'address':address,
    'name':name,
    'email':email,
    'country':country,
   };
  }

  factory SignUpModel.fromDocument(Map<String, dynamic> docs) {
    return SignUpModel(
      name: docs['name'].toString(),
      email: docs['email'].toString(),
      phone: docs['phone'].toString(),
      country: docs['country'].toString(),
      dob: docs['dob'].toString(),
      image: docs['imageURL'].toString(),
      address: "${docs['area'].toString()}${docs['street'].toString()}"
    );
  }

}