import 'dart:math';
import 'dart:typed_data';

import 'package:audioplayers/audioplayers.dart';
import 'package:bono_gifts/config/constants.dart';
import 'package:bono_gifts/models/feeds_models.dart';
import 'package:bono_gifts/provider/sign_up_provider.dart';
import 'package:bono_gifts/services/feeds_services.dart';
import 'package:bono_gifts/views/camera/camera_view.dart';
import 'package:bono_gifts/views/camera/video_view.dart';
import 'package:camera/camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';

class FeedsProvider extends ChangeNotifier {
  XFile? image;
  Uint8List? bytesImage;
  String title = '';
  String description = '';

  late CameraController _cameraController;
  late Future<void> cameraValue;
  bool isRecoring = false;
  bool flash = false;
  bool iscamerafront = true;
  double transform = 0;
  late List<CameraDescription> camera;

  CameraController get cameraController => _cameraController;

   int index = 0;

  setIndex(int ind) {
    index = ind;
    print(index);
    notifyListeners();
  }
  AudioCache audio = AudioCache(fixedPlayer: AudioPlayer());

  playLikeAudio() {
    audio.play("like.wav");
  }

  final colRef = FirebaseFirestore.instance.collection('userPosts');

  dispostCameraController() {
    _cameraController.dispose();
  }

  onOFfFlash() {
    flash = !flash;
    flash ? _cameraController.setFlashMode(FlashMode.torch) : _cameraController.setFlashMode(FlashMode.off);
    notifyListeners();
  }

