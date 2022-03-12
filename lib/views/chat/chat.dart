import 'package:bono_gifts/config/constants.dart';
import 'package:bono_gifts/helper/helper.dart';
import 'package:bono_gifts/models/move_list_model.dart';
import 'package:bono_gifts/provider/chat_provider.dart';
import 'package:bono_gifts/provider/sign_up_provider.dart';
import 'package:bono_gifts/services/chat_service.dart';
import 'package:bono_gifts/views/chat/chat_screen.dart';
import 'package:bono_gifts/widgets/ClipOvalImageWidget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';

import '../../models/network_model.dart';
import '../sendGift/sendGift.dart';

class Chat extends StatefulWidget {
  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> with TickerProviderStateMixin {
  late TabController _tabController;

  getFirebaseContact() {
    FirebaseFirestore.instance.collection('users').get().then((value) {
      for (var d in value.docs) {
        print("calling");
        phones.add(d['searchPhone']);
        print(d['searchPhone']);
      }
      getContacts();
    });
  }

  List<String> phones = [];
  List<String> contactList = [];
  List<String> newList = [];
  List<String> newDbList = [];
  List<String> newContList = [];
  List<ContModel> nameCont = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final proChat = Provider.of<ChatProvider>(context, listen: false);
    if (proChat.errorMap.isNotEmpty) {
      print('here ${proChat.errorMap}');
      proChat.errorMap.clear();
      proChat.getContactsFromFirebase(context);
    }
  }

  void getContacts() async {
    newList.clear();
    contactList.clear();
    newDbList.clear();
    newContList.clear();
    if (await FlutterContacts.requestPermission()) {
      List<Contact> contacts = await FlutterContacts.getContacts();
      contacts = await FlutterContacts.getContacts(withProperties: true, withPhoto: true);
      for (var i = 0; i < contacts.length; i++) {
        setState(() {
          contactList.add(contacts[i].phones[0].number.replaceAll(' ', ''));
          nameCont.add(
            ContModel(
              name: "${contacts[i].name.first} ${contacts[i].name.last}",
              phone: contacts[i].phones[0].number,
            ),
          );
          // print(contactList);
        });
      }
    }
    Future.delayed(const Duration(seconds: 2), () {
      fetchNewtrork();
    });
  }

  List<NewtWorkModel> netWorkLsit = [];
  final service = ChatService();

  fetchNewtrork() {
    for (var i = 0; i < contactList.length; i++) {
      service.fetchSearch1(contactList, i, 'searchPhone1').then((value) {
        for (var d = 0; d < value.docs.length; d++) {
          print(value.docs[d]['name']);
          if (!netWorkLsit.contains(value.docs[d]['phone'])) {
            setState(() {
              netWorkLsit.add(
                NewtWorkModel(
                  name: value.docs[d]['name'],
                  phone: value.docs[d]['phone'],
                  photo: value.docs[d]['profile_url'],
                  isSelect: false,
                ),
              );
            });
          }
        }
      });
      service.fetchSearch1(contactList, i, 'phone').then((value) {
        for (var d = 0; d < value.docs.length; d++) {
          print(value.docs[d]['name']);
          if (!netWorkLsit.contains(value.docs[d]['phone'])) {
            setState(() {
              netWorkLsit.add(
                NewtWorkModel(
                  name: value.docs[d]['name'],
                  phone: value.docs[d]['phone'],
                  photo: value.docs[d]['profile_url'],
                  isSelect: false,
                ),
              );
            });
          }
        }
      });
      service.fetchSearch1(contactList, i, 'searchPhone').then((value) {
        for (var d = 0; d < value.docs.length; d++) {
          print(value.docs[d]['name']);
          if (!netWorkLsit.contains(value.docs[d]['phone'])) {
            setState(() {
              netWorkLsit.add(
                NewtWorkModel(
                  name: value.docs[d]['name'],
                  phone: value.docs[d]['phone'],
                  photo: value.docs[d]['profile_url'],
                  isSelect: false,
                ),
              );
            });
          }
        }
      });
    }
    Future.delayed(const Duration(seconds: 2), () {
      removeDuplicate();
    });
  }

