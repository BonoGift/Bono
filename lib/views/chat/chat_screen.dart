import 'dart:async';
import 'dart:io';

import 'package:auto_size_text_field/auto_size_text_field.dart';
import 'package:bono_gifts/config/constants.dart';
import 'package:bono_gifts/provider/chat_provider.dart';
import 'package:bono_gifts/provider/sign_up_provider.dart';
import 'package:bono_gifts/services/chat_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

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
    _controller.animateTo(
      _controller.position.maxScrollExtent,
      duration: const Duration(seconds: 2),
      curve: Curves.fastOutSlowIn,
    );
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
    Future.delayed(const Duration(seconds: 2), () {
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
          decoration: const BoxDecoration(image: DecorationImage(fit: BoxFit.fill, image: AssetImage("assets/images/chatbg.jpg"))),
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                decoration: const BoxDecoration(color: Colors.white, boxShadow: [BoxShadow(color: Colors.grey, offset: Offset(0.0, 0.2), blurRadius: 3, spreadRadius: 2)]),
                padding: const EdgeInsets.all(8),
                child: SafeArea(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          IconButton(
                            onPressed: () => Navigator.pop(context),
                            icon: const Icon(Icons.arrow_back),
                          ),
                          Column(
                            children: [
                              CircleAvatar(
                                backgroundImage: NetworkImage(widget.profileImage),
                              )
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
                              Row(
                                children: const [
                                  Icon(
                                    Icons.circle,
                                    color: Colors.green,
                                    size: 10,
                                  ),
                                  Text("Online"),
                                ],
                              )
                            ],
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Image.asset(
                            "assets/images/icons/product_icon.png",
                            height: 25,
                            width: 25,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: StreamBuilder(
                  stream: documentStream,
                  builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.data == null) {
                      return Container();
                    } else {
                      lastIndex = snapshot.data!.docs.length;
                      print(snapshot.data!.docs.length);
                      print(lastIndex);
                      return ListView(
                        controller: _controller,
                        // physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        children: snapshot.data!.docs.map((DocumentSnapshot document) {
                          Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
                          return Padding(
                            padding: EdgeInsets.all(10.0),
                            child: Column(
                              crossAxisAlignment: data['senderID'] == pro.phone ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                              children: <Widget>[
                                if (data['messageType'] == 'text') ...[
                                  SizedBox(
                                    width: getWidth(context) / 1.5,
                                    child: Stack(
                                      children: [
                                        InkWell(
                                          onDoubleTap: () {
                                            print(data['id']);
                                            proChat.likeMessage(data['senderID'] == pro.phone ? pro.phone! : widget.recieverPhone, data['senderID'] == pro.phone ? widget.recieverPhone : pro.phone!, data['id'], data['isFavorite'] == true ? false : true);
                                          },
                                          child: Align(
                                            alignment: data['senderID'] == pro.phone ? Alignment.centerRight : Alignment.centerLeft,
                                            child: Material(
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
                                                    fontSize: 15.0,
                                                  ),
                                                ),
                                              ),
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
                                    child: SizedBox(
                                      width: getWidth(context) / 1.9,
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
              ),
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
                              icon: const Icon(Icons.camera_alt),
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
                                  child: Center(
                                    child: AutoSizeTextField(
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
                                        hintText: "Type Your Message",
                                        suffixIcon: IconButton(
                                            onPressed: () {
                                              setState(() {
                                                emojiShowing = !emojiShowing;
                                                SystemChannels.textInput.invokeMethod('TextInput.hide');
                                              });
                                            },
                                            icon: const Icon(
                                              Icons.star,
                                              color: Colors.lightBlueAccent,
                                            )),
                                        // prefix: IconButton(onPressed: (){}, icon: Icon(Icons.star,color: Colors.lightBlueAccent,)),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            // const SizedBox(width: 30,),
                            // SizedBox(width: 10,),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: InkWell(
                                // minWidth: 10,
                                onTap: () {
                                  proChat.generateRandomString(13);
                                  setState(() {
                                    messageCount++;
                                  });
                                  proChat.sendTextMessage(context, message, widget.recieverPhone, messageCount.toString(), widget.recieverName, widget.profileImage);
                                  message.clear();
                                  _scrollDown();
                                },
                                child: Image.asset(
                                  "assets/images/icons/arrow_icon.png",
                                  height: 20,
                                  width: 20,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    // Align(
                    //   alignment: Alignment(0.8,-0.4),
                    //   child: Container(
                    //     height: 60,
                    //     child: GestureDetector(
                    //       onLongPress: (){
                    //         setState(() {
                    //           isRecording = true;
                    //         });
                    //         startTime();
                    //       },
                    //       child: Icon(Icons.mic),
                    //       onLongPressEnd: (va){
                    //         setState(() {
                    //           isRecording = false;
                    //         });
                    //         stopTime();
                    //
                    //       },
                    //     ),
                    //   ),
                    // )
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
}
