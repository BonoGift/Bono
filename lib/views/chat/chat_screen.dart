import 'dart:async';
import 'dart:io';

import 'package:auto_size_text_field/auto_size_text_field.dart';
import 'package:bono_gifts/config/constants.dart';
import 'package:bono_gifts/provider/chat_provider.dart';
import 'package:bono_gifts/provider/sign_up_provider.dart';
import 'package:bono_gifts/routes/routes_names.dart';
import 'package:bono_gifts/services/chat_service.dart';
import 'package:bono_gifts/widgets/ClipOvalImageWidget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

import '../../provider/feeds_provider.dart';
import '../../routes/routes_names.dart';
import '../sendGift/sendGift.dart';

class ChatScreen extends StatefulWidget {
  final String recieverName;
  final String profileImage;
  final String recieverPhone;

  ChatScreen({
    required this.recieverName,
    required this.profileImage,
    required this.recieverPhone,
  });

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  bool isKeyboardOpen = false;
  int lastIndex = 0;
  final ScrollController _controller = ScrollController();
  late AutoScrollController chatController;
  int messageCount = 0;
  bool isRecording = false;
  DateTime date = DateTime.now();
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  TextEditingController message = TextEditingController();
  bool emojiShowing = false;

  Timer? time;

  int voiceTimeSec = 0;
  int voiceTimeMin = 0;

