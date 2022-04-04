import 'package:bono_gifts/models/birthday_network_model.dart';
import 'package:bono_gifts/models/network_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../config/constants.dart';
import '../../provider/chat_provider.dart';
import '../../provider/feeds_provider.dart';
import '../../routes/routes_names.dart';
import '../../widgets/ClipOvalImageWidget.dart';
import '../sendGift/sendGift.dart';

class BirthdayPage extends StatefulWidget {
  const BirthdayPage({Key? key}) : super(key: key);

  @override
  State<BirthdayPage> createState() => _BirthdayPageState();
}

class _BirthdayPageState extends State<BirthdayPage> {
  bool isNetworkTabSelected = true;
  bool isCelebritiesTabSelected = false;

  @override
  Widget build(BuildContext context) {
    final proChat = Provider.of<ChatProvider>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Birthdays',
          style: TextStyle(
            color: Colors.black,
            fontFamily: 'EdwardianScriptITC',
            fontSize: 40,
          ),
        ),
      ),
      body: Column(
        children: [
          _getButtonsWidget(),
          isNetworkTabSelected
              ? _getNetworkListWidget(proChat)
              : Center(
                  child: Container(
                    padding: const EdgeInsets.only(top: 300),
                    child: const Text('Coming soon'),
                  ),
                ),
        ],
      ),
    );
  }

  Widget _getNetworkListWidget(ChatProvider proChat) {
    final pro = Provider.of<FeedsProvider>(context);
    proChat.sortBirthdayNetworkList();

    if (proChat.birthdayNetworkList.isEmpty) {
      return Center(
        child: Container(
          padding: const EdgeInsets.only(top: 300),
          child: const Text('No Data'),
        ),
      );
    }

    return Expanded(
      child: ListView.builder(
        itemCount: proChat.birthdayNetworkList.length,
        shrinkWrap: true,
        padding: const EdgeInsets.only(top: 16),
        itemBuilder: (BuildContext context, int index) {
          BirthdayNetworkModel items = proChat.birthdayNetworkList[index];
          return Column(
            children: [
              Container(
                color: index == 0 ? Colors.lightBlue.withOpacity(0.4) : Colors.grey.withOpacity(0.1),
                padding: const EdgeInsets.all(4),
                margin: const EdgeInsets.only(bottom: 8),
                width: getWidth(context),
                child: Center(
                  child: Text(
                    items.month ?? '',
                    style: TextStyle(
                      color: index == 0 ? Colors.white : Colors.grey,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
              if (items.items.isEmpty) _getNoBirthdayWidget(),
              if (items.items.isNotEmpty)
                ListView.separated(
                  shrinkWrap: true,
                  primary: false,
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  itemCount: items.items.length,
                  itemBuilder: (BuildContext context, int index) {
                    NetWorkModel item = items.items[index];

                    return _getNetworkItemWidget(
                      pro,
                      item,
                      context,
                      proChat,
                      index,
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return const SizedBox(height: 16);
                  },
                ),
            ],
          );
        },
      ),
    );
  }

  Widget _getNoBirthdayWidget() {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Container(
            width: 40,
            height: 40,
            margin: const EdgeInsets.only(bottom: 8,right: 16),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.grey.withOpacity(0.1),
            ),
          ),
        ),
        Expanded(
          flex: 6,
          child: Row(
            children: [
              Expanded(
                flex: 3,
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: const Text(
                      'No Birthday here...',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              const Expanded(
                flex: 1,
                child: SizedBox.shrink(),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _getNetworkItemWidget(FeedsProvider pro, NetWorkModel item, BuildContext context, ChatProvider proChat, int index) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        children: [
          Row(
            children: [
              InkWell(
                onTap: () async {
                  await pro.getNetworkUserData(item.phone);
                  Navigator.pushNamed(context, userProfile);
                },
                child: Container(
                  padding: const EdgeInsets.only(right: 8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Image.asset(
                        'assets/zodiac/${proChat.getZodiacByBirthday(item.dobFormat!)}.png',
                        width: 6,
                      ),
                      SizedBox(width: item.dobFormat!.toDate().month == DateTime.april ? 0 : 4),
                      Column(
                        children: [
                          ClipOvalImageWidget(
                            imageUrl: item.photo,
                            imageWidth: 40,
                            imageHeight: 40,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            proChat.getZodiacByBirthday(item.dobFormat!).toUpperCase(),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontFamily: 'BankGothicLtBT',
                              color: Colors.grey,
                              fontSize: 8,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 6,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: () async {
                        await pro.getNetworkUserData(item.phone);
                        Navigator.pushNamed(context, userProfile);
                      },
                      child: SizedBox(
                        width: getWidth(context) * 0.40,
                        child: Text(
                          item.name,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      proChat.getBirthdayDate(item.dobFormat!),
                      style: TextStyle(
                        color: Colors.black.withOpacity(0.7),
                        fontSize: 10,
                      ),
                    ),
                    const SizedBox(height: 8),
                  ],
                ),
              ),

              ///flex 4
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.only(right: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: '${proChat.getBirthdayDaysLeft(item.dobFormat!)} ',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.black.withOpacity(0.7),
                                ),
                              ),
                              TextSpan(
                                text: proChat.getBirthdayDaysLeft(item.dobFormat!) == 'Today' || proChat.getBirthdayDaysLeft(item.dobFormat!) == 'Tomorrow' ? '' : ' DAYS LEFT',
                                style: TextStyle(
                                  color: Colors.black.withOpacity(0.7),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 8,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Visibility(
                          visible: item.dobFormat!.toDate().month == DateTime.now().month,
                          child: Text(
                            proChat.checkBirthdayPassed(item.dobFormat!) ? 'Birthday Passed' : '',
                            style: const TextStyle(
                              color: Colors.deepPurpleAccent,
                              fontWeight: FontWeight.bold,
                              fontSize: 8,
                            ),
                          ),
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
                            photo: item.photo,
                            username: item.name,
                            phone: item.phone,
                          ),
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.only(right: 8),
                      child: Image.asset(
                        'assets/images/icons/gift_box.png',
                        width: 30,
                        height: 30,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _getButtonsWidget() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: InkWell(
              onTap: () {
                if (isNetworkTabSelected) return;
                isNetworkTabSelected = !isNetworkTabSelected;
                isCelebritiesTabSelected = false;
                setState(() {});
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: isNetworkTabSelected ? Colors.blue : Colors.grey.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Text(
                    'Network',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: isNetworkTabSelected ? Colors.white : Colors.grey,
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: InkWell(
              onTap: () {
                if (isCelebritiesTabSelected) return;
                isCelebritiesTabSelected = !isCelebritiesTabSelected;
                isNetworkTabSelected = false;
                setState(() {});
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: isCelebritiesTabSelected ? Colors.blue : Colors.grey.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Text(
                    'Celebrities',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: isCelebritiesTabSelected ? Colors.white : Colors.grey,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
