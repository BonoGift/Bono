import 'package:bono_gifts/config/constants.dart';
import 'package:bono_gifts/models/wcmp_api/vendor_product.dart';
import 'package:bono_gifts/provider/buy_provider.dart';
import 'package:bono_gifts/provider/wcmp_provider.dart';
import 'package:bono_gifts/views/buy/order_summry.dart';
import 'package:bono_gifts/views/buy/select_network.dart';
import 'package:bono_gifts/views/gift/controller/history_controller.dart';
import 'package:bono_gifts/views/gift/widgets/loading_gifts_widget.dart';
import 'package:bono_gifts/views/gift/widgets/primary_text.dart';
import 'package:bono_gifts/widgets/ClipOvalImageWidget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import '../../provider/chat_provider.dart';
import '../chat/chat.dart';
import '../gift/widgets/history_list.dart';

class SendGiftPage extends StatefulWidget {
  final String username;
  final String phone;
  final String photo;

  const SendGiftPage({
    Key? key,
    required this.username,
    required this.phone,
    required this.photo,
  }) : super(key: key);

  @override
  _SendGiftPageState createState() => _SendGiftPageState();
}

class _SendGiftPageState extends State<SendGiftPage> {
  bool isSendGiftTabSelected = true;
  bool isHistoryTabSelected = false;

  @override
  void initState() {
    super.initState();
    Provider.of<HistoryProvider>(context, listen: false).getHistoryFromFirebase();
    _getData();
  }

  void _getData() async {
    final pro = Provider.of<BuyProvider>(context, listen: false);
    final wcmp = Provider.of<WooCommerceMarketPlaceProvider>(context, listen: false);
    pro.assignVals(wcmp, widget.username, widget.photo, widget.phone);
    Map<String, dynamic> user = await wcmp.getUserInfo(widget.phone);
    wcmp.fetchVendors(user['city'] ?? 'unknown');
  }

