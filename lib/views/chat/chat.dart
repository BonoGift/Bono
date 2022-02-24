import 'package:bono_gifts/config/constants.dart';
import 'package:bono_gifts/helper/country_code_without_plus.dart';
import 'package:bono_gifts/helper/helper.dart';
import 'package:bono_gifts/models/move_list_model.dart';
import 'package:bono_gifts/provider/chat_provider.dart';
import 'package:bono_gifts/provider/sign_up_provider.dart';
import 'package:bono_gifts/services/chat_service.dart';
import 'package:bono_gifts/views/chat/chat_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';

class Chat extends StatefulWidget {
  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat>  with TickerProviderStateMixin{
  late TabController _tabController;

  getFirebaseContact(){
    FirebaseFirestore.instance.collection('users').get().then((value){
      for(var d in value.docs){
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

  void getContacts()async{
    newList.clear();
    contactList.clear();
    newDbList.clear();
    newContList.clear();
    if (await FlutterContacts.requestPermission()) {
      List<Contact> contacts = await FlutterContacts.getContacts();
      contacts = await FlutterContacts.getContacts(
          withProperties: true, withPhoto: true);
      for(var i = 0;i< contacts.length;i++){
        setState(() {
          contactList.add(contacts[i].phones[0].number.replaceAll(' ', ''));
          nameCont.add(ContModel(name: "${contacts[i].name.first} ${contacts[i].name.last}", phone: contacts[i].phones[0].number));
          // print(contactList);
        });
      }
    }
    Future.delayed(const Duration(seconds: 2),(){
      fetchNewtrork();
    });
  }



  List<NewtWorkModel> netWorkLsit = [];
  final service = ChatService();

  fetchNewtrork(){
    for (var i = 0; i < contactList.length; i++) {
      service.fetchSearch1(contactList, i, 'searchPhone1').then((value) {
        for (var d = 0; d < value.docs.length; d++) {
          print(value.docs[d]['name']);
          if(!netWorkLsit.contains(value.docs[d]['phone'])) {
          setState(() {
            netWorkLsit.add(NewtWorkModel(
                name: value.docs[d]['name'],
                phone: value.docs[d]['phone'],
                photo: value.docs[d]['profile_url'],
                isSelect: false));
          });
        }
        }
      });
      service.fetchSearch1(contactList, i, 'phone').then((value) {
        for (var d = 0; d < value.docs.length; d++) {
          print(value.docs[d]['name']);
          if(!netWorkLsit.contains(value.docs[d]['phone'])) {
          setState(() {
            netWorkLsit.add(NewtWorkModel(
                name: value.docs[d]['name'],
                phone: value.docs[d]['phone'],
                photo: value.docs[d]['profile_url'],
                isSelect: false));
          });
        }}
      });
      service.fetchSearch1(contactList, i, 'searchPhone').then((value) {
        for (var d = 0; d < value.docs.length; d++) {
          print(value.docs[d]['name']);
          if(!netWorkLsit.contains(value.docs[d]['phone'])) {
         setState(() {
           netWorkLsit.add(NewtWorkModel(
               name: value.docs[d]['name'],
               phone: value.docs[d]['phone'],
               photo: value.docs[d]['profile_url'],
               isSelect: false));
         });
        }}
      });
    }
    Future.delayed(Duration(seconds: 2),(){
      removeDuplicate();
    });
  }

  removeDuplicate(){
   setState(() {
     netWorkLsit.toSet().toList();
   });
  }
  void pro(){
    print(newContList);
    print(newDbList);
  }

  Future<void> readJson() async {
    DailCode().dailCode.forEach((element) {
      print(element['dial_code']!.replaceAll(' ', ''));
    });
  }

  List<NewtWorkModel> moveList = [];

  makeNetWorkSelect(int index){
    setState(() {
      netWorkLsit[index].isSelect = !netWorkLsit[index].isSelect;
    });
  }
  String otp = '';

  List<NetCatMo> networkCat = [
    NetCatMo(name: 'All', isSel: false),
    NetCatMo(name: 'Friends', isSel: false),
    NetCatMo(name: 'Family', isSel: false),
    NetCatMo(name: 'Work', isSel: false),
    NetCatMo(name: 'School', isSel: false),
    NetCatMo(name: 'Neigbour', isSel: false),
    NetCatMo(name: 'Others', isSel: false),
  ];

  makeCatSE(int idn){
    setState(() {
      networkCat[idn].isSel = !networkCat[idn].isSel;
    });
  }

  makeselect(int i){

    setState(() {
      for(var l in networkCat){
        l.isSel = false;
      }
      networkCat[i].isSel = true;
    });
  }
  List matchList = [];

  @override
  void initState() {
    super.initState();
    final proChat = Provider.of<ChatProvider>(context,listen: false);
    _tabController = TabController(length: 3, vsync: this);
   Future.delayed(const Duration(seconds: 2),(){
     proChat.getContacts(context,);
   });
   Future.delayed(const Duration(seconds: 4),(){
     proChat.getContactsFromFirebase(context);
    });
  }
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    final pro = Provider.of<SignUpProvider>(context);
    final proChat = Provider.of<ChatProvider>(context);
    final Stream<QuerySnapshot> documentStream = firestore.collection('recentChats').doc(pro.phone.toString()).collection('myChats').orderBy('timestamp',descending: true).snapshots();
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Column(
            children: [
              Image.asset(logo,height: 70,width: 70,),
              const SizedBox(height: 10,),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: 35,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(
                      10,
                    ),
                  ),
                  child: TabBar(
                    controller: _tabController,
                    // give the indicator a decoration (color and border radius)
                    indicator: BoxDecoration(
                      border: Border.all(color: Colors.blue),
                      borderRadius: BorderRadius.circular(
                        10.0,
                      ),
                      // color: Colors.green,
                    ),
                    labelColor: Colors.blue,
                    unselectedLabelColor: Colors.black,
                    onTap: (i) {
                      setState(() {
                        _tabController.index = i;
                      });
                      if (_tabController.index == 0) {
                      }
                      if (_tabController.index == 1) {

                      }
                      if (_tabController.index == 2) {

                      }
                    },
                    tabs: const [
                      // first tab [you can add an icon using the icon property]
                      Tab(
                        text: 'Chat',
                      ),
                      // second tab [you can add an icon using the icon property]
                      Tab(
                        text: 'Network',
                      ),
                      Tab(
                        text: 'Contacts',
                      ),
                    ],
                  ),
                ),
              ),
              _tabController.index == 0 ? Padding(
                padding: const EdgeInsets.only(top:8.0),
                child: StreamBuilder(
                  stream: documentStream,
                  builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
                    if(snapshot.data == null){
                      return Center(child: Text("No Message"),);
                    }else if(snapshot.data!.docs.length > 0){
                      return ListView(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        children: snapshot.data!.docs.map((DocumentSnapshot document) {
                          Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
                          return InkWell(
                            onTap: (){
                              print(data['recieverName']);
                              print(data['recieverID']);

                              Navigator.push(context, MaterialPageRoute(
                                  builder: (context) => ChatScreen(profileImage: data['profileImage'],recieverName: data['recieverName'],recieverPhone: data['recieverID'] == pro.phone ? data['senderID'] : data['recieverID'],)
                              ));
                            },
                            child: Container(
                              decoration: const BoxDecoration(
                                  border: Border(bottom: BorderSide(color: Colors.grey))
                              ),
                              child: Slidable(
                                key: const ValueKey(0),
                                endActionPane: ActionPane(
                                  motion: ScrollMotion(),
                                  children: [
                                    SlidableAction(
                                      flex: 2,
                                      onPressed: (c){
                                        print(data['isSeen']);
                                      },
                                      backgroundColor: Colors.grey,
                                      foregroundColor: Colors.white,
                                      icon: Icons.list,
                                      label: 'More',
                                    ),
                                    SlidableAction(
                                      onPressed: (c){},
                                      backgroundColor: Colors.blue,
                                      foregroundColor: Colors.white,
                                      icon: Icons.shopping_basket,
                                      label: 'Send',
                                    ),
                                  ],
                                ),
                                child: ListTile(
                                  // leading: HexagonWidget.flat(
                                  //   width: 20,
                                  //   height: 20,
                                  //   color: Colors.limeAccent,
                                  //   // padding: 4.0,
                                  //   child: Text("io"),
                                  // ),
                                    leading: CircleAvatar(
                                      radius: 25,
                                      backgroundImage: NetworkImage(data['profileImage']),
                                    ),
                                    subtitle: data['messageType'] == 'image' ? Row(
                                      children: const [
                                        Icon(Icons.insert_photo_rounded,color: Colors.grey,),
                                        Text("Image"),
                                      ],
                                    ):Text(data['lastMessage'].toString().length > 25 ?  "${data['lastMessage'].toString().substring(0,25)}..." : data['lastMessage']),
                                    trailing: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(data['date'],style:const TextStyle(fontSize: 12,color: Colors.grey),),
                                        const SizedBox(height: 4,),
                                        CircleAvatar(
                                          backgroundColor: Colors.white,
                                          radius: 10,
                                          child: Center(child: data['isSendMe'] == true ? data['isSeen'] == true ? Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: const [
                                              Icon(Icons.check,size: 10,),
                                              Icon(Icons.check,size: 10,),
                                            ],
                                          ): Icon(Icons.check,size: 10,): Text(data['count'],style: TextStyle(fontSize: 9),)),
                                        ),
                                      ],
                                    ),
                                    title: Text(data['recieverName'],style: TextStyle(fontWeight: FontWeight.w500),)),
                              ),
                            ),
                          );}).toList(),
                      );
                    }else{
                      return Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(height: getHeight(context) / 5,),
                            const Text("Invite your friends",style: TextStyle(fontSize: 22),),
                            SizedBox(height:20),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal:15.0),
                              child: Text("Seems your contacts don't have Bono yet Use the button below to invite your friends to Bono",textAlign: TextAlign.center,),
                            ),
                            SizedBox(height:20),
                            MaterialButton(
                              minWidth: getWidth(context),
                              color:Colors.blue,
                              onPressed: ()=> proChat.shareBono(),
                              child: Text("Inivte a friend",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w500,fontSize: 18),),
                            ),
                            // SizedBox(height: getHeight(context) / 3,),
                          ],
                        ),
                      );
                    }
                  },
                ),
              ): _tabController.index == 1 ?
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                        height: 45,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.grey)
                        ),
                        padding: const EdgeInsets.only(left:8),
                        child:  Center(
                          child: TextField(
                            onChanged: (val){
                              print('on changed ${_tabController.index}');
                              proChat.searchNetwork(val);
                              if(val.isEmpty){
                                proChat.getContactsFromFirebase(context);
                              }
                            },
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: "Search for networks",
                                suffixIcon: IconButton(onPressed: (){proChat.getContactsFromFirebase(context);}, icon: const Icon(Icons.clear))
                            ),
                          ),
                        )),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: proChat.moveListt.isEmpty ? null: (){
                          showDialog(context: context, builder: (context){
                            return StatefulBuilder(
                                builder: (context,setState) {
                                  return AlertDialog(
                                    title: const Text("Where to Move"),
                                    content: Container(
                                      height: 200,
                                      child: Column(
                                        children: [
                                          Row(
                                            children: [
                                              // InkWell(
                                              //   onTap:(){
                                              //     proChat.moveNetWorkInFirebase(context,0);
                                              //   },
                                              //   child: Padding(
                                              //     padding: const EdgeInsets.all(8.0),
                                              //     child: Container(
                                              //        child: Text(networkCat[0].name),
                                              //       padding: const EdgeInsets.all(8),
                                              //       decoration: BoxDecoration(
                                              //         borderRadius: BorderRadius.circular(3),
                                              //         color: networkCat[0].isSel ? Colors.blue: Colors.grey
                                              //       ),
                                              //     ),
                                              //   ),
                                              // ),
                                              InkWell(
                                                onTap:(){
                                                  proChat.moveNetWorkInFirebase(context,0);
                                                  Navigator.pop(context);
                                                },
                                                child: Padding(
                                                  padding: const EdgeInsets.all(8.0),
                                                  child: Container(
                                                    child: Text(networkCat[1].name),
                                                    padding: const EdgeInsets.all(8),
                                                    decoration: BoxDecoration(
                                                        borderRadius: BorderRadius.circular(3),
                                                        color: networkCat[1].isSel ? Colors.blue: Colors.grey
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              InkWell(
                                                onTap:(){
                                                  proChat.moveNetWorkInFirebase(context,1);
                                                  Navigator.pop(context);
                                                },
                                                child: Padding(
                                                  padding: const EdgeInsets.all(8.0),
                                                  child: Container(
                                                    child: Text(networkCat[2].name),
                                                    padding: const EdgeInsets.all(8),
                                                    decoration: BoxDecoration(
                                                        borderRadius: BorderRadius.circular(3),
                                                        color: networkCat[2].isSel ? Colors.blue: Colors.grey
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              InkWell(
                                                onTap:(){
                                                  proChat.moveNetWorkInFirebase(context,2);
                                                  Navigator.pop(context);
                                                },
                                                child: Padding(
                                                  padding: const EdgeInsets.all(8.0),
                                                  child: Container(
                                                    child: Text(networkCat[3].name),
                                                    padding: const EdgeInsets.all(8),
                                                    decoration: BoxDecoration(
                                                        borderRadius: BorderRadius.circular(3),
                                                        color: networkCat[3].isSel ? Colors.blue: Colors.grey
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              InkWell(
                                                onTap:(){
                                                  proChat.moveNetWorkInFirebase(context,3);
                                                  Navigator.pop(context);
                                                },
                                                child: Padding(
                                                  padding: const EdgeInsets.all(8.0),
                                                  child: Container(
                                                    child: Text(networkCat[4].name),
                                                    padding: const EdgeInsets.all(8),
                                                    decoration: BoxDecoration(
                                                        borderRadius: BorderRadius.circular(3),
                                                        color: networkCat[4].isSel ? Colors.blue: Colors.grey
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              InkWell(
                                                onTap:(){
                                                  proChat.moveNetWorkInFirebase(context,4);
                                                  Navigator.pop(context);
                                                },
                                                child: Padding(
                                                  padding: const EdgeInsets.all(8.0),
                                                  child: Container(
                                                    child: Text(networkCat[5].name),
                                                    padding: const EdgeInsets.all(8),
                                                    decoration: BoxDecoration(
                                                        borderRadius: BorderRadius.circular(3),
                                                        color: networkCat[5].isSel ? Colors.blue: Colors.grey
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              InkWell(
                                                onTap:(){
                                                  proChat.moveNetWorkInFirebase(context,5);
                                                  Navigator.pop(context);
                                                },
                                                child: Padding(
                                                  padding: const EdgeInsets.all(8.0),
                                                  child: Container(
                                                    child: Text(networkCat[6].name),
                                                    padding: const EdgeInsets.all(8),
                                                    decoration: BoxDecoration(
                                                        borderRadius: BorderRadius.circular(3),
                                                        color: networkCat[6].isSel ? Colors.blue: Colors.grey
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  );
                                }
                            );
                          });
                        },
                        child: Text("Move"),
                      ),
                      TextButton(
                        onPressed:(){},
                        child: Text(moveList.isEmpty ? "Select" :"Deselect"),
                      )
                    ],
                  ),
                  alPhabat("Friends"),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: proChat.friendsList.length,
                    itemBuilder: (contxt,i){
                      print("---------"+proChat.friendsList.toString());
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            InkWell(
                              onTap:(){
                                Navigator.push(context, MaterialPageRoute(
                                  builder: (context) => ChatScreen(
                                    recieverName: proChat.friendsList[i].name,
                                    profileImage: proChat.friendsList[i].photo,
                                    recieverPhone: proChat.friendsList[i].phone,
                                  ),
                                ),
                                );
                              },
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    backgroundImage: NetworkImage(proChat.friendsList[i].photo),
                                  ),
                                  SizedBox(width: 10,),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(proChat.friendsList[i].name,style: TextStyle(fontSize: 18),),
                                      Text(proChat.friendsList[i].phone),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Checkbox(
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2)),
                                value: proChat.friendsList[i].isSelect, onChanged: (val){
                              proChat.addinMoveList(
                                  MoveListModel(
                                    name: proChat.friendsList[i].name,
                                    photo: proChat.friendsList[i].phone,
                                    phone: proChat.friendsList[i].phone,
                                    status: 0,
                                  ),
                                  proChat.friendsList[i].isSelect);
                              proChat.checkBoxSelect(i, proChat.friendsList);
                            })
                          ],
                        ),
                      );
                    },
                  ),
                  alPhabat("Family"),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: proChat.familyList.toSet().toList().length,
                    itemBuilder: (contxt,i){
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            InkWell(
                              onTap:(){
                                Navigator.push(context, MaterialPageRoute(
                                  builder: (context) => ChatScreen(
                                    recieverName: proChat.familyList[i].name,
                                    profileImage: proChat.familyList[i].photo,
                                    recieverPhone: proChat.familyList[i].phone,
                                  ),
                                ),
                                );
                              },
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    backgroundImage: NetworkImage(proChat.familyList[i].photo),
                                  ),
                                  SizedBox(width: 10,),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(proChat.familyList[i].name,style: TextStyle(fontSize: 18),),
                                      Text(proChat.familyList[i].phone),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Checkbox(
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2)),
                                value: proChat.familyList[i].isSelect, onChanged: (val){
                              proChat.addinMoveList(
                                  MoveListModel(
                                    name: proChat.familyList[i].name,
                                    photo: proChat.familyList[i].phone,
                                    phone: proChat.familyList[i].phone,
                                    status: 1,
                                  ),
                                  proChat.familyList[i].isSelect);
                              proChat.checkBoxSelect(i, proChat.familyList);
                            })
                          ],
                        ),
                      );
                    },
                  ),
                  alPhabat("Work"),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: proChat.workList.length,
                    itemBuilder: (contxt,i){
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            InkWell(
                              onTap:(){
                                Navigator.push(context, MaterialPageRoute(
                                  builder: (context) => ChatScreen(
                                    recieverName: proChat.workList[i].name,
                                    profileImage: proChat.workList[i].photo,
                                    recieverPhone: proChat.workList[i].phone,
                                  ),
                                ),
                                );
                              },
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    backgroundImage: NetworkImage(proChat.workList[i].photo),
                                  ),
                                  SizedBox(width: 10,),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(proChat.workList[i].name,style: TextStyle(fontSize: 18),),
                                      Text(proChat.workList[i].phone),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Checkbox(
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2)),
                                value: proChat.workList[i].isSelect, onChanged: (val){
                              proChat.addinMoveList(
                                  MoveListModel(
                                    name: proChat.workList[i].name,
                                    photo: proChat.workList[i].phone,
                                    phone: proChat.workList[i].phone,
                                    status: 2,
                                  ),
                                  proChat.workList[i].isSelect);
                              proChat.checkBoxSelect(i, proChat.workList);
                            })
                          ],
                        ),
                      );
                    },
                  ),
                  alPhabat("School"),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: proChat.schoolList.length,
                    itemBuilder: (contxt,i){
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            InkWell(
                              onTap:(){
                                Navigator.push(context, MaterialPageRoute(
                                  builder: (context) => ChatScreen(
                                    recieverName: proChat.schoolList[i].name,
                                    profileImage: proChat.schoolList[i].photo,
                                    recieverPhone: proChat.schoolList[i].phone,
                                  ),
                                ),
                                );
                              },
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    backgroundImage: NetworkImage(proChat.schoolList[i].photo),
                                  ),
                                  SizedBox(width: 10,),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(proChat.schoolList[i].name,style: TextStyle(fontSize: 18),),
                                      Text(proChat.schoolList[i].phone),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Checkbox(
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2)),
                                value: proChat.schoolList[i].isSelect, onChanged: (val){
                              proChat.addinMoveList(
                                  MoveListModel(
                                    name: proChat.schoolList[i].name,
                                    photo: proChat.schoolList[i].phone,
                                    phone: proChat.schoolList[i].phone,
                                    status: 3,
                                  ),
                                  proChat.schoolList[i].isSelect);
                              proChat.checkBoxSelect(i, proChat.schoolList);
                            })
                          ],
                        ),
                      );
                    },
                  ),
                  alPhabat("Neigbhour"),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: proChat.neghiborList.length,
                    itemBuilder: (contxt,i){
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            InkWell(
                              onTap:(){
                                Navigator.push(context, MaterialPageRoute(
                                  builder: (context) => ChatScreen(
                                    recieverName: proChat.neghiborList[i].name,
                                    profileImage: proChat.neghiborList[i].photo,
                                    recieverPhone: proChat.neghiborList[i].phone,
                                  ),
                                ),
                                );
                              },
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    backgroundImage: NetworkImage(proChat.neghiborList[i].photo),
                                  ),
                                  SizedBox(width: 10,),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(proChat.neghiborList[i].name,style: TextStyle(fontSize: 18),),
                                      Text(proChat.neghiborList[i].phone),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Checkbox(
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2)),
                                value: proChat.neghiborList[i].isSelect, onChanged: (val){
                              proChat.addinMoveList(
                                  MoveListModel(
                                    name: proChat.neghiborList[i].name,
                                    photo: proChat.neghiborList[i].phone,
                                    phone: proChat.neghiborList[i].phone,
                                    status: 4,
                                  ),
                                  proChat.neghiborList[i].isSelect);
                              proChat.checkBoxSelect(i, proChat.neghiborList);
                            })
                          ],
                        ),
                      );
                    },
                  ),
                  alPhabat("Others"),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: proChat.othersList.length,
                    itemBuilder: (contxt,i){
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            InkWell(
                              onTap:(){
                                Navigator.push(context, MaterialPageRoute(
                                  builder: (context) => ChatScreen(
                                    recieverName: proChat.othersList[i].name,
                                    profileImage: proChat.othersList[i].photo,
                                    recieverPhone: proChat.othersList[i].phone,
                                  ),
                                ),
                                );
                              },
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    backgroundImage: NetworkImage(proChat.othersList[i].photo),
                                  ),
                                  SizedBox(width: 10,),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(proChat.othersList[i].name,style: TextStyle(fontSize: 18),),
                                      Text(proChat.othersList[i].phone),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Checkbox(
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2)),
                              value: proChat.othersList[i].isSelect, onChanged: (val){
                              proChat.addinMoveList(
                                  MoveListModel(
                                    name: proChat.othersList[i].name,
                                    photo: proChat.othersList[i].phone,
                                    phone: proChat.othersList[i].phone,
                                    status: 5,
                                  ),
                                  proChat.othersList[i].isSelect);
                              proChat.checkBoxSelect(i, proChat.othersList);
                            },
                            )
                          ],
                        ),
                      );
                    },
                  ),
                  // -------------------------------------------------
                ],

              )
                  :
              SingleChildScrollView(
                child: Column(
                  children: [
                    proChat.matchList.contains('a') ? alPhabat('A') :Container(),
                    getConList('a',proChat),
                    proChat.matchList.contains('b') ? alPhabat('B') :Container(),
                    getConList('b',proChat),
                    proChat.matchList.contains('c') ? alPhabat('C') :Container(),
                    getConList('c',proChat),
                    proChat.matchList.contains('d') ? alPhabat('D') :Container(),
                    getConList('d',proChat),
                    proChat.matchList.contains('e') ? alPhabat('E') :Container(),
                    getConList('e',proChat),
                    proChat.matchList.contains('f') ? alPhabat('F') :Container(),
                    getConList('f',proChat),
                    proChat.matchList.contains('g') ? alPhabat('G') :Container(),
                    getConList('g',proChat),
                    proChat.matchList.contains('h') ? alPhabat('H') :Container(),
                    getConList('h',proChat),
                    proChat.matchList.contains('i') ? alPhabat('I') :Container(),
                    getConList('i',proChat),
                    proChat.matchList.contains('j') ? alPhabat('J') :Container(),
                    getConList('j',proChat),
                    proChat.matchList.contains('k') ? alPhabat('K') :Container(),
                    getConList('k',proChat),
                    proChat.matchList.contains('l') ? alPhabat('L') :Container(),
                    getConList('l',proChat),
                    proChat.matchList.contains('m') ? alPhabat('M') :Container(),
                    getConList('m',proChat),
                    proChat.matchList.contains('n') ? alPhabat('N') :Container(),
                    getConList('n',proChat),
                    proChat.matchList.contains('o') ? alPhabat('O') :Container(),
                    getConList('o',proChat),
                    proChat.matchList.contains('p') ? alPhabat('P') :Container(),
                    getConList('p',proChat),
                    proChat.matchList.contains('q') ? alPhabat('Q') :Container(),
                    getConList('q',proChat),
                    proChat.matchList.contains('r') ? alPhabat('R') :Container(),
                    getConList('r',proChat),
                    proChat.matchList.contains('s') ? alPhabat('S') :Container(),
                    getConList('s',proChat),
                    proChat.matchList.contains('t') ? alPhabat('T') :Container(),
                    getConList('t',proChat),
                    proChat.matchList.contains('u') ? alPhabat('U') :Container(),
                    getConList('u',proChat),
                    proChat.matchList.contains('v') ? alPhabat('V') :Container(),
                    getConList('v',proChat),
                    proChat.matchList.contains('w') ? alPhabat('W') :Container(),
                    getConList('w',proChat),
                    proChat.matchList.contains('x') ? alPhabat('X') :Container(),
                    getConList('x',proChat),
                    proChat.matchList.contains('y') ? alPhabat('Y') :Container(),
                    getConList('y',proChat),
                    proChat.matchList.contains('z') ? alPhabat('Z') :Container(),
                    getConList('z',proChat),

                  ],
                ),
              )
            ],
          ),
        )
      ),
    );
  }
  Widget getConList(String alph,ChatProvider chat){
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: chat.nameCont.length,
      itemBuilder: (contxt,i){
        print(chat.nameCont[i]);

        if(chat.nameCont[i].name.startsWith(alph.toLowerCase(),0) || chat.nameCont[i].name.startsWith(alph.toUpperCase(),0)){
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const CircleAvatar(
                      backgroundImage: NetworkImage("https://firebasestorage.googleapis.com/v0/b/bonogifts.appspot.com/o/profile.png?alt=media&token=dec6afee-44f3-4876-8f2b-dbb2be0dd4d8"),
                    ),
                    const SizedBox(width: 10,),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(chat.nameCont[i].name,style: TextStyle(fontSize: 18),),
                        Text(chat.nameCont[i].phone),
                      ],
                    ),
                  ],
                ),
                InkWell(
                  onTap:() {
                    chat.shareBono();
                    print("alle= ======");
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 6),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.blue,
                    ),
                    child: Text("Invite",style: TextStyle(color: Colors.white),),
                  ),
                )
              ],
            ),
          );
        }
        else{
          return Container();
        }
      },
    );
  }
}
Widget alPhabat(String name){
  return Container(
    padding: const EdgeInsets.all(8),
    // height: 20,
    width: double.infinity,
    color: Colors.grey[200],
    child:  Center(child: Text(name,style: const TextStyle(color: Colors.grey ,fontSize: 18,fontWeight: FontWeight.w500),)),
  );
}

class ContModel{
  String name;
  String phone;

  ContModel({required this.name,required this.phone});
}

class NewtWorkModel {
  String photo;
  String name;
  String phone;
  bool isSelect;
  NewtWorkModel({required this.name,required this.phone,required this.photo,required this.isSelect});
}
class NetCatMo{
  String name;
  bool isSel;
  NetCatMo({required this.name,required this.isSel});
}