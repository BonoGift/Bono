import 'dart:math';

import 'package:flutter/material.dart';

const String welcomeBg = 'assets/images/splash_bg.png';
const String logo = 'assets/images/Logo.png';
const String chatIcon = 'assets/images/icons/chat_icon.png';
const String butteryFly = 'assets/images/icons/butterfly_color.png';
const String defaultImage = 'assets/images/profile.png';
const String addBtn = 'assets/images/icons/add_button.png';
const String photoIcon = 'assets/images/icons/camera_image icon.png';

const String buyIcon = 'assets/images/icons/buy_icon.png';
const String cameraICon = 'assets/images/icons/camera_icon.png';
const String profieIcon = 'assets/images/icons/profile_icon.png';

const String chatIconGrey = 'assets/images/chat-icon-grey.png';
const String chatIconBlue = 'assets/images/chat-icon-blue.png';
const String giftIConGrey = 'assets/images/gift-icon-grey.png';
const String giftIconBlue = 'assets/images/gift-icon-blue.png';
const String feedIConGrey = 'assets/images/Feeds-icon-grey.png';
const String feedIconBlue = 'assets/images/Feeds-icon-blue.png';
const String cameraIconGrey = 'assets/images/camera-icon-grey.png';
const String cameraIconBlue = 'assets/images/camera-icon-blue.png';
const String profileIconGrey = 'assets/images/profile-icon-grey.png';
const String profileIconBlue = 'assets/images/profile-icon-blue.png';

const String sharedIcon = 'assets/feeds_icons/share.png';
const String commentIcon = 'assets/feeds_icons/Comment.png';
const String giftICon = 'assets/feeds_icons/Gift.png';
const String chatIconNew = 'assets/feeds_icons/chat.png';

/// put it here temporary
const String dummyImage = 'https://images.unsplash.com/photo-1578985545062-69928b1d9587?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxleHBsb3JlLWZlZWR8NHx8fGVufDB8fHx8&w=1000&q=80';
const List<String> dummyImageList = [
  'https://images.unsplash.com/photo-1606983340126-99ab4feaa64a?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MXx8YmlydGhkYXklMjBjYWtlc3xlbnwwfHwwfHw%3D&w=1000&q=80',
  'https://hpbd.name/uploads/worigin/2021/07/07/chocolate-birthday-wishes-cake-with-name-edit_2482a.jpg',
  'https://images.immediate.co.uk/production/volatile/sites/30/2020/08/triple-chocolate-peanut-butter-layer-cake-2-06eee24.jpg',
  'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSprk-AyMqY5bJ7DdYqsP6-PvC80qzQ1cqsEBDmfXGrXohBhRpoUqVJmPy7Fv_bDOXdZXg&usqp=CAU',
  'https://assets.tmecosys.com/image/upload/t_web767x639/img/recipe/ras/Assets/26A885F4-97C9-44FF-8D0C-E482F27D63D2/Derivates/C4E61759-F7ED-4160-9FE4-B73888B44CFB.jpg',
];

double getHeight(BuildContext context) => MediaQuery.of(context).size.height;

double getWidth(BuildContext context) => MediaQuery.of(context).size.width;

const Color lightBlue = Color(0xffCEE5EE);

var r = Random();
const _chars = 'BCDEFGxcbHIJKLsdfdMNOPhfQRSTUdfdfcvVWXYZ';

String generateRandomString(int len) => List.generate(len, (index) => _chars[r.nextInt(_chars.length)]).join();
