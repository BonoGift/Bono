import 'dart:math';
import 'dart:typed_data';

import 'package:bono_gifts/config/constants.dart';
import 'package:bono_gifts/config/destination.dart';
import 'package:bono_gifts/models/feeds_models.dart';
import 'package:bono_gifts/provider/sign_up_provider.dart';
import 'package:bono_gifts/services/feeds_services.dart';
import 'package:bono_gifts/views/camera/camera_view.dart';
import 'package:bono_gifts/views/camera/video_view.dart';
import 'package:camera/camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';

class FeedsProvider extends ChangeNotifier{
  XFile? image;
  Uint8List? bytesImage;
  String title = '';
  String description = '';
  TextEditingController commnetController = TextEditingController();

  late CameraController _cameraController;
  late Future<void> cameraValue;
  bool isRecoring = false;
  bool flash = false;
  bool iscamerafront = true;
  double transform = 0;
  late List<CameraDescription> camera;
  CameraController get cameraController => _cameraController;

  static int index = 0;

  setIndex(int ind){
    index = ind;
    print(index);
    notifyListeners();
  }

   List<AllDestinations> allDestinations = [
    AllDestinations(name: 'Chat', icon: index == 0 ? chatIconBlue :chatIconGrey),
    AllDestinations(name: 'Buy', icon:index == 1 ? giftIconBlue : giftIConGrey),
    AllDestinations(name: 'Feeds', icon:index == 2 ? feedIconBlue:feedIConGrey),
    AllDestinations(name: 'Camera', icon:index == 3 ? cameraIconBlue:cameraIconGrey),
    AllDestinations(name: 'Profile', icon: index == 4 ? profileIconBlue : profileIconGrey),
  ];
  
  final colRef = FirebaseFirestore.instance.collection('userPosts');


  dispostCameraController(){
    _cameraController.dispose();
  }

  onOFfFlash(){
    flash = !flash;
    flash
        ? _cameraController
        .setFlashMode(FlashMode.torch)
        : _cameraController.setFlashMode(FlashMode.off);
    notifyListeners();
  }

  recordVideo()async{
    await _cameraController.startVideoRecording();
    isRecoring = true;
    notifyListeners();
  }