  chooseImageFromGallery(BuildContext context) async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 25,
    );
    bytesImage = await image?.readAsBytes();
    if (image == null) return;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (builder) => CameraViewPage(
          path: image.path,
          bytes: bytesImage!,
        ),
      ),
    );
  }

  recordVideo() async {
    await _cameraController.startVideoRecording();
    isRecoring = true;
    notifyListeners();
  }

  stopRecordVideo(BuildContext context) async {
    XFile videopath = await _cameraController.stopVideoRecording();

    isRecoring = false;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (builder) => VideoViewPage(
          path: videopath.path,
        ),
      ),
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

  flipCamera() {
    iscamerafront = !iscamerafront;
    transform = transform + pi;
    int cameraPos = iscamerafront ? 0 : 1;
    _cameraController = CameraController(camera[cameraPos], ResolutionPreset.high);
    cameraValue = _cameraController.initialize();
    notifyListeners();
  }

  takePhotoProvider(BuildContext context) {
    if (!isRecoring) takePhoto(context);
  }

  getImage() async {
    XFile? tempImage = await ImagePicker().pickImage(source: ImageSource.gallery);
    image = tempImage;
    bytesImage = await image!.readAsBytes();
    notifyListeners();
  }

  assignImage(Uint8List image) {
    bytesImage = image;
    notifyListeners();
  }

  getCamera() async {
    await availableCameras().then((value) {
      camera = value;
      _cameraController = CameraController(camera[0], ResolutionPreset.high);
      cameraValue = _cameraController.initialize();
      notifyListeners();
    });
  }

  setDescription(String des) {
    description = des;
  }

  setTitle(String titl) {
    title = titl;
  }

  final service = FeedsService();

  List<FeedsModels> feeds = [];

  uploadPost(BuildContext context) {
    final pro = Provider.of<SignUpProvider>(context, listen: false);
    Map<String, dynamic> data = {
      'title': title,
      'des': description,
      'image': bytesImage,
      'phone': pro.phone,
      'profileImage': pro.userImage,
      'profileName': pro.name,
    };
    service.savePost(data, generateRandomString(20)).then((value) {
      if (value) {
        bytesImage = null;
        getFeedsPosts(context);
        Navigator.pop(context);
      }
    });
  }

  openDescription(int i) {
    feeds[i].isDesOpen = !feeds[i].isDesOpen;
    notifyListeners();
  }

  Future<void> getFeedsPosts(BuildContext context) async {
    feeds.clear();
    final pro = Provider.of<SignUpProvider>(context, listen: false);
    await service.getFeedsPosts().then((value) {
      value.docs.forEach((fed) {
        feeds.add(
          FeedsModels(
            image: fed['image url'],
            description: fed['des'],
            title: fed['title'],
            date: fed['timestamp'].toDate(),
            profileImage: fed['profileImage'] ?? '',
            profileName: fed['profileName'] ?? '',
            isDesOpen: false,
            phone: fed['phone'].toString(),
            docid: fed.id,
            like: fed['like'],
            share: fed['share'],
            isLiked: false,
          ),
        );
        //print("Feeds list length ${feeds.length}");
        notifyListeners();
      });
      //print("docs length ${value.docs.length}");
      for (var f = 0; f < feeds.length; f++) {
        service.getLikePost(pro.phone!, feeds[f].docid).then((value) {
          if (value == true) {
            //print("true");
            feeds[f].isLiked = true;
          } else {
            //print("false");
            feeds[f].isLiked = false;
          }
          notifyListeners();
        });
      }
    });
    //notifyListeners();
  }

  addComment(String docRed, String text, BuildContext context) async {
    await service.addComments(docRed, context, text);
    //notifyListeners();
  }

  String checkCommentIsLikedByMe(BuildContext context, List<String> likedBy) {
    final pro = Provider.of<SignUpProvider>(context, listen: false);
    return likedBy.contains(pro.name) ? 'assets/images/icons/comment_liked_icon.png' : 'assets/images/icons/comment_like_icon.png';
  }

  likeComment(String postId, String commentId, String commentedId, BuildContext context) {
    service.likeComments(postId, commentId, commentedId, context);
  }

  incrementLike(int i) {
    if (feeds[i].isLiked == true) {
      feeds[i].like = feeds[i].like - 1;
    } else {
      feeds[i].like = feeds[i].like + 1;
    }
    notifyListeners();
  }

  sharePost(String title, String image) {
    Share.share("Post From Bono\n$title,\n$image");
  }

  setCommentText(String val) {
    //commnetController = TextEditingController(text: val);
  }

  List<AssetEntity> imageList = [];

  getPhotoGAllery() async {
    var result = await PhotoManager.requestPermissionExtend();
    if (result.isAuth) {
      List<AssetPathEntity> list = await PhotoManager.getAssetPathList(
        onlyAll: true,
      );
      List<AssetEntity> media = await list[0].getAssetListPaged(0, 20);
      imageList = media;
      notifyListeners();
      // success
    } else {
      // fail
      /// if result is fail, you can call `PhotoManager.openSetting();`  to open android/ios applicaton's setting to get permission
    }
  }

  callGetLike(BuildContext context, String postDoc) {
    return getLikeButton(context, postDoc);
  }

  static String imagee = "assets/feeds_icons/like-icon.png";

  String getLikeButton(BuildContext context, String postDoc) {
    final pro = Provider.of<SignUpProvider>(context, listen: false);
    // late String x;
    service.getLikePost(pro.phone!, postDoc).then((value) {
      if (value == true) {
        print("trueee caledd");
        LikeClass.likeBtn = "assets/feeds_icons/like-icon.png";
      } else {
        print("falseeeeeee caledd");
        LikeClass.likeBtn = "assets/feeds_icons/like-icon-grey-.png";
      }
    });
    print(LikeClass.likeBtn);
    //Future.delayed(Duration(seconds: 1));
    return LikeClass.likeBtn;
    // print("nothing calledd");
  }

  addLike(String docRed, int numberOfLikes, BuildContext context, int index) {
    feeds[index].isLiked = !feeds[index].isLiked;
    final pro = Provider.of<SignUpProvider>(context, listen: false);
    service.addLike(docRed, numberOfLikes, pro.phone!);
    notifyListeners();
  }

  int like = 0;

  getLikeCount(String docId) async {
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
  List<String> postsUsers = [];
  String? networkDiffDays;

  Future<void> getNetworkUserData(String phone) async {
    await service.getNetworkProfile(phone).then((data) {
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
    await service.getUsersPost(phone).then((value) {
      postsUsers = [];
      for (var i in value.docs) {
        print("docs my post $i");
        postsUsers.add(i['image url']);
        print("docs my post length ${postsUsers.length}");
      }
      print(value.docs);
      notifyListeners();
    });
    notifyListeners();
  }

  getDateDiff() {
    DateTime d = DateTime.now();
    var daOfBirth = DateTime(d.year, dob!.month, dob!.day);
    var todayDate = DateTime(d.year, d.month, d.day);
    var io = daOfBirth.difference(todayDate).inDays;
    if (io < 0) {
      io = io + 365;
    }
    networkDiffDays = io.toString();
    notifyListeners();
  }
}

class LikeClass {
  static String likeBtn = 'assets/feeds_icons/like-icon-grey-.png';
}
