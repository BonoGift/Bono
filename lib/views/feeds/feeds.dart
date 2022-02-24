import 'package:bono_gifts/config/constants.dart';
import 'package:bono_gifts/provider/feeds_provider.dart';
import 'package:bono_gifts/routes/routes_names.dart';
import 'package:bono_gifts/views/chat/chat_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

class Feeds extends StatefulWidget {
  @override
  _FeedsState createState() => _FeedsState();
}

class _FeedsState extends State<Feeds> {
  @override
  void initState() {
    super.initState();
    final pro = Provider.of<FeedsProvider>(context, listen: false);
    pro.getFeedsPosts(context);
  }

  @override
  Widget build(BuildContext context) {
    var formt = DateFormat('dd-MMM-yyyy');
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
                      const SizedBox(
                        width: 10,
                      ),
                      const Text(
                        "Post a celebration or event",
                        style: TextStyle(fontSize: 20),
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              pro.feeds.isEmpty
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: pro.feeds.length,
                      itemBuilder: (ctx, i) {
                        return Column(
                          children: [
                            InkWell(
                              onTap: () {
                                pro.getNetworkUserData(pro.feeds[i].phone);
                                Future.delayed(Duration(seconds: 1), () {
                                  Navigator.pushNamed(context, userProfile);
                                });
                              },
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                color: Colors.white,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Text(
                                      pro.feeds[i].profileName,
                                      style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w400),
                                    ),
                                    CircleAvatar(
                                      radius: 25,
                                      backgroundImage: NetworkImage(
                                          pro.feeds[i].profileImage),
                                    ),
                                    // SizedBox(
                                    //   height: 7,
                                    // ),
                                    Text(
                                      formt
                                          .format(pro.feeds[i].date)
                                          .toString(),
                                      style: const TextStyle(
                                          color: Colors.black, fontSize: 12),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            // const SizedBox(
                            //   height: 10,
                            // ),
                            // const SizedBox(height: 5,),
                            Stack(
                              children: [
                                Image.network(
                                  pro.feeds[i].image,
                                  width: getWidth(context),
                                  fit: BoxFit.cover,
                                ),
                                Positioned(
                                  bottom: 0,
                                  right: 0,
                                  // alignment: Alignment.bottomRight,
                                  child: Container(
                                    // color:Colors.black.withOpacity(0.2),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: InkWell(
                                            onTap: () {
                                              pro.sharePost(pro.feeds[i].title,
                                                  pro.feeds[i].image);
                                            },
                                            child: Column(
                                              children: [
                                                Image.asset(
                                                  sharedIcon,
                                                  height: 40,
                                                  width: 40,
                                                ),
                                                Text(
                                                  "0",
                                                  style: TextStyle(
                                                      color: Colors.white),
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
                                                    context: context,
                                                    builder: (contxt) {
                                                      return SafeArea(
                                                        child: Container(
                                                          color: Colors
                                                              .transparent,
                                                          child: Container(
                                                            decoration: const BoxDecoration(
                                                                color: Colors
                                                                    .white,
                                                                borderRadius: BorderRadius.only(
                                                                    topLeft: Radius
                                                                        .circular(
                                                                            10.0),
                                                                    topRight: Radius
                                                                        .circular(
                                                                            10.0))),
                                                            height:
                                                                MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .height,
                                                            child: Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: [
                                                                Column(
                                                                  children: [
                                                                    const SizedBox(
                                                                      height:
                                                                          20,
                                                                    ),
                                                                    const Divider(),
                                                                    StreamBuilder(
                                                                      stream: pro
                                                                          .colRef
                                                                          .doc(pro
                                                                              .feeds[i]
                                                                              .docid)
                                                                          .collection('comments')
                                                                          .snapshots(),
                                                                      builder: (context,
                                                                          AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                                                                              snapshot) {
                                                                        if (snapshot.connectionState ==
                                                                            ConnectionState.waiting) {
                                                                          return const Center(
                                                                            child:
                                                                                CircularProgressIndicator(),
                                                                          );
                                                                        } else if (snapshot
                                                                            .hasData) {
                                                                          List<DocumentSnapshot>
                                                                              docs =
                                                                              snapshot.data!.docs;
                                                                          return ListView
                                                                              .builder(
                                                                            physics:
                                                                                const NeverScrollableScrollPhysics(),
                                                                            itemCount:
                                                                                docs.length,
                                                                            shrinkWrap:
                                                                                true,
                                                                            itemBuilder:
                                                                                (context, i) {
                                                                              return Padding(
                                                                                padding: const EdgeInsets.all(8.0),
                                                                                child: Container(
                                                                                  padding: const EdgeInsets.all(8.0),
                                                                                  decoration: BoxDecoration(
                                                                                      color: Colors.grey.withOpacity(0.4),
                                                                                      borderRadius: const BorderRadius.only(
                                                                                        topLeft: Radius.circular(20),
                                                                                        topRight: Radius.circular(20),
                                                                                        bottomRight: Radius.circular(20),
                                                                                      )),
                                                                                  child: Row(
                                                                                    children: [
                                                                                      Column(
                                                                                        children: [
                                                                                          docs[i]['image'] == '' || docs[i]['image'] == null
                                                                                              ? CircleAvatar(
                                                                                                  child: Image.asset('assets/images/placeholder.jpg'),
                                                                                                )
                                                                                              : CircleAvatar(
                                                                                                  backgroundImage: NetworkImage(docs[i]['image'].toString()),
                                                                                                )
                                                                                        ],
                                                                                      ),
                                                                                      const SizedBox(
                                                                                        width: 10,
                                                                                      ),
                                                                                      Column(
                                                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                                                        children: [
                                                                                          Text(docs[i]['name'] ?? ''),
                                                                                          Text(docs[i]['text'] ?? ''),
                                                                                        ],
                                                                                      ),
                                                                                    ],
                                                                                  ),
                                                                                ),
                                                                              );
                                                                            },
                                                                          );
                                                                        } else {
                                                                          return const Center(
                                                                            child:
                                                                                Text("No Comments"),
                                                                          );
                                                                        }
                                                                      },
                                                                    )
                                                                  ],
                                                                ),
                                                                Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                              .all(
                                                                          8.0),
                                                                  child:
                                                                      Container(
                                                                    decoration: BoxDecoration(
                                                                        borderRadius:
                                                                            BorderRadius.circular(
                                                                                30),
                                                                        color: Colors
                                                                            .grey
                                                                            .withOpacity(0.4)),
                                                                    padding: const EdgeInsets
                                                                            .only(
                                                                        left:
                                                                            3.0,
                                                                        right:
                                                                            3.0),
                                                                    child: Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .spaceBetween,
                                                                      children: [
                                                                        const SizedBox(
                                                                          width:
                                                                              10,
                                                                        ),
                                                                        Expanded(
                                                                          child:
                                                                              TextField(
                                                                            onChanged:
                                                                                (val) {
                                                                              pro.setCommentText(val);
                                                                            },
                                                                            controller:
                                                                                pro.commnetController,
                                                                            decoration:
                                                                                const InputDecoration(
                                                                              hintText: "Write a comment...",
                                                                              border: InputBorder.none,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        IconButton(
                                                                            onPressed:
                                                                                () {
                                                                              pro.addComment(pro.feeds[i].docid, context);
                                                                            },
                                                                            icon:
                                                                                const Icon(Icons.send))
                                                                      ],
                                                                    ),
                                                                  ),
                                                                )
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
                                                    stream: FirebaseFirestore
                                                        .instance
                                                        .collection('userPosts')
                                                        .doc(pro.feeds[i].docid)
                                                        .collection('comments')
                                                        .snapshots(),
                                                    builder: (context,
                                                        AsyncSnapshot<
                                                                QuerySnapshot>
                                                            snapshot) {
                                                      if (snapshot.data ==
                                                          null) {
                                                        return const Text(
                                                          "0",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white),
                                                        );
                                                      } else {
                                                        return Text(
                                                          snapshot
                                                              .data!.docs.length
                                                              .toString(),
                                                          style:
                                                              const TextStyle(
                                                                  color: Colors
                                                                      .white),
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
                                              pro.incrementLike(i);
                                              pro.addLike(
                                                  pro.feeds[i].docid,
                                                  pro.feeds[i].like,
                                                  context,
                                                  i);
                                              pro.callGetLike(
                                                  context, pro.feeds[i].docid);
                                              // Navigator.push(context, MaterialPageRoute(builder: (context) => ChatScreen(recieverName: pro.feeds[i].profileName,profileImage: pro.feeds[i].profileImage,recieverPhone:pro.feeds[i].phone)));
                                            },
                                            child: Column(
                                              children: [
                                                Image.asset(
                                                  pro.feeds[i].isLiked
                                                      ? "assets/feeds_icons/like-icon.png"
                                                      : "assets/feeds_icons/like-icon-grey-.png",
                                                  height: 40,
                                                  width: 40,
                                                ),
                                                Text(
                                                  pro.feeds[i].like.toString(),
                                                  style: const TextStyle(
                                                      color: Colors.white),
                                                ),
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
                                                      builder: (context) =>
                                                          ChatScreen(
                                                              recieverName: pro
                                                                  .feeds[i]
                                                                  .profileName,
                                                              profileImage: pro
                                                                  .feeds[i]
                                                                  .profileImage,
                                                              recieverPhone: pro
                                                                  .feeds[i]
                                                                  .phone)));
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
                                            onTap: () {},
                                            child: Column(
                                              children: [
                                                Image.asset(
                                                  giftICon,
                                                  height: 40,
                                                  width: 40,
                                                ),
                                                Text(
                                                  "0",
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Positioned(
                                  left: 0,
                                  right: 0,
                                  top: 0,
                                  child: Container(
                                    color: Colors.grey.withOpacity(0.4),
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  3,
                                            ),
                                            Expanded(
                                                child: Text(
                                              pro.feeds[i].title,
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 20),
                                            )),
                                            TextButton(
                                                onPressed: () {
                                                  pro.openDescription(i);
                                                },
                                                child: Text(
                                                    pro.feeds[i].isDesOpen
                                                        ? "Read Less"
                                                        : "Read More"))
                                          ],
                                        ),
                                        pro.feeds[i].isDesOpen
                                            ? Text(
                                                pro.feeds[i].description
                                                    .toString(),
                                                style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 12),
                                              )
                                            : Container(),
                                        pro.feeds[i].isDesOpen
                                            ? SizedBox(
                                                height: 10,
                                              )
                                            : Container()
                                      ],
                                    ),
                                  ),
                                )
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
}
