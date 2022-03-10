import 'package:bono_gifts/provider/buy_provider.dart';
import 'package:bono_gifts/provider/chat_provider.dart';
import 'package:bono_gifts/provider/sign_up_provider.dart';
import 'package:bono_gifts/provider/wcmp_provider.dart';
import 'package:bono_gifts/views/chat/chat.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SelectNetwork extends StatefulWidget {
  const SelectNetwork({Key? key}) : super(key: key);

  @override
  _SelectNetworkState createState() => _SelectNetworkState();
}

class _SelectNetworkState extends State<SelectNetwork> {
  @override
  Widget build(BuildContext context) {
    final proChat = Provider.of<ChatProvider>(context);
    final pro = Provider.of<BuyProvider>(context);
    final SignUpProvider signUpProvider = Provider.of<SignUpProvider>(context);
    final wcmp = Provider.of<WooCommerceMarketPlaceProvider>(context);
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              alPhabat("Friends"),
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: proChat.friendsList.length,
                itemBuilder: (contxt, i) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          onTap: () async {
                            pro.assignVals(
                              wcmp,
                              proChat.friendsList[i].name,
                              proChat.friendsList[i].photo,
                              proChat.friendsList[i].phone,
                            );
                            Map<String, dynamic> user = await wcmp
                                .getUserInfo(proChat.friendsList[i].phone);
                            wcmp.fetchVendors(user['city'] ?? 'unknown');
                            Navigator.pop(context);
                          },
                          child: Row(
                            children: [
                              CircleAvatar(
                                backgroundImage:
                                    NetworkImage(proChat.friendsList[i].photo),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    proChat.friendsList[i].name,
                                    style: TextStyle(fontSize: 18),
                                  ),
                                  Text(proChat.friendsList[i].phone),
                                ],
                              ),
                            ],
                          ),
                        ),
                        // Checkbox(
                        //     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2)),
                        //     value: proChat.friendsList[i].isSelect, onChanged: (val){
                        //   proChat.addinMoveList(
                        //       MoveListModel(
                        //         name: proChat.friendsList[i].name,
                        //         photo: proChat.friendsList[i].phone,
                        //         phone: proChat.friendsList[i].phone,
                        //         status: 0,
                        //       ),
                        //       proChat.friendsList[i].isSelect);
                        //   proChat.checkBoxSelect(i, proChat.friendsList);
                        // })
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
                itemBuilder: (contxt, i) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          onTap: () async {
                            pro.assignVals(
                              wcmp,
                              proChat.familyList[i].name,
                              proChat.familyList[i].photo,
                              proChat.familyList[i].phone,
                            );
                            Map<String, dynamic> user = await wcmp
                                .getUserInfo(proChat.familyList[i].phone);
                            print(user.toString());
                            wcmp.fetchVendors(user['city'] ?? 'unknown');

                            Navigator.pop(context);
                          },
                          child: Row(
                            children: [
                              CircleAvatar(
                                backgroundImage:
                                    NetworkImage(proChat.familyList[i].photo),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    proChat.familyList[i].name,
                                    style: TextStyle(fontSize: 18),
                                  ),
                                  Text(proChat.familyList[i].phone),
                                ],
                              ),
                            ],
                          ),
                        ),
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
                itemBuilder: (contxt, i) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          onTap: () async {
                            pro.assignVals(
                              wcmp,
                              proChat.workList[i].name,
                              proChat.workList[i].photo,
                              proChat.workList[i].phone,
                            );
                            Map<String, dynamic> user = await wcmp
                                .getUserInfo(proChat.workList[i].phone);
                            wcmp.fetchVendors(user['city'] ?? 'unknown');

                            Navigator.pop(context);
                          },
                          child: Row(
                            children: [
                              CircleAvatar(
                                backgroundImage:
                                    NetworkImage(proChat.workList[i].photo),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    proChat.workList[i].name,
                                    style: TextStyle(fontSize: 18),
                                  ),
                                  Text(proChat.workList[i].phone),
                                ],
                              ),
                            ],
                          ),
                        ),
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
                itemBuilder: (contxt, i) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          onTap: () async {
                            pro.assignVals(
                              wcmp,
                              proChat.schoolList[i].name,
                              proChat.schoolList[i].photo,
                              proChat.schoolList[i].phone,
                            );
                            Map<String, dynamic> user = await wcmp
                                .getUserInfo(proChat.schoolList[i].phone);
                            wcmp.fetchVendors(user['city'] ?? 'unknown');

                            Navigator.pop(context);
                          },
                          child: Row(
                            children: [
                              CircleAvatar(
                                backgroundImage:
                                    NetworkImage(proChat.schoolList[i].photo),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    proChat.schoolList[i].name,
                                    style: TextStyle(fontSize: 18),
                                  ),
                                  Text(proChat.schoolList[i].phone),
                                ],
                              ),
                            ],
                          ),
                        ),
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
                itemBuilder: (contxt, i) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          onTap: () async {
                            pro.assignVals(
                              wcmp,
                              proChat.neghiborList[i].name,
                              proChat.neghiborList[i].photo,
                              proChat.neghiborList[i].phone,
                            );
                            Map<String, dynamic> user = await wcmp
                                .getUserInfo(proChat.neghiborList[i].phone);
                            wcmp.fetchVendors(user['city'] ?? 'unknown');

                            Navigator.pop(context);
                          },
                          child: Row(
                            children: [
                              CircleAvatar(
                                backgroundImage:
                                    NetworkImage(proChat.neghiborList[i].photo),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    proChat.neghiborList[i].name,
                                    style: TextStyle(fontSize: 18),
                                  ),
                                  Text(proChat.neghiborList[i].phone),
                                ],
                              ),
                            ],
                          ),
                        ),
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
                itemBuilder: (contxt, i) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          onTap: () async {
                            pro.assignVals(
                              wcmp,
                              proChat.othersList[i].name,
                              proChat.othersList[i].photo,
                              proChat.othersList[i].phone,
                            );
                            Map<String, dynamic> user = await wcmp
                                .getUserInfo(proChat.othersList[i].phone);
                            wcmp.fetchVendors(user['city'] ?? 'unknown');

                            Navigator.pop(context);
                          },
                          child: Row(
                            children: [
                              CircleAvatar(
                                backgroundImage:
                                    NetworkImage(proChat.othersList[i].photo),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    proChat.othersList[i].name,
                                    style: TextStyle(fontSize: 18),
                                  ),
                                  Text(proChat.othersList[i].phone),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
