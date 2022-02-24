class FeedsModels{

  String image;
  String title;
  String description;
  DateTime date;
  String profileImage;
  String profileName;
  bool isDesOpen;
  String phone;
  String docid;
  int like;
  int share;
  bool isLiked;

  FeedsModels({required this.image,required this.description,
    required this.title,required this.date,required this.profileImage,
    required this.profileName,required this.isDesOpen,required this.phone,
    required this.docid,required this.like,required this.share,required this.isLiked});

}