  stopRecordVideo(BuildContext context)async{
    XFile videopath =
        await _cameraController.stopVideoRecording();

      isRecoring = false;

    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (builder) => VideoViewPage(
              path: videopath.path,
            ),),
    );
    notifyListeners();
  }

  void takePhoto(BuildContext context) async {
    XFile file = await _cameraController.takePicture();
    bytesImage = await file.readAsBytes();
    // bytesImage = x;
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (builder) => CameraViewPage(
              path: file.path,
              bytes: bytesImage!,
            )));
  }

  flipCamera(){
      iscamerafront = !iscamerafront;
      transform = transform + pi;
    int cameraPos = iscamerafront ? 0 : 1;
    _cameraController = CameraController(
        camera[cameraPos], ResolutionPreset.high);
    cameraValue = _cameraController.initialize();
    notifyListeners();
  }

  takePhotoProvider(BuildContext context){
    if (!isRecoring) takePhoto(context);
  }

  getImage()async{
    XFile? tempImage = await ImagePicker().pickImage(source: ImageSource.gallery);
    image = tempImage;
    bytesImage = await image!.readAsBytes();
    notifyListeners();
  }

  assignImage(Uint8List image){
    bytesImage = image;
    notifyListeners();
  }

  getCamera()async{
    await availableCameras().then((value) {
        camera = value;
      _cameraController = CameraController(camera[0], ResolutionPreset.high);
      cameraValue = _cameraController.initialize();
      notifyListeners();
    });
  }

  setDescription(String des){
    description = des;
  }
  setTitle(String titl){
    title = titl;
  }

  final service = FeedsService();

  List<FeedsModels> feeds = [];

  uploadPost(BuildContext context){
    final pro = Provider.of<SignUpProvider>(context,listen: false);
    Map<String,dynamic> data = {
      'title':title,
      'des':description,
      'image':bytesImage,
      'phone':pro.phone,
      'profileImage': pro.userImage,
      'profileName':pro.name,
    };
    service.savePost(data,generateRandomString(20)).then((value) {
      if(value){
        getFeedsPosts(context);
        Navigator.pop(context);
      }
    });

  }

  openDescription(int i){
    feeds[i].isDesOpen = !feeds[i].isDesOpen;
    notifyListeners();
  }

  Future<void> getFeedsPosts(BuildContext context)async{
    feeds.clear();
    final pro = Provider.of<SignUpProvider>(context,listen: false);
    await service.getFeedsPosts().then((value){
      value.docs.forEach((fed) {
        feeds.add(FeedsModels(image: fed['image url'], description: fed['des'],
          title: fed['title'], date: fed['timestamp'].toDate(),
          profileImage: fed['profileImage'],profileName: fed['profileName'],
          isDesOpen: false,phone: fed['phone'],docid: fed.id,
          like: fed['like'],
          share: fed['share'],
          isLiked: false,
        ),
        );
        print("Feeds list length ${feeds.length}");
        notifyListeners();
      });
      print("docs length ${value.docs.length}");
      for(var f = 0; f < feeds.length;f++){
        service.getLikePost(pro.phone!, feeds[f].docid).then((value) {
          if(value == true){
            print("true");
            feeds[f].isLiked = true;
          }else{
            print("false");
            feeds[f].isLiked = false;
          }
        });
        notifyListeners();
      }
    });
  }

  addComment(String docRed,BuildContext context){
    service.addComments(docRed, context, commnetController.text);
    commnetController.clear();
  }

  incrementLike(int i){
    if(feeds[i].isLiked == true){
      print("like");
      feeds[i].like = feeds[i].like - 1;
      print(feeds[i].like);
      notifyListeners();
    }else{
      print("dlike");
      feeds[i].like = feeds[i].like + 1;
      print(feeds[i].like);
      notifyListeners();
    }
    notifyListeners();
  }

  sharePost(String title,String image){
    Share.share("Post From Bono\n$title,\n$image");
  }


  setCommentText(String val){
    commnetController = TextEditingController(text: val);
  }


  List<AssetEntity> imageList = [];


  getPhotoGAllery()async{
    var result = await PhotoManager.requestPermissionExtend();
    if (result.isAuth) {
      List<AssetPathEntity> list = await PhotoManager.getAssetPathList(onlyAll: true,);
      List<AssetEntity> media = await list[0].getAssetListPaged(0, 20);
      imageList = media;
      notifyListeners();
      // success
    } else {
      // fail
      /// if result is fail, you can call `PhotoManager.openSetting();`  to open android/ios applicaton's setting to get permission
    }
  }
  callGetLike(BuildContext context,String postDoc){
    getLikeButton(context,postDoc);
  }
  static String imagee = "assets/feeds_icons/like-icon.png";
   String getLikeButton(BuildContext context,String postDoc){
    final pro = Provider.of<SignUpProvider>(context,listen: false);
    // late String x;
     service.getLikePost(pro.phone!, postDoc).then((value){
      if(value == true){
        print("trueee caledd");
         LikeClass.likeBtn = "assets/feeds_icons/like-icon.png";
      }else{
        print("falseeeeeee caledd");
        LikeClass.likeBtn = "assets/feeds_icons/like-icon-grey-.png";
      }
    });
     print(LikeClass.likeBtn);
     Future.delayed(Duration(seconds: 1));
     return LikeClass.likeBtn;
    // print("nothing calledd");
  }
  addLike(String docRed,int like,BuildContext context, int index){
     feeds[index].isLiked = !feeds[index].isLiked;
    final pro = Provider.of<SignUpProvider>(context,listen: false);
    service.addLike(docRed, like,pro.phone!);
    notifyListeners();
  }

  int like = 0;

    getLikeCount(String docId)async{

    await FirebaseFirestore.instance.collection('userPosts').doc(docId).get().then((event) {
       like = event.data()!['like'];
       print("likeeeeeeeee $like");
    });
    // return "0";
    notifyListeners();

  }

    String? photo;
    String? phonee;
    DateTime? dob;
    String? name;
    String? building;
    String? area;
    String? street;
    String? room;
    String? country;
    List postsUsers = [];
    String? networkDiffDays;

  getNetworkUserData(String phone)async{
    await service.getNetworkProfile(phone).then((data){
      dob = data['dobFormat'].toDate();
      name = data['name'];
      photo = data['profile_url'];
      area = data['area'];
      building = data['buildingName'];
      room = data['villa'];
      street = data['street'];
      country = data['country'];
      phonee = data['phone'];
      getDateDiff();
      notifyListeners();
      print(data);
    });
    await service.getUsersPost(phone).then((value){
      postsUsers = [];
      for(var i in value.docs){
        print("docs my post $i");
        postsUsers.add(i['image url']);
        print("docs my post length ${postsUsers.length}");
      }
      print(value.docs);
      notifyListeners();
    });
    notifyListeners();
  }
  getDateDiff(){
    DateTime d = DateTime.now();
    var daOfBirth = DateTime(d.year,dob!.month,dob!.day);
    var todayDate = DateTime(d.year,d.month,d.day);
    var io = daOfBirth.difference(todayDate).inDays;
    networkDiffDays = io.toString();
    notifyListeners();
  }


}
class LikeClass{
  static String likeBtn = 'assets/feeds_icons/like-icon-grey-.png';
}