  removeDuplicate() {
    setState(() {
      netWorkLsit.toSet().toList();
    });
  }

  void pro() {
    print(newContList);
    print(newDbList);
  }

  Future<void> readJson() async {
    DailCode().dailCode.forEach((element) {
      print(element['dial_code']!.replaceAll(' ', ''));
    });
  }

  List<NewtWorkModel> moveList = [];

  makeNetWorkSelect(int index) {
    setState(() {
      netWorkLsit[index].isSelect = !netWorkLsit[index].isSelect;
    });
  }

  String otp = '';

  List<NetCatMo> networkCat = [
    //NetCatMo(name: 'All', isSel: false),
    NetCatMo(name: 'Friends', isSel: false),
    NetCatMo(name: 'Family', isSel: false),
    NetCatMo(name: 'Work', isSel: false),
    NetCatMo(name: 'School', isSel: false),
    NetCatMo(name: 'Neigbour', isSel: false),
    NetCatMo(name: 'Others', isSel: false),
  ];

  makeCatSE(int idn) {
    setState(() {
      networkCat[idn].isSel = !networkCat[idn].isSel;
    });
  }

  makeselect(int i) {
    setState(() {
      for (var l in networkCat) {
        l.isSel = false;
      }
      networkCat[i].isSel = true;
    });
  }

  List matchList = [];

