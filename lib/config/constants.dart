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

double getHeight(BuildContext context) => MediaQuery.of(context).size.height;
double getWidth(BuildContext context) => MediaQuery.of(context).size.width;

const Color lightBlue = Color(0xffCEE5EE);

var r = Random();
const _chars = 'BCDEFGxcbHIJKLsdfdMNOPhfQRSTUdfdfcvVWXYZ';
String generateRandomString(int len) => List.generate(len, (index) => _chars[r.nextInt(_chars.length)]).join();