  startTime() {
    time = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (voiceTimeSec == 59) {
        setState(() {
          voiceTimeMin++;
          voiceTimeSec = 0;
        });
      } else {
        setState(() {
          voiceTimeSec++;
        });
      }
    });
  }

  stopTime() {
    time!.cancel();
  }

  void _scrollDown() {
    _controller.animateTo(_controller.position.maxScrollExtent, duration: Duration(milliseconds: 300), curve: Curves.easeOut);
    /*_controller.animateTo(
      _controller.position.maxScrollExtent,
      duration: const Duration(seconds: 2),
      curve: Curves.fastOutSlowIn,
    );*/
  }

  _onBackspacePressed() {
    message
      ..text = message.text.characters.skipLast(1).toString()
      ..selection = TextSelection.fromPosition(TextPosition(offset: message.text.length));
  }

  _onEmojiSelected(Emoji emoji) {
    message
      ..text += emoji.emoji
      ..selection = TextSelection.fromPosition(TextPosition(offset: message.text.length));
  }

  Future _scrollChat(int index) async {
    await chatController.scrollToIndex(index, preferPosition: AutoScrollPosition.end);
  }

  @override
  void initState() {
    super.initState();
    final pro = Provider.of<SignUpProvider>(context, listen: false);
    final proc = Provider.of<ChatProvider>(context, listen: false);
    chatController = AutoScrollController(viewportBoundaryGetter: () => Rect.fromLTRB(0, 0, 0, MediaQuery.of(context).padding.bottom), axis: Axis.horizontal);
    firestore.collection('recentChats').doc(pro.phone).collection('myChats').doc(widget.recieverPhone).snapshots().listen((event) {
      // messageCount = int.parse(event.data()?['count']);
      if (event.data()?['isSendMe'] == false) {
        proc.playRecieveMessage();
      }
      print("${event.data()?['isSendMe']}");
      print(messageCount);
    });
    Future.delayed(const Duration(milliseconds: 500), () {
      _scrollDown();
    });
  }

  @override
  Widget build(BuildContext context) {
    final pro = Provider.of<SignUpProvider>(context);
    final proChat = Provider.of<ChatProvider>(context);
    final Stream<QuerySnapshot> documentStream = firestore.collection('chats').doc(pro.phone.toString()).collection(widget.recieverPhone).orderBy('timestamp').snapshots();
    return SafeArea(
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.fill,
              image: AssetImage("assets/images/chat_screen_bg.png"),
            ),
          ),
          child: Column(
            children: [
              _getAppBarWidget(context),
              _getMessagesWidget(documentStream, pro, proChat),
              // isKeyboardOpen ? SizedBox(height: 50,):Container(),
              Container(
                color: Colors.grey[300],
                child: Stack(
                  children: [
                    Offstage(
                      offstage: isRecording,
                      child: Center(
                        child: Row(
                          children: [
                            IconButton(
                              onPressed: () async {
                                proChat.generateRandomString(13);
                                XFile? image;
                                final ImagePicker _picker = ImagePicker();
                                image = await _picker.pickImage(source: ImageSource.gallery, imageQuality: 70);
                                if (image == null) return;
                                var bytes = await image.readAsBytes();
                                if (bytes != null) {
                                  print(image.path);
                                  String filename = image.path.split("/").last;
                                  String imageUrl = await ChatService().uploadImage(bytes, widget.recieverPhone, filename, pro.phone!);
                                  print(imageUrl);
                                  proChat.sendImageMessage(context, imageUrl, widget.recieverPhone, messageCount.toString(), widget.recieverName, widget.profileImage);
                                  _scrollDown();
                                }
                              },
                              icon: Image.asset(
                                "assets/images/icons/camera.png",
                                height: 40,
                                width: 40,
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Container(
                                  padding: const EdgeInsets.all(4.0),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    color: Colors.white,
                                  ),
                                  // height: 50,
                                  child: AutoSizeTextField(
                                    minFontSize: 16,
                                    maxLines: null,
                                    onEditingComplete: () {
                                      setState(() {
                                        isKeyboardOpen = !isKeyboardOpen;
                                      });
                                    },
                                    onTap: () {
                                      if (message.text.isNotEmpty) {
                                        setState(() {
                                          emojiShowing = !emojiShowing;
                                          isKeyboardOpen = !isKeyboardOpen;
                                        });
                                      }
                                    },
                                    controller: message,
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      suffixIcon: InkWell(
                                        onTap: () {
                                          setState(() {
                                            emojiShowing = !emojiShowing;
                                            SystemChannels.textInput.invokeMethod('TextInput.hide');
                                          });
                                        },
                                        child: const Icon(
                                          Icons.star,
                                          color: Colors.lightBlueAccent,
                                        ),
                                      ),
                                      // prefix: IconButton(onPressed: (){}, icon: Icon(Icons.star,color: Colors.lightBlueAccent,)),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: InkWell(
                                onTap: () {
                                  if (message.text.isEmpty) return;
                                  proChat.generateRandomString(13);
                                  setState(() {
                                    messageCount++;
                                  });
                                  proChat.sendTextMessage(context, message, widget.recieverPhone, messageCount.toString(), widget.recieverName, widget.profileImage);
                                  message.clear();
                                  _scrollDown();
                                },
                                child: Image.asset(
                                  "assets/images/icons/send_arrow.png",
                                  height: 20,
                                  width: 20,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Offstage(
                offstage: !emojiShowing,
                child: SizedBox(
                  height: 250,
                  child: EmojiPicker(
                      onEmojiSelected: (Category category, Emoji emoji) {
                        _onEmojiSelected(emoji);
                      },
                      onBackspacePressed: _onBackspacePressed,
                      config: Config(
                          columns: 7,
                          // Issue: https://github.com/flutter/flutter/issues/28894
                          emojiSizeMax: 32 * (Platform.isIOS ? 1.30 : 1.0),
                          verticalSpacing: 0,
                          horizontalSpacing: 0,
                          initCategory: Category.RECENT,
                          bgColor: const Color(0xFFF2F2F2),
                          indicatorColor: Colors.blue,
                          iconColor: Colors.grey,
                          iconColorSelected: Colors.blue,
                          progressIndicatorColor: Colors.blue,
                          backspaceColor: Colors.blue,
                          showRecentsTab: true,
                          recentsLimit: 28,
                          noRecentsText: 'No Recents',
                          noRecentsStyle: const TextStyle(fontSize: 20, color: Colors.black26),
                          tabIndicatorAnimDuration: kTabScrollDuration,
                          categoryIcons: const CategoryIcons(),
                          buttonMode: ButtonMode.MATERIAL)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<String> allDateTimeList = [];

  bool checkDate(String targetDateTime) {
    bool found = allDateTimeList.contains(targetDateTime);
    if (found) {
      allDateTimeList.removeWhere((element) => element == targetDateTime);
    }
    return found;
  }

  Widget _getMessagesWidget(Stream<QuerySnapshot<Object?>> documentStream, SignUpProvider pro, ChatProvider proChat) {
    DateFormat timeFormat = DateFormat('hh:mm a');
    DateFormat dateFormat = DateFormat('MMMM dd');
    return Expanded(
      child: StreamBuilder(
        stream: documentStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.data == null) {
            return Container();
          } else {
            lastIndex = snapshot.data!.docs.length;
            //print(snapshot.data!.docs.length);
            //print(lastIndex);

            if (snapshot.data!.docs.isEmpty) {
              return _getEmptyMessageWidget();
            }
            snapshot.data!.docs.forEach((e) {
              String dateTime = dateFormat.format(DateTime.parse(e['timestamp'].toDate().toString())).toString();
              if (allDateTimeList.contains(dateTime)) return;
              allDateTimeList.add(dateTime);
            });
            print('here');
            return ListView(
              controller: _controller,
              // physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              children: snapshot.data!.docs.map((DocumentSnapshot document) {
                Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: Column(
                    crossAxisAlignment: data['senderID'] == pro.phone ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                    children: [
                      Visibility(
                        visible: checkDate(
                          dateFormat.format(DateTime.parse(data['timestamp'].toDate().toString())).toString(),
                        ),
                        child: Container(
                          color: Colors.white.withOpacity(0.1),
                          padding: const EdgeInsets.all(4),
                          margin: const EdgeInsets.only(bottom: 16),
                          width: getWidth(context),
                          child: Center(
                            child: Text(
                              dateFormat.format(DateTime.parse(data['timestamp'].toDate().toString())).toString(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                      ),
                      if (data['messageType'] == 'text') ...[
                        Container(
                          width: getWidth(context) / 1.5,
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: Stack(
                            children: [
                              InkWell(
                                onDoubleTap: () {
                                  print(data['id']);
                                  proChat.likeMessage(data['senderID'] == pro.phone ? pro.phone! : widget.recieverPhone, data['senderID'] == pro.phone ? widget.recieverPhone : pro.phone!, data['id'], data['isFavorite'] == true ? false : true);
                                },
                                child: Align(
                                  alignment: data['senderID'] == pro.phone ? Alignment.centerRight : Alignment.centerLeft,
                                  child: Column(
                                    crossAxisAlignment: data['senderID'] == pro.phone ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                                    children: [
                                      Material(
                                        borderRadius: data['senderID'] == pro.phone
                                            ? const BorderRadius.only(topLeft: Radius.circular(30.0), bottomLeft: Radius.circular(30.0), bottomRight: Radius.circular(30.0))
                                            : const BorderRadius.only(
                                                bottomLeft: Radius.circular(30.0),
                                                bottomRight: Radius.circular(30.0),
                                                topRight: Radius.circular(30.0),
                                              ),
                                        elevation: 5.0,
                                        color: data['senderID'] == pro.phone ? Colors.lightBlueAccent : Colors.grey[200],
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                                          child: Text(
                                            data['message'],
                                            style: TextStyle(
                                              color: data['senderID'] == pro.phone ? Colors.white : Colors.black54,
                                              fontSize: 18.0,
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        timeFormat.format(DateTime.parse(data['timestamp'].toDate().toString())).toString(),
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 10.0,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              data['isFavorite'] == true
                                  ? Align(
                                      alignment: data['senderID'] == pro.phone ? Alignment.centerLeft : Alignment.centerRight,
                                      child: const Icon(
                                        Icons.favorite,
                                        color: Colors.red,
                                      ),
                                    )
                                  : Container()
                            ],
                          ),
                        ),
                      ] else if (data['messageType'] == 'image') ...[
                        InkWell(
                          onDoubleTap: () {
                            print(data['id']);
                            proChat.likeMessage(data['senderID'] == pro.phone ? pro.phone! : widget.recieverPhone, data['senderID'] == pro.phone ? widget.recieverPhone : pro.phone!, data['id'], data['isFavorite'] == true ? false : true);
                          },
                          child: Container(
                            width: getWidth(context) / 1.9,
                            padding: const EdgeInsets.symmetric(horizontal: 10.0),
                            child: Stack(
                              children: [
                                Align(
                                  alignment: data['senderID'] == pro.phone ? Alignment.centerRight : Alignment.centerLeft,
                                  child: Container(
                                      padding: const EdgeInsets.all(5),
                                      decoration: BoxDecoration(color: Colors.lightBlueAccent, borderRadius: BorderRadius.circular(10)),
                                      width: getWidth(context) / 2,
                                      child: Image.network(
                                        data['message'],
                                        alignment: data['senderID'] == pro.phone ? Alignment.centerRight : Alignment.centerLeft,
                                      )),
                                ),
                                data['isFavorite'] == true
                                    ? Align(
                                        alignment: data['senderID'] == pro.phone ? Alignment.centerLeft : Alignment.centerRight,
                                        child: const Icon(
                                          Icons.favorite,
                                          color: Colors.red,
                                        ),
                                      )
                                    : Container()
                              ],
                            ),
                          ),
                        )
                      ],
                    ],
                  ),
                );
              }).toList(),
            );
          }
        },
      ),
    );
  }

  Widget _getEmptyMessageWidget() {
    return Container(
      padding: const EdgeInsets.only(top: 100),
      width: double.infinity,
      child: Column(
        children: [
          Image.asset(
            'assets/images/cat.png',
            width: 150,
          ),
          const SizedBox(height: 12),
          const Text(
            'Say hello...',
            style: TextStyle(
              color: Colors.white,
              fontSize: 17,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Or surprise them with a gift!',
            style: TextStyle(
              color: Colors.white,
              fontSize: 17,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _getAppBarWidget(BuildContext context) {
    final pro = Provider.of<FeedsProvider>(context);

    return Container(
      decoration: const BoxDecoration(color: Colors.white, boxShadow: [BoxShadow(color: Colors.grey, offset: Offset(0.0, 0.2), blurRadius: 3, spreadRadius: 2)]),
      padding: const EdgeInsets.all(8),
      child: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            InkWell(
              onTap: () async {
                await pro.getNetworkUserData(widget.recieverPhone);
                Navigator.pushNamed(context, userProfile);
              },
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back_ios),
                  ),
                  Column(
                    children: [
                      ClipOvalImageWidget(
                        imageUrl: widget.profileImage,
                        imageWidth: 45,
                        imageHeight: 45,
                      ),
                    ],
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.recieverName,
                        style: const TextStyle(fontSize: 18),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: const [
                          Icon(
                            Icons.circle,
                            color: Colors.green,
                            size: 10,
                          ),
                          SizedBox(width: 4),
                          Text("Online"),
                        ],
                      )
                    ],
                  ),
                ],
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SendGiftPage(
                      username: widget.recieverName,
                      phone: widget.recieverPhone,
                      photo: widget.profileImage,
                    ),
                  ),
                );
              },
              child: Row(
                children: [
                  Image.asset(
                    "assets/images/icons/chat_gift_box.png",
                    height: 40,
                    width: 40,
                  ),
                  const SizedBox(width: 8),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