  @override
  void initState() {
    super.initState();
    final proChat = Provider.of<ChatProvider>(context, listen: false);
    _tabController = TabController(length: 3, vsync: this);
    Future.delayed(const Duration(seconds: 2), () {
      proChat.getContacts(context);
    });
    Future.delayed(const Duration(seconds: 4), () {
      proChat.getContactsFromFirebase(context);
    });
  }

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    final pro = Provider.of<SignUpProvider>(context);
    final proChat = Provider.of<ChatProvider>(context);
    final Stream<QuerySnapshot> documentStream = firestore
        .collection('recentChats')
        .doc(pro.phone.toString())
        .collection('myChats')
        .orderBy(
          'timestamp',
          descending: true,
        )
        .snapshots();
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Column(
            children: [
              Image.asset(
                logo,
                height: 70,
                width: 70,
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: 45,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: TabBar(
                    controller: _tabController,
                    labelPadding: const EdgeInsets.symmetric(horizontal: 4,vertical: 2),
                    // give the indicator a decoration (color and border radius)
                    /*indicator: BoxDecoration(
                      border: Border.all(color: Colors.blue),
                      borderRadius: BorderRadius.circular(10.0),
                      // color: Colors.green,
                    ),*/
                    indicatorColor: Colors.transparent,
                    labelColor: Colors.blue,
                    unselectedLabelColor: Colors.black,
                    onTap: (i) {
                      setState(() {
                        _tabController.index = i;
                      });
                      if (_tabController.index == 0) {}
                      if (_tabController.index == 1) {}
                      if (_tabController.index == 2) {}
                    },
                    tabs: [
                      Container(
                        decoration: BoxDecoration(
                          color: _tabController.index == 0 ? Colors.blue : Colors.transparent,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                          child: Text(
                            'Chat',
                            style: TextStyle(
                              fontSize: 17,
                              color: _tabController.index == 0 ? Colors.white : Colors.grey,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: _tabController.index == 1 ? Colors.blue : Colors.transparent,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                          child: Text(
                            'Network',
                            style: TextStyle(
                              fontSize: 17,
                              color: _tabController.index == 1 ? Colors.white : Colors.grey,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: _tabController.index == 2 ? Colors.blue : Colors.transparent,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                          child: Text(
                            'Contacts',
                            style: TextStyle(
                              fontSize: 17,
                              color: _tabController.index == 2 ? Colors.white : Colors.grey,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 8),
              _tabController.index == 0
                  ? Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: StreamBuilder(
                        stream: documentStream,
                        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (snapshot.data == null) {
                            return const Center(
                              child: Text("No Message"),
                            );
                          } else if (snapshot.data!.docs.isNotEmpty) {
                            return ListView(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              children: snapshot.data!.docs.map((DocumentSnapshot document) {
                                Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
                                return InkWell(
                                  onTap: () {
                                    //print(data['recieverName']);
                                    //print(data['recieverID']);
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ChatScreen(
                                          profileImage: data['profileImage'],
                                          recieverName: data['recieverName'],
                                          recieverPhone: data['recieverID'] == pro.phone ? data['senderID'] : data['recieverID'],
                                        ),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    margin: const EdgeInsets.symmetric(horizontal: 12),
                                    decoration: BoxDecoration(
                                        border: Border(
                                      bottom: BorderSide(
                                        color: Colors.grey.withOpacity(0.2),
                                      ),
                                    )),
                                    child: Slidable(
                                      key: const ValueKey(0),
                                      endActionPane: ActionPane(
                                        motion: const ScrollMotion(),
                                        children: [
                                          Expanded(
                                            child: InkWell(
                                              onTap: () {},
                                              child: Container(
                                                color: Colors.grey,
                                                padding: const EdgeInsets.all(8),
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    Image.asset(
                                                      'assets/images/icons/gift.png',
                                                      width: 25,
                                                      height: 25,
                                                    ),
                                                    const SizedBox(height: 4),
                                                    const Text(
                                                      'Archive',
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 15,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: InkWell(
                                              onTap: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) => SendGiftPage(
                                                      photo: data['profileImage'],
                                                      username: data['recieverName'],
                                                      phone: data['recieverID'] == pro.phone ? data['senderID'] : data['recieverID'],
                                                    ),
                                                  ),
                                                );
                                              },
                                              child: Container(
                                                color: Colors.blue,
                                                padding: const EdgeInsets.all(8),
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    Image.asset(
                                                      'assets/images/icons/gift.png',
                                                      width: 25,
                                                      height: 25,
                                                    ),
                                                    const SizedBox(height: 4),
                                                    const Text(
                                                      'Gift',
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 15,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),

                                          /*SlidableAction(
                                            flex: 1,
                                            onPressed: (c) {
                                              print(data['isSeen']);
                                            },
                                            backgroundColor: Colors.grey,
                                            foregroundColor: Colors.white,
                                            icon: Icons.list,
                                            label: 'Archive',
                                          ),*/
                                          /*SlidableAction(
                                            onPressed: (c) {},
                                            backgroundColor: Colors.blue,
                                            foregroundColor: Colors.white,
                                            icon: Icons.shopping_basket,
                                            label: 'Gift',
                                          ),*/
                                        ],
                                      ),
                                      child: ListTile(
                                        contentPadding: const EdgeInsets.all(0),
                                        leading: ClipOvalImageWidget(
                                          imageUrl: data['profileImage'],
                                          imageHeight: 50,
                                          imageWidth: 50,
                                        ),
                                        subtitle: data['messageType'] == 'image'
                                            ? Row(
                                                children: const [
                                                  Icon(
                                                    Icons.insert_photo_rounded,
                                                    color: Colors.grey,
                                                  ),
                                                  Text("Image"),
                                                ],
                                              )
                                            : Text(data['lastMessage'].toString().length > 25 ? "${data['lastMessage'].toString().substring(0, 25)}..." : data['lastMessage']),
                                        trailing: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              data['date'],
                                              style: const TextStyle(fontSize: 12, color: Colors.grey),
                                            ),
                                            const SizedBox(height: 4),
                                            CircleAvatar(
                                              backgroundColor: Colors.white,
                                              radius: 10,
                                              child: Center(
                                                child: data['isSendMe'] == true
                                                    ? data['isSeen'] == true
                                                        ? Row(
                                                            mainAxisAlignment: MainAxisAlignment.center,
                                                            children: const [
                                                              Icon(Icons.check, size: 10),
                                                              Icon(Icons.check, size: 10),
                                                            ],
                                                          )
                                                        : const Icon(Icons.check, size: 10)
                                                    : Text(
                                                        data['count'],
                                                        style: const TextStyle(fontSize: 9),
                                                      ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        title: Text(
                                          data['recieverName'],
                                          style: const TextStyle(fontWeight: FontWeight.w500),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              }).toList(),
                            );
                          } else {
                            return Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(height: getHeight(context) / 5),
                                  const Text(
                                    "Invite your friends",
                                    style: TextStyle(fontSize: 22),
                                  ),
                                  const SizedBox(height: 20),
                                  const Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 15.0),
                                    child: Text(
                                      "Seems your contacts don't have Bono yet Use the button below to invite your friends to Bono",
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  MaterialButton(
                                    minWidth: getWidth(context),
                                    color: Colors.blue,
                                    onPressed: () => proChat.shareBono(),
                                    child: const Text(
                                      "Invite a friend",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 18,
                                      ),
                                    ),
                                  ),
                                  // SizedBox(height: getHeight(context) / 3,),
                                ],
                              ),
                            );
                          }
                        },
                      ),
                    )
                  : _tabController.index == 1
                      ? Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
                              child: Container(
                                height: 40,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: Colors.grey.withOpacity(0.6),
                                  ),
                                ),
                                child: TextField(
                                  onChanged: (val) {
                                    print('on changed ${_tabController.index}');
                                    proChat.searchNetwork(val);
                                    if (val.isEmpty) {
                                      proChat.getContactsFromFirebase(context);
                                    }
                                  },
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: "Search",
                                    hintStyle: TextStyle(
                                      color: Colors.grey.withOpacity(0.6),
                                    ),
                                    prefixIcon: const Icon(
                                      Icons.search,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            Visibility(
                              visible: proChat.friendsList.isNotEmpty,
                              child: alPhabat("Friends", fontSize: 14),
                            ),
                            ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: proChat.friendsList.length,
                              itemBuilder: (contxt, i) {
                                //print("---------" + proChat.friendsList.toString());
                                return _getContactsByCategoryWidget(context, proChat.friendsList, proChat, i, 0);
                              },
                            ),
                            Visibility(
                              visible: proChat.familyList.isNotEmpty,
                              child: alPhabat("Family", fontSize: 14),
                            ),
                            ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: proChat.familyList.toSet().toList().length,
                              itemBuilder: (contxt, i) {
                                return _getContactsByCategoryWidget(context, proChat.familyList, proChat, i, 1);
                              },
                            ),
                            Visibility(
                              visible: proChat.workList.isNotEmpty,
                              child: alPhabat("Work", fontSize: 14),
                            ),
                            ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: proChat.workList.length,
                              itemBuilder: (contxt, i) {
                                return _getContactsByCategoryWidget(context, proChat.workList, proChat, i, 2);
                              },
                            ),
                            Visibility(
                              visible: proChat.schoolList.isNotEmpty,
                              child: alPhabat("School", fontSize: 14),
                            ),
                            ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: proChat.schoolList.length,
                              itemBuilder: (contxt, i) {
                                return _getContactsByCategoryWidget(context, proChat.schoolList, proChat, i, 3);
                              },
                            ),
                            Visibility(
                              visible: proChat.neighborList.isNotEmpty,
                              child: alPhabat("Neigbhour", fontSize: 14),
                            ),
                            ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: proChat.neighborList.length,
                              itemBuilder: (contxt, i) {
                                return _getContactsByCategoryWidget(context, proChat.neighborList, proChat, i, 4);
                              },
                            ),
                            Visibility(
                              visible: proChat.othersList.isNotEmpty,
                              child: alPhabat("Others", fontSize: 14),
                            ),
                            ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: proChat.othersList.length,
                              itemBuilder: (contxt, i) {
                                return _getContactsByCategoryWidget(context, proChat.othersList, proChat, i, 5);
                              },
                            ),
                            // -------------------------------------------------
                          ],
                        )
                      : SingleChildScrollView(
                          child: Column(
                            children: [
                              proChat.matchList.contains('a') ? alPhabat('A') : Container(),
                              getConList('a', proChat),
                              proChat.matchList.contains('b') ? alPhabat('B') : Container(),
                              getConList('b', proChat),
                              proChat.matchList.contains('c') ? alPhabat('C') : Container(),
                              getConList('c', proChat),
                              proChat.matchList.contains('d') ? alPhabat('D') : Container(),
                              getConList('d', proChat),
                              proChat.matchList.contains('e') ? alPhabat('E') : Container(),
                              getConList('e', proChat),
                              proChat.matchList.contains('f') ? alPhabat('F') : Container(),
                              getConList('f', proChat),
                              proChat.matchList.contains('g') ? alPhabat('G') : Container(),
                              getConList('g', proChat),
                              proChat.matchList.contains('h') ? alPhabat('H') : Container(),
                              getConList('h', proChat),
                              proChat.matchList.contains('i') ? alPhabat('I') : Container(),
                              getConList('i', proChat),
                              proChat.matchList.contains('j') ? alPhabat('J') : Container(),
                              getConList('j', proChat),
                              proChat.matchList.contains('k') ? alPhabat('K') : Container(),
                              getConList('k', proChat),
                              proChat.matchList.contains('l') ? alPhabat('L') : Container(),
                              getConList('l', proChat),
                              proChat.matchList.contains('m') ? alPhabat('M') : Container(),
                              getConList('m', proChat),
                              proChat.matchList.contains('n') ? alPhabat('N') : Container(),
                              getConList('n', proChat),
                              proChat.matchList.contains('o') ? alPhabat('O') : Container(),
                              getConList('o', proChat),
                              proChat.matchList.contains('p') ? alPhabat('P') : Container(),
                              getConList('p', proChat),
                              proChat.matchList.contains('q') ? alPhabat('Q') : Container(),
                              getConList('q', proChat),
                              proChat.matchList.contains('r') ? alPhabat('R') : Container(),
                              getConList('r', proChat),
                              proChat.matchList.contains('s') ? alPhabat('S') : Container(),
                              getConList('s', proChat),
                              proChat.matchList.contains('t') ? alPhabat('T') : Container(),
                              getConList('t', proChat),
                              proChat.matchList.contains('u') ? alPhabat('U') : Container(),
                              getConList('u', proChat),
                              proChat.matchList.contains('v') ? alPhabat('V') : Container(),
                              getConList('v', proChat),
                              proChat.matchList.contains('w') ? alPhabat('W') : Container(),
                              getConList('w', proChat),
                              proChat.matchList.contains('x') ? alPhabat('X') : Container(),
                              getConList('x', proChat),
                              proChat.matchList.contains('y') ? alPhabat('Y') : Container(),
                              getConList('y', proChat),
                              proChat.matchList.contains('z') ? alPhabat('Z') : Container(),
                              getConList('z', proChat),
                            ],
                          ),
                        )
            ],
          ),
        ),
      ),
    );
  }

  Widget _getContactsByCategoryWidget(
    BuildContext context,
    List<NetWorkModel> categoryList,
    ChatProvider proChat,
    int i,
    int status,
  ) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChatScreen(
                    recieverName: categoryList[i].name,
                    profileImage: categoryList[i].photo,
                    recieverPhone: categoryList[i].phone,
                  ),
                ),
              );
            },
            child: Row(
              children: [
                ClipOvalImageWidget(imageUrl: categoryList[i].photo),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      categoryList[i].name,
                      style: const TextStyle(fontSize: 18),
                    ),
                    Text(categoryList[i].phone),
                  ],
                ),
              ],
            ),
          ),
          const Expanded(child: SizedBox.shrink()),
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SendGiftPage(
                    photo: categoryList[i].photo,
                    username: categoryList[i].name,
                    phone: categoryList[i].phone,
                  ),
                ),
              );
            },
            child: Image.asset(
              'assets/images/icons/chat_gift_icon.png',
              width: 24,
              height: 24,
            ),
          ),
          const SizedBox(width: 12),
          InkWell(
            onTap: () {
              proChat.addinMoveList(
                  MoveListModel(
                    name: categoryList[i].name,
                    photo: categoryList[i].photo,
                    phone: categoryList[i].phone,
                    status: 1,
                  ),
                  categoryList[i].isSelect);
              // proChat.checkBoxSelect(i, categoryList);
              _showDialog(context, proChat, status);
            },
            child: Image.asset(
              'assets/images/icons/chat_category_move_icon.png',
              width: 24,
              height: 24,
            ),
          ),
          const SizedBox(width: 12),
        ],
      ),
    );
  }

  Future<dynamic> _showDialog(BuildContext context, ChatProvider proChat, int status) {
    return showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            backgroundColor: Colors.transparent,
            insetPadding: const EdgeInsets.symmetric(horizontal: 16),
            child: Container(
              padding: EdgeInsets.only(left: 24),
              height: 150,
              width: double.infinity,
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  const Text(
                    'Save As',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    alignment: WrapAlignment.start,
                    crossAxisAlignment: WrapCrossAlignment.start,
                    spacing: 12,
                    runSpacing: 16,
                    children: networkCat.map((element) {
                      int index = networkCat.indexOf(element);
                      return InkWell(
                        onTap: () {
                          proChat.moveNetWorkInFirebase(context, index);
                          Navigator.pop(context);
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            color: index == status ? const Color(0xFF0000F9) : Colors.grey.withOpacity(0.3),
                          ),
                          child: Text(
                            element.name,
                            style: TextStyle(
                              color: index == status ? Colors.white : Colors.black,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          );
        });
  }

  Widget getConList(String alph, ChatProvider chat) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: chat.nameCont.length,
      itemBuilder: (contxt, i) {
        print(chat.nameCont[i]);

        if (chat.nameCont[i].name.startsWith(alph.toLowerCase(), 0) || chat.nameCont[i].name.startsWith(alph.toUpperCase(), 0)) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const ClipOvalImageWidget(imageUrl: 'https://firebasestorage.googleapis.com/v0/b/bonogifts.appspot.com/o/profile.png?alt=media&token=dec6afee-44f3-4876-8f2b-dbb2be0dd4d8'),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          chat.nameCont[i].name,
                          style: const TextStyle(fontSize: 18),
                        ),
                        Text(chat.nameCont[i].phone),
                      ],
                    ),
                  ],
                ),
                InkWell(
                  onTap: () {
                    chat.shareBono();
                    print("alle= ======");
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.blue,
                    ),
                    child: const Text(
                      "Invite",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                )
              ],
            ),
          );
        } else {
          return Container();
        }
      },
    );
  }
}

Widget alPhabat(String name, {double? fontSize}) {
  return Container(
    padding: const EdgeInsets.all(8),
    // height: 20,
    width: double.infinity,
    color: Colors.grey[200],
    child: Center(
        child: Text(
      name,
      style: TextStyle(
        color: Colors.grey,
        fontSize: fontSize ?? 18,
        fontWeight: FontWeight.w500,
      ),
    )),
  );
}

class ContModel {
  String name;
  String phone;

  ContModel({required this.name, required this.phone});
}

class NewtWorkModel {
  String photo;
  String name;
  String phone;
  bool isSelect;

  NewtWorkModel({
    required this.name,
    required this.phone,
    required this.photo,
    required this.isSelect,
  });
}

class NetCatMo {
  String name;
  bool isSel;

  NetCatMo({required this.name, required this.isSel});
}
