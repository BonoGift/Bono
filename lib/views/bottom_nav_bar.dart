import 'package:bono_gifts/config/constants.dart';
import 'package:bono_gifts/provider/feeds_provider.dart';
import 'package:bono_gifts/views/camera/camera.dart';
import 'package:bono_gifts/views/chat/chat.dart';
import 'package:bono_gifts/views/feeds/feeds.dart';
import 'package:bono_gifts/views/gift/history.dart';
import 'package:bono_gifts/views/profile/profile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({Key? key}) : super(key: key);

  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int index = 2;
  List<Widget> allPages = [
    Chat(),
    // BuyPage(),
    HistoryPage(),
    Feeds(),
    const CameraScreen(),
    const ProfilePage()
  ];

  Future<bool> onWillPop() {
    if (index != 2) {
      final pro = Provider.of<FeedsProvider>(context);
      index = 2;
      pro.setIndex(index);
      setState(() {});
      return Future.value(false);
    }
    return Future.value(true);
  }

  @override
  Widget build(BuildContext context) {
    final pro = Provider.of<FeedsProvider>(context);
    return WillPopScope(
      onWillPop: onWillPop,
      child: Scaffold(
        body: SafeArea(
          child: Stack(
            children: [
              IndexedStack(
                index: index,
                children: allPages,
              ),
              Visibility(
                visible: index == 4,
                child: Positioned(
                  left: 8,
                  child: InkWell(
                    onTap: () {
                      if (index != 2) {
                        index = 2;
                        pro.setIndex(index);
                        setState(() {});
                      }
                    },
                    child: const Icon(
                      Icons.arrow_back_ios,
                      color: Colors.black,
                      size: 24,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            unselectedItemColor: Colors.grey,
            showUnselectedLabels: true,
            selectedItemColor: Colors.black,
            currentIndex: index,
            onTap: (val) {
              setState(() {
                index = val;
                pro.setIndex(val);
              });
            },
            items: [
              BottomNavigationBarItem(
                  icon: Image.asset(
                    index == 0 ? chatIconBlue : chatIconGrey,
                    height: 20,
                    width: 20,
                  ),
                  label: 'Chat'),
              BottomNavigationBarItem(
                  icon: Image.asset(
                    index == 1 ? giftIconBlue : giftIConGrey,
                    height: 20,
                    width: 20,
                  ),
                  label: 'Buy'),
              BottomNavigationBarItem(
                  icon: Image.asset(
                    index == 2 ? feedIconBlue : feedIConGrey,
                    height: 20,
                    width: 20,
                  ),
                  label: 'Feeds'),
              BottomNavigationBarItem(
                  icon: Image.asset(
                    index == 3 ? cameraIconBlue : cameraIconGrey,
                    height: 20,
                    width: 20,
                  ),
                  label: 'Camera'),
              BottomNavigationBarItem(
                  icon: Image.asset(
                    index == 4 ? profileIconBlue : profileIconGrey,
                    height: 20,
                    width: 20,
                  ),
                  label: 'Profile'),
            ]),
      ),
    );
  }
}