  @override
  Widget build(BuildContext context) {
    var form = DateFormat('dd-MMM');
    final pro = Provider.of<BuyProvider>(context);
    final proChat = Provider.of<ChatProvider>(context);
    final wcmp = Provider.of<WooCommerceMarketPlaceProvider>(context);
    final HistoryProvider historyProvider = Provider.of<HistoryProvider>(context);

    int index = 1000000;

    return DefaultTabController(
      length: 3,
      initialIndex: 0,
      child: SafeArea(
        child: Scaffold(
          appBar: _getAppBarWidget(context),
          body: isSendGiftTabSelected
              ? SingleChildScrollView(
                  child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),
                    pro.userName != null
                        ? Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Container(
                              padding: const EdgeInsets.only(top: 10, bottom: 10, left: 15, right: 15),
                              decoration: BoxDecoration(border: Border.all(), borderRadius: BorderRadius.circular(10)),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  PrimaryText(text: "To"),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: Colors.black26,
                                          width: 4,
                                        ),
                                      ),
                                      child: ClipOvalImageWidget(
                                        imageUrl: pro.userImage!,
                                        imageHeight: 50,
                                        imageWidth: 50,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        FittedBox(
                                          child: Text(
                                            pro.userName!,
                                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        FittedBox(
                                          child: Text(
                                            "Birthday ${pro.userDob != null ? form.format(pro.userDob!).toString() : ''} (In ${pro.diffDays} Days)",
                                            maxLines: 1,
                                            style: const TextStyle(color: Colors.blue),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      if (wcmp.apiState == ApiState.completed || wcmp.apiState == ApiState.error) {
                                        wcmp.apiState = ApiState.none;
                                        wcmp.clearShops();
                                        pro.clearAll();
                                      }
                                    },
                                    icon: const Icon(
                                      Icons.clear,
                                      size: 30,
                                      color: Colors.black,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          )
                        : Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const SelectNetwork(),
                                  ),
                                );
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.black.withOpacity(0.5)),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.only(
                                        top: 25,
                                        bottom: 25,
                                        left: 15,
                                        right: 15,
                                      ),
                                      child: const Center(
                                        child: Text(
                                          "To",
                                          style: TextStyle(fontSize: 21, color: Colors.blue),
                                        ),
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        const Text(
                                          "Select Someone",
                                          style: TextStyle(fontSize: 20),
                                        ),
                                        const SizedBox(width: 10),
                                        RotatedBox(
                                          quarterTurns: 4,
                                          child: Image.asset(
                                            addBtn,
                                            height: 30,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Container(),
                                  ],
                                ),
                              ),
                            ),
                          ),
                    const SizedBox(height: 20),
                    pro.userName == null
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Visibility(
                                visible: proChat.friendsList.isNotEmpty,
                                child: alPhabat("Friends", fontSize: 14),
                              ),
                              Visibility(
                                visible: proChat.friendsList.isNotEmpty,
                                child: SizedBox(
                                  height: getHeight(context) * 0.12,
                                  child: ListView.builder(
                                    shrinkWrap: true,
                                    scrollDirection: Axis.horizontal,
                                    itemCount: proChat.friendsList.length,
                                    padding: const EdgeInsets.only(left: 16),
                                    itemBuilder: (contxt, i) {
                                      return Container(
                                        margin: const EdgeInsets.only(right: 8),
                                        width: 60,
                                        child: InkWell(
                                          onTap: () async {
                                            pro.assignVals(
                                              wcmp,
                                              proChat.friendsList[i].name,
                                              proChat.friendsList[i].photo,
                                              proChat.friendsList[i].phone,
                                            );
                                            Map<String, dynamic> user = await wcmp.getUserInfo(proChat.friendsList[i].phone);
                                            wcmp.fetchVendors(user['city'] ?? 'unknown');
                                          },
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              ClipOval(
                                                child: CachedNetworkImage(
                                                  imageUrl: proChat.friendsList[i].photo,
                                                  width: 40,
                                                  height: 40,
                                                  fit: BoxFit.cover,
                                                  progressIndicatorBuilder: (context, url, progress) => SizedBox(
                                                    width: 40,
                                                    height: 40,
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
                                                  errorWidget: (BuildContext context, String url, dynamic error) {
                                                    return ClipOval(
                                                      child: Image.asset(
                                                        'assets/images/profile.png',
                                                        width: 40,
                                                        height: 40,
                                                      ),
                                                    );
                                                  },
                                                ),
                                              ),
                                              const SizedBox(height: 2),
                                              Text(
                                                proChat.friendsList[i].name,
                                                overflow: TextOverflow.ellipsis,
                                                style: const TextStyle(fontSize: 13),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                              Visibility(
                                visible: proChat.familyList.isNotEmpty,
                                child: alPhabat("Family", fontSize: 14),
                              ),
                              Visibility(
                                visible: proChat.familyList.isNotEmpty,
                                child: SizedBox(
                                  height: getHeight(context) * 0.12,
                                  child: ListView.builder(
                                    shrinkWrap: true,
                                    scrollDirection: Axis.horizontal,
                                    itemCount: proChat.familyList.length,
                                    padding: const EdgeInsets.only(left: 16),
                                    itemBuilder: (contxt, i) {
                                      return Container(
                                        margin: const EdgeInsets.only(right: 8),
                                        width: 60,
                                        child: InkWell(
                                          onTap: () async {
                                            pro.assignVals(
                                              wcmp,
                                              proChat.familyList[i].name,
                                              proChat.familyList[i].photo,
                                              proChat.familyList[i].phone,
                                            );
                                            Map<String, dynamic> user = await wcmp.getUserInfo(proChat.friendsList[i].phone);
                                            wcmp.fetchVendors(user['city'] ?? 'unknown');
                                          },
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              ClipOval(
                                                child: CachedNetworkImage(
                                                  imageUrl: proChat.familyList[i].photo,
                                                  width: 40,
                                                  height: 40,
                                                  fit: BoxFit.cover,
                                                  progressIndicatorBuilder: (context, url, progress) => SizedBox(
                                                    width: 40,
                                                    height: 40,
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
                                                  errorWidget: (BuildContext context, String url, dynamic error) {
                                                    return ClipOval(
                                                      child: Image.asset(
                                                        'assets/images/profile.png',
                                                        width: 40,
                                                        height: 40,
                                                      ),
                                                    );
                                                  },
                                                ),
                                              ),
                                              const SizedBox(height: 2),
                                              Text(
                                                proChat.familyList[i].name,
                                                overflow: TextOverflow.ellipsis,
                                                style: const TextStyle(fontSize: 13),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                              Visibility(
                                visible: proChat.workList.isNotEmpty,
                                child: alPhabat("Work", fontSize: 14),
                              ),
                              Visibility(
                                visible: proChat.workList.isNotEmpty,
                                child: SizedBox(
                                  height: getHeight(context) * 0.12,
                                  child: ListView.builder(
                                    shrinkWrap: true,
                                    scrollDirection: Axis.horizontal,
                                    itemCount: proChat.workList.length,
                                    padding: const EdgeInsets.only(left: 16),
                                    itemBuilder: (contxt, i) {
                                      return Container(
                                        margin: const EdgeInsets.only(right: 8),
                                        width: 60,
                                        child: InkWell(
                                          onTap: () async {
                                            pro.assignVals(
                                              wcmp,
                                              proChat.workList[i].name,
                                              proChat.workList[i].photo,
                                              proChat.workList[i].phone,
                                            );
                                            Map<String, dynamic> user = await wcmp.getUserInfo(proChat.workList[i].phone);
                                            wcmp.fetchVendors(user['city'] ?? 'unknown');
                                          },
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              ClipOval(
                                                child: CachedNetworkImage(
                                                  imageUrl: proChat.workList[i].photo,
                                                  width: 40,
                                                  height: 40,
                                                  fit: BoxFit.cover,
                                                  progressIndicatorBuilder: (context, url, progress) => SizedBox(
                                                    width: 40,
                                                    height: 40,
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
                                                  errorWidget: (BuildContext context, String url, dynamic error) {
                                                    return ClipOval(
                                                      child: Image.asset(
                                                        'assets/images/profile.png',
                                                        width: 40,
                                                        height: 40,
                                                      ),
                                                    );
                                                  },
                                                ),
                                              ),
                                              const SizedBox(height: 2),
                                              Text(
                                                proChat.workList[i].name,
                                                overflow: TextOverflow.ellipsis,
                                                style: const TextStyle(fontSize: 13),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                              Visibility(
                                visible: proChat.schoolList.isNotEmpty,
                                child: alPhabat("School", fontSize: 14),
                              ),
                              Visibility(
                                visible: proChat.schoolList.isNotEmpty,
                                child: SizedBox(
                                  height: getHeight(context) * 0.12,
                                  child: ListView.builder(
                                    shrinkWrap: true,
                                    scrollDirection: Axis.horizontal,
                                    itemCount: proChat.schoolList.length,
                                    padding: const EdgeInsets.only(left: 16),
                                    itemBuilder: (contxt, i) {
                                      return Container(
                                        margin: const EdgeInsets.only(right: 8),
                                        width: 60,
                                        child: InkWell(
                                          onTap: () async {
                                            pro.assignVals(
                                              wcmp,
                                              proChat.schoolList[i].name,
                                              proChat.schoolList[i].photo,
                                              proChat.schoolList[i].phone,
                                            );
                                            Map<String, dynamic> user = await wcmp.getUserInfo(proChat.schoolList[i].phone);
                                            wcmp.fetchVendors(user['city'] ?? 'unknown');
                                          },
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              ClipOval(
                                                child: CachedNetworkImage(
                                                  imageUrl: proChat.schoolList[i].photo,
                                                  width: 40,
                                                  height: 40,
                                                  fit: BoxFit.cover,
                                                  progressIndicatorBuilder: (context, url, progress) => SizedBox(
                                                    width: 40,
                                                    height: 40,
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
                                                  errorWidget: (BuildContext context, String url, dynamic error) {
                                                    return ClipOval(
                                                      child: Image.asset(
                                                        'assets/images/profile.png',
                                                        width: 40,
                                                        height: 40,
                                                      ),
                                                    );
                                                  },
                                                ),
                                              ),
                                              const SizedBox(height: 2),
                                              Text(
                                                proChat.schoolList[i].name,
                                                overflow: TextOverflow.ellipsis,
                                                style: const TextStyle(fontSize: 13),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                              Visibility(
                                visible: proChat.neighborList.isNotEmpty,
                                child: alPhabat("Neigbhour", fontSize: 14),
                              ),
                              Visibility(
                                visible: proChat.neighborList.isNotEmpty,
                                child: SizedBox(
                                  height: getHeight(context) * 0.12,
                                  child: ListView.builder(
                                    shrinkWrap: true,
                                    scrollDirection: Axis.horizontal,
                                    itemCount: proChat.neighborList.length,
                                    padding: const EdgeInsets.only(left: 16),
                                    itemBuilder: (contxt, i) {
                                      return Container(
                                        margin: const EdgeInsets.only(right: 8),
                                        width: 60,
                                        child: InkWell(
                                          onTap: () async {
                                            pro.assignVals(
                                              wcmp,
                                              proChat.neighborList[i].name,
                                              proChat.neighborList[i].photo,
                                              proChat.neighborList[i].phone,
                                            );
                                            Map<String, dynamic> user = await wcmp.getUserInfo(proChat.neighborList[i].phone);
                                            wcmp.fetchVendors(user['city'] ?? 'unknown');
                                          },
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              ClipOval(
                                                child: CachedNetworkImage(
                                                  imageUrl: proChat.neighborList[i].photo,
                                                  width: 40,
                                                  height: 40,
                                                  fit: BoxFit.cover,
                                                  progressIndicatorBuilder: (context, url, progress) => SizedBox(
                                                    width: 40,
                                                    height: 40,
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
                                                  errorWidget: (BuildContext context, String url, dynamic error) {
                                                    return ClipOval(
                                                      child: Image.asset(
                                                        'assets/images/profile.png',
                                                        width: 40,
                                                        height: 40,
                                                      ),
                                                    );
                                                  },
                                                ),
                                              ),
                                              const SizedBox(height: 2),
                                              Text(
                                                proChat.neighborList[i].name,
                                                overflow: TextOverflow.ellipsis,
                                                style: const TextStyle(fontSize: 13),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                              Visibility(
                                visible: proChat.othersList.isNotEmpty,
                                child: alPhabat("Others", fontSize: 14),
                              ),
                              Visibility(
                                visible: proChat.othersList.isNotEmpty,
                                child: SizedBox(
                                  height: getHeight(context) * 0.12,
                                  child: ListView.builder(
                                    shrinkWrap: true,
                                    scrollDirection: Axis.horizontal,
                                    itemCount: proChat.othersList.length,
                                    padding: const EdgeInsets.only(left: 16),
                                    itemBuilder: (contxt, i) {
                                      return Container(
                                        margin: const EdgeInsets.only(right: 8),
                                        width: 60,
                                        child: InkWell(
                                          onTap: () async {
                                            pro.assignVals(
                                              wcmp,
                                              proChat.othersList[i].name,
                                              proChat.othersList[i].photo,
                                              proChat.othersList[i].phone,
                                            );
                                            Map<String, dynamic> user = await wcmp.getUserInfo(proChat.othersList[i].phone);
                                            wcmp.fetchVendors(user['city'] ?? 'unknown');
                                          },
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              ClipOval(
                                                child: CachedNetworkImage(
                                                  imageUrl: proChat.othersList[i].photo,
                                                  width: 40,
                                                  height: 40,
                                                  fit: BoxFit.cover,
                                                  progressIndicatorBuilder: (context, url, progress) => SizedBox(
                                                    width: 40,
                                                    height: 40,
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
                                                  errorWidget: (BuildContext context, String url, dynamic error) {
                                                    return ClipOval(
                                                      child: Image.asset(
                                                        'assets/images/profile.png',
                                                        width: 40,
                                                        height: 40,
                                                      ),
                                                    );
                                                  },
                                                ),
                                              ),
                                              const SizedBox(height: 2),
                                              Text(
                                                proChat.othersList[i].name,
                                                overflow: TextOverflow.ellipsis,
                                                style: const TextStyle(fontSize: 13),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ],
                          )
                        : const SizedBox.shrink(),
                    const SizedBox(height: 20),
                    pro.userName != null
                        ?
                        // Column(
                        //         crossAxisAlignment: CrossAxisAlignment.start,
                        //         children: [
                        //           // const Text("Delivery Address : Available"),
                        //           Text("Location : ${pro.userAddress}"),
                        //           // Row(
                        //           //   mainAxisAlignment: MainAxisAlignment.e/**/nd,
                        //           //   children: [
                        //           //     MaterialButton(
                        //           //       onPressed: () =>
                        //           //           Navigator.pushNamed(context, orderSummry),
                        //           //       color: Colors.grey,
                        //           //       child: const Text(
                        //           //         "Next",
                        //           //         style: TextStyle(color: Colors.white),
                        //           //       ),
                        //           //     )
                        //           //   ],
                        //           // )
                        //         ],
                        //       ),
                        Container(
                            width: double.infinity,
                            color: Colors.grey[300],
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12),
                                child: FittedBox(
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.location_on,
                                        color: Colors.grey[600],
                                      ),
                                      PrimaryText(
                                        text: "Delivery Location: ",
                                        fontSize: 17,
                                      ),
                                      PrimaryText(
                                        text: "Available (xxxxxx, ${pro.userAddress})",
                                        fontSize: 14,
                                        color: Colors.black54,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ))
                        : Container(),
                    giftWidget(wcmp, index),
                  ],
                ))
              : //SizedBox.shrink()
              _getHistoryWidget(context, historyProvider),
        ),
      ),
    );
  }

  Widget _getHistoryWidget(BuildContext context, HistoryProvider historyProvider) {
    return TabBarView(
      children: [
        HistoryList(
          historyList: historyProvider.allHistory,
        ),
        HistoryList(
          historyList: historyProvider.receivedHistory,
        ),
        HistoryList(
          historyList: historyProvider.sendHistory,
        ),
      ],
    );
  }

  AppBar _getAppBarWidget(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.grey.withOpacity(0.3),
      centerTitle: true,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios),
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
      bottom: isHistoryTabSelected
          ? PreferredSize(
              preferredSize: const Size.fromHeight(50),
              child: Column(
                children: const [
                  TabBar(
                    indicatorColor: Colors.transparent,
                    unselectedLabelColor: Colors.black,
                    labelColor: Colors.blue,
                    tabs: [
                      Text(
                        'ALL',
                        style: TextStyle(fontSize: 15),
                      ),
                      Text('Received', style: TextStyle(fontSize: 15)),
                      Text('Sent', style: TextStyle(fontSize: 15)),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(15, 10, 15, 0),
                    child: Divider(height: 1, thickness: 2, color: Colors.black12),
                  ),
                ],
              ),
            )
          : null,
      actions: [
        const Expanded(flex: 3, child: SizedBox.shrink()),
        InkWell(
          onTap: () {
            if (isSendGiftTabSelected) return;
            isSendGiftTabSelected = !isSendGiftTabSelected;
            isHistoryTabSelected = !isHistoryTabSelected;
            setState(() {});
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            margin: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              color: isSendGiftTabSelected ? Colors.blue : Colors.transparent,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Text(
                  'Send Gifts',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: isSendGiftTabSelected ? Colors.white : Colors.grey,
                  ),
                ),
                const SizedBox(width: 8),
                Image.asset(
                  isSendGiftTabSelected ? 'assets/images/icons/gift.png' : 'assets/images/icons/grey_gift.png',
                  width: 24,
                  height: 24,
                ),
              ],
            ),
          ),
        ),
        const Expanded(child: SizedBox.shrink()),
        InkWell(
          onTap: () {
            if (isHistoryTabSelected) return;

            isSendGiftTabSelected = !isSendGiftTabSelected;
            isHistoryTabSelected = !isHistoryTabSelected;
            setState(() {});
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            margin: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              color: isHistoryTabSelected ? Colors.blue : Colors.transparent,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Text(
                  'History',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: isHistoryTabSelected ? Colors.white : Colors.grey,
                  ),
                ),
                const SizedBox(width: 8),
                Image.asset(
                  isHistoryTabSelected ? 'assets/images/icons/history.png' : 'assets/images/icons/grey_history.png',
                  width: 24,
                  height: 24,
                ),
              ], /**/
            ),
          ),
        ),
        const Expanded(child: SizedBox.shrink()),
      ],
    );
  }

  Widget giftWidget(WooCommerceMarketPlaceProvider provider, int index) {
    switch (provider.apiState) {
      case ApiState.none:
        return Container();
      case ApiState.loading:
        return const LoadingGiftsWidget();
      case ApiState.completed:
        if (provider.nearbyVendors.isEmpty) {
          return const Center(
            child: Text("No gift shops found near you."),
          );
        } else {
          return SingleChildScrollView(
            child: Column(
              children: List.generate(
                provider.categoriesshow.length,
                (index) => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16.0),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Row(
                        children: [
                          PrimaryText(
                            text: provider.categoriesshow[index].name ?? '',
                            textAlign: TextAlign.start,
                            fontSize: 17,
                          ),
                          PrimaryText(
                            text: ' (Same Day Delivery)',
                            fontSize: 12,
                            color: Colors.black54,
                          )
                        ],
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    Container(
                      height: 140,
                      color: Colors.grey[200],
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: ListView.separated(
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, prodIndex) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 6.0),
                            child: InkWell(
                              onTap: () {
                                VendorProduct vendorProduct = provider.filterByCategory(provider.categories[index])[prodIndex];
                                provider.selectVendor(vendorProduct);
                                Navigator.push(context, MaterialPageRoute(builder: (context) => const OrderSummry()));
                              },
                              child: Container(
                                width: 90,
                                decoration: BoxDecoration(color: Colors.white, border: Border.all(width: 3, color: index == prodIndex ? Colors.white : Colors.white)),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      height: 80,
                                      child: Hero(
                                        tag: provider.filterByCategory(provider.categories[index])[prodIndex].images!.first.src.toString(),
                                        child: Image.network(
                                          provider.filterByCategory(provider.categories[index])[prodIndex].images!.first.src.toString(),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          const SizedBox(
                                            height: 4.0,
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 2.0),
                                            child: Text(
                                              provider.filterByCategory(provider.categories[index])[prodIndex].name.toString(),
                                              textAlign: TextAlign.center,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          const SizedBox(height: 4.0),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 4.0),
                                            child: Text(
                                              "Price ${provider.filterByCategory(provider.categories[index])[prodIndex].price.toString()}\$",
                                              textAlign: TextAlign.center,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          separatorBuilder: (context, index) => const SizedBox(
                            width: 8.0,
                          ),
                          itemCount: provider.filterByCategory(provider.categories[index]).length,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        }
      case ApiState.error:
        return const Center(child: Text("Error!"));
    }
  }
}
