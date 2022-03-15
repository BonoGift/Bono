import 'package:bono_gifts/config/constants.dart';
import 'package:bono_gifts/provider/feeds_provider.dart';
import 'package:bono_gifts/routes/routes_names.dart';
import 'package:bono_gifts/views/chat/chat_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import '../../provider/sign_up_provider.dart';
import '../sendGift/sendGift.dart';

class Feeds extends StatefulWidget {
  @override
  _FeedsState createState() => _FeedsState();
}

class _FeedsState extends State<Feeds> {
  TextEditingController commnetController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final pro = Provider.of<FeedsProvider>(context, listen: false);
    pro.getFeedsPosts(context);
  }

  @override
  Widget build(BuildContext context) {
    var formt = DateFormat('dd-MMM-yyyy');
    final commentDateFormat = DateFormat('dd MMM yyyy');
    final pro = Provider.of<FeedsProvider>(context);

    return RefreshIndicator(
      onRefresh: () {
        return pro.getFeedsPosts(context);
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                color: lightBlue,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    RotationTransition(
                      turns: const AlwaysStoppedAnimation(15 / -180),
                      child: Image.asset(
                        butteryFly,
                        height: 30,
                      ),
                    ),
                    RotationTransition(
                      turns: const AlwaysStoppedAnimation(15 / -180),
                      child: Image.asset(
                        butteryFly,
                        height: 50,
                      ),
                    ),
                    RotatedBox(
                      quarterTurns: 4,
                      child: Image.asset(
                        logo,
                        height: 80,
                      ),
                    ),
                    RotationTransition(
                      turns: const AlwaysStoppedAnimation(15 / 320),
                      child: Image.asset(
                        butteryFly,
                        height: 50,
                      ),
                    ),
                    RotationTransition(
                      turns: const AlwaysStoppedAnimation(15 / 320),
                      child: Image.asset(
                        butteryFly,
                        height: 30,
                      ),
                    ),
                  ],
                ),
              ),
              InkWell(
                onTap: () => Navigator.pushNamed(context, addPOst),
                child: Container(
                  color: Colors.white,
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      RotatedBox(
                        quarterTurns: 4,
                        child: Image.asset(
                          addBtn,
                          height: 30,
                        ),
                      ),
                      const SizedBox(width: 10),
                      const Text(
                        "Post a celebration or event",
                        style: TextStyle(fontSize: 20),
                      )
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10),
              if (pro.feeds.isEmpty)
                const Center(
                  child: CircularProgressIndicator(),
                )
              else
                ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: pro.feeds.length,
                  itemBuilder: (ctx, i) {
                    return Column(
                      children: [
                        InkWell(
                          onTap: () {
                            pro.getNetworkUserData(pro.feeds[i].phone);
                            Future.delayed(const Duration(seconds: 1), () {
                              Navigator.pushNamed(context, userProfile);
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            color: Colors.white,
                            child: Stack(
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 16),
                                        child: Text(
                                          pro.feeds[i].profileName,
                                          textAlign: TextAlign.center,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                    ClipOval(
                                      child: CachedNetworkImage(
                                        imageUrl: pro.feeds[i].profileImage,
                                        progressIndicatorBuilder: (context, url, progress) => SizedBox(
                                          width: 64,
                                          height: 64,
                                          child: Shimmer.fromColors(
                                            baseColor: Colors.grey[300]!,
                                            highlightColor: Colors.white,
                                            child: Container(
                                              decoration: const BoxDecoration(
                                                color: Colors.grey,
                                              ),
                                            ),
                                          ),
                                        ),
                                        fit: BoxFit.cover,
                                        width: 64,
                                        height: 64,
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        formt.format(pro.feeds[i].date).toString(),
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(color: Colors.black, fontSize: 16),
                                      ),
                                    ),
                                  ],
                                ),
                                Positioned(
                                  top: -12,
                                  right: 0,
                                  child: InkWell(
                                    onTap: () {
                                      print('clicked');
                                      showModalBottomSheet(
                                          isScrollControlled: true,
                                          shape: const RoundedRectangleBorder(
                                            borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(36),
                                              topRight: Radius.circular(36),
                                            ),
                                          ),
                                          context: context,
                                          builder: (cntext) {
                                            return Stack(
                                              children: [
                                                Column(
                                                  mainAxisSize: MainAxisSize.min,
                                                  children: [
                                                    const SizedBox(height: 16),
                                                    Container(
                                                      decoration: BoxDecoration(
                                                        color: Colors.grey[600],
                                                        borderRadius: BorderRadius.circular(4),
                                                      ),
                                                      height: 8,
                                                      width: getWidth(context) * 0.45,
                                                    ),
                                                    const SizedBox(height: 16),
                                                    const Text(
                                                      'Report Abuse',
                                                      style: TextStyle(
                                                        fontWeight: FontWeight.bold,
                                                        fontSize: 20,
                                                      ),
                                                    ),
                                                    const SizedBox(height: 20),
                                                    _getReportBottomSheetTextWidget(context, title: 'Spam or fake'),
                                                    _getReportBottomSheetDividerWidget(),
                                                    _getReportBottomSheetTextWidget(context, title: 'Harasment or hateful'),
                                                    _getReportBottomSheetDividerWidget(),
                                                    _getReportBottomSheetTextWidget(context, title: 'Violence'),
                                                    _getReportBottomSheetDividerWidget(),
                                                    _getReportBottomSheetTextWidget(context, title: 'Adult content or nuddity'),
                                                    _getReportBottomSheetDividerWidget(),
                                                    _getReportBottomSheetTextWidget(context, title: 'Copy right violation'),
                                                    _getReportBottomSheetDividerWidget(),
                                                    _getReportBottomSheetTextWidget(context, title: 'Other'),
                                                    const SizedBox(height: 40),
                                                  ],
                                                ),
                                                Positioned(
                                                  top: 16,
                                                  right: 24,
                                                  child: InkWell(
                                                    onTap: () {
                                                      Navigator.pop(context);
                                                    },
                                                    child: Container(
                                                      padding: const EdgeInsets.all(2),
                                                      decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        border: Border.all(color: Colors.grey),
                                                      ),
                                                      child: const Icon(
                                                        Icons.close,
                                                        color: Colors.grey,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            );
                                          });
                                    },
                                    child: Icon(
                                      Icons.more_horiz,
                                      color: Colors.grey.withOpacity(0.6),
                                      size: 48,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Stack(
                          children: [
                            CachedNetworkImage(
                              progressIndicatorBuilder: (context, url, progress) => SizedBox(
                                width: getWidth(context),
                                height: getHeight(context) * 0.7,
                                child: Shimmer.fromColors(
                                  baseColor: Colors.grey[300]!,
                                  highlightColor: Colors.white,
                                  child: Container(
                                    decoration: const BoxDecoration(
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                              ),
                              imageUrl: pro.feeds[i].image,
                              width: getWidth(context),
                              height: getHeight(context) * 0.7,
                              fit: BoxFit.cover,
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  const SizedBox(height: 10),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: InkWell(
                                      onTap: () {
                                        pro.sharePost(
                                          pro.feeds[i].title,
                                          pro.feeds[i].image,
                                        );
                                      },
                                      child: Column(
                                        children: [
                                          Image.asset(
                                            sharedIcon,
                                            height: 40,
                                            width: 40,
                                          ),
                                          const Text(
                                            "",
                                            style: TextStyle(color: Colors.white),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: InkWell(
                                        onTap: () {
                                          showModalBottomSheet(
                                              isScrollControlled: true,
                                              useRootNavigator: true,
                                              context: context,
                                              builder: (contxt) {
                                                commnetController.clear();
                                                return Scaffold(
                                                  backgroundColor: Colors.transparent,
                                                  resizeToAvoidBottomInset: true,
                                                  body: Container(
                                                    decoration: const BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius: BorderRadius.only(
                                                        topLeft: Radius.circular(10.0),
                                                        topRight: Radius.circular(10.0),
                                                      ),
                                                    ),
                                                    //height: MediaQuery.of(context).size.height,
                                                    child: SingleChildScrollView(
                                                      child: Column(
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        children: [
                                                          _getCommentsWidget(pro, i, commentDateFormat),
                                                          _writeCommentWidget(context, pro, i),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              });
                                        },
                                        child: Column(
                                          children: [
                                            Image.asset(
                                              commentIcon,
                                              height: 40,
                                              width: 40,
                                            ),
                                            StreamBuilder(
                                              stream: FirebaseFirestore.instance.collection('userPosts').doc(pro.feeds[i].docid).collection('comments').snapshots(),
                                              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                                                if (snapshot.data == null) {
                                                  return const Text(
                                                    "0",
                                                    style: TextStyle(color: Colors.white),
                                                  );
                                                } else {
                                                  return Text(
                                                    snapshot.data!.docs.length.toString(),
                                                    style: const TextStyle(color: Colors.white),
                                                  );
                                                }
                                              },
                                            )
                                          ],
                                        )),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: InkWell(
                                      onTap: () {
                                        if (!pro.feeds[i].isLiked) {
                                          pro.playLikeAudio();
                                        }
                                        pro.incrementLike(i);
                                        pro.addLike(pro.feeds[i].docid, pro.feeds[i].like, context, i);
                                        pro.callGetLike(context, pro.feeds[i].docid);
                                      },
                                      child: Column(
                                        children: [
                                          Image.asset(
                                            pro.feeds[i].isLiked ? "assets/feeds_icons/like-icon.png" : "assets/feeds_icons/like-icon-grey-.png",
                                            height: 40,
                                            width: 40,
                                          ),
                                          Text(
                                            pro.feeds[i].like.toString(),
                                            style: const TextStyle(color: Colors.white),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: InkWell(
                                      onTap: () {
                                        Navigator.push(context, MaterialPageRoute(builder: (context) => ChatScreen(recieverName: pro.feeds[i].profileName, profileImage: pro.feeds[i].profileImage, recieverPhone: pro.feeds[i].phone)));
                                      },
                                      child: Column(
                                        children: [
                                          Image.asset(
                                            chatIconNew,
                                            height: 40,
                                            width: 40,
                                          ),
                                          // Text("0",style: TextStyle(color: Colors.white),)
                                        ],
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: InkWell(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => SendGiftPage(
                                              username: pro.feeds[i].profileName,
                                              phone: pro.feeds[i].phone,
                                              photo: pro.feeds[i].profileImage,
                                            ),
                                          ),
                                        );
                                      },
                                      child: Column(
                                        children: [
                                          Image.asset(
                                            giftICon,
                                            height: 40,
                                            width: 40,
                                          ),
                                          const Text(
                                            "",
                                            style: TextStyle(color: Colors.white),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Positioned(
                              left: 0,
                              right: 0,
                              top: 0,
                              child: InkWell(
                                onTap: () {
                                  pro.openDescription(i);
                                },
                                child: Container(
                                  color: Colors.black.withOpacity(pro.feeds[i].isDesOpen ? 0.8 : 0.4),
                                  padding: const EdgeInsets.only(top: 8),
                                  child: Column(
                                    children: [
                                      SizedBox(
                                        width: MediaQuery.of(context).size.width * 0.75,
                                        child: Center(
                                          child: Text(
                                            pro.feeds[i].title,
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 20,
                                              overflow: pro.feeds[i].isDesOpen ? null : TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 12),
                                      pro.feeds[i].isDesOpen
                                          ? Container(
                                              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                                              child: Text(
                                                pro.feeds[i].description.toString(),
                                                style: const TextStyle(color: Colors.white, fontSize: 15),
                                              ),
                                            )
                                          : Container(),
                                      pro.feeds[i].isDesOpen ? const SizedBox(height: 10) : Container()
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              top: 4,
                              right: 0,
                              child: Align(
                                alignment: Alignment.topRight,
                                child: InkWell(
                                  onTap: () {
                                    pro.openDescription(i);
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.only(right: 8),
                                    child: Column(
                                      children: [
                                        Text(
                                          pro.feeds[i].isDesOpen ? "Less" : "Read",
                                          style: const TextStyle(color: Colors.white, fontSize: 12),
                                        ),
                                        Image.asset(
                                          'assets/images/icons/down_arrow.png',
                                          width: 16,
                                          height: 16,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Container(
                          height: 10,
                          color: Colors.grey[100],
                        )
                      ],
                    );
                  },
                )
            ],
          ),
        ),
      ),
    );
  }

  Widget _getReportBottomSheetTextWidget(BuildContext context, {required String title}) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: InkWell(
            splashColor: Colors.lightBlue,
            onTap: () {
              Future.delayed(const Duration(milliseconds: 300), () {
                Navigator.pop(context);
              });
            },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Center(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _getReportBottomSheetDividerWidget() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: const Divider(
        thickness: 0.5,
        color: Colors.grey,
      ),
    );
  }

  Widget _writeCommentWidget(BuildContext context, FeedsProvider pro, int i) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.95,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        color: Colors.grey.withOpacity(0.4),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 4),
      margin: const EdgeInsets.only(bottom: 20, top: 8),
      child: Row(
        children: [
          const SizedBox(width: 10),
          Expanded(
            child: TextFormField(
              keyboardType: TextInputType.multiline,
              maxLines: null,
              onChanged: (val) {
                //pro.setCommentText(val);
              },
              controller: commnetController,
              decoration: const InputDecoration(
                hintText: "Write a comment...",
                border: InputBorder.none,
              ),
            ),
          ),
          IconButton(
            onPressed: () async {
              if (commnetController.text.isEmpty) return;
              await pro.addComment(pro.feeds[i].docid, commnetController.text, context);
              FocusManager.instance.primaryFocus?.unfocus();
            },
            icon: const Icon(Icons.send),
          ),
        ],
      ),
    );
  }

  Widget _getCommentsWidget(FeedsProvider pro, int i, DateFormat commentDateFormat) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.9,
      child: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 32),
            StreamBuilder(
              stream: pro.colRef.doc(pro.feeds[i].docid).collection('comments').orderBy('date', descending: true).snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasData) {
                  List<DocumentSnapshot> docs = snapshot.data!.docs;
                  String postId = pro.feeds[i].docid;
                  return Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Expanded(child: SizedBox.shrink()),
                          Expanded(
                            flex: 2,
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 24),
                              child: Center(
                                child: Text(
                                  'Comments ${snapshot.data!.docs.length.toString()}',
                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: InkWell(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: Container(
                                padding: const EdgeInsets.all(2),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(color: Colors.grey),
                                ),
                                child: const Icon(
                                  Icons.close,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      ListView.builder(
                        primary: false,
                        itemCount: docs.length,
                        shrinkWrap: true,
                        itemBuilder: (context, i) {
                          DateTime dt = (docs[i]['date'] as Timestamp).toDate();
                          return _getCommentWidget(
                            docs,
                            i,
                            commentDateFormat,
                            dt,
                            pro,
                            postId,
                          );
                        },
                      ),
                    ],
                  );
                } else {
                  return const Center(
                    child: Text("No Comments"),
                  );
                }
              },
            )
          ],
        ),
      ),
    );
  }

  Widget _getCommentWidget(
    List<DocumentSnapshot<Object?>> docs,
    int i,
    DateFormat commentDateFormat,
    DateTime dt,
    FeedsProvider pro,
    String postId,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.3),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    docs[i]['image'] == '' || docs[i]['image'] == null
                        ? CircleAvatar(
                            child: Image.asset('assets/images/placeholder.jpg'),
                          )
                        : CircleAvatar(
                            backgroundImage: NetworkImage(docs[i]['image'].toString()),
                          ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                docs[i]['name'] ?? '',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.only(right: 12),
                                child: Text(
                                  commentDateFormat.format(dt),
                                  style: const TextStyle(fontSize: 10),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.only(right: 12),
                            child: Text(
                              docs[i]['text'] ?? '',
                              textAlign: TextAlign.justify,
                            ),
                          ),
                          const SizedBox(height: 16),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                bottom: -20,
                right: -4,
                child: StreamBuilder(
                    stream: pro.colRef.doc(postId).collection('comments').doc(docs[i].id).collection('likedBy').snapshots(),
                    builder: (context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return SizedBox.shrink();
                      } else if (snapshot.hasData) {
                        final signUpPro = Provider.of<SignUpProvider>(context, listen: false);

                        List<DocumentSnapshot> documentsSnapshot = snapshot.data!.docs;
                        List<String> name = [];
                        String likedById = '';
                        documentsSnapshot.forEach((element) {
                          name.add(element['name']);
                          if (element['name'] == signUpPro.name) {
                            likedById = element.id;
                          }
                        });
                        return InkWell(
                          onTap: () {
                            print('clicked');
                            pro.likeComment(
                              postId,
                              docs[i].id,
                              likedById,
                              context,
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.only(left: 24, top: 24),
                            //color: Colors.blue,
                            child: Column(
                              children: [
                                Image.asset(
                                  pro.checkCommentIsLikedByMe(context, name),
                                  width: 24,
                                  height: 24,
                                ),
                                Text(
                                  documentsSnapshot.isNotEmpty ? documentsSnapshot.length.toString() : '',
                                  style: const TextStyle(fontSize: 12),
                                ),
                              ],
                            ),
                          ),
                        );
                      } else {
                        return const SizedBox.shrink();
                      }
                    }),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
