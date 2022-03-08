import 'package:bono_gifts/config/constants.dart';
import 'package:bono_gifts/provider/sign_up_provider.dart';
import 'package:bono_gifts/routes/routes_names.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  var formtr = DateFormat('MMM');

  @override
  Widget build(BuildContext context) {
    final pro = Provider.of<SignUpProvider>(context);
    final CarouselController _controller = CarouselController();
    return Scaffold(
      body: pro.name == null
          ? const Center(child: CircularProgressIndicator())
          : SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            MaterialButton(
                              color: Colors.grey[300],
                              onPressed: () => pro.logout(context),
                              child: const Text("Sign out"),
                            ),
                            ClipOval(
                              child: CachedNetworkImage(
                                imageUrl: pro.userImage.isEmpty ? 'https://firebasestorage.googleapis.com/v0/b/bonogifts.appspot.com/o/profile.png?alt=media&token=dec6afee-44f3-4876-8f2b-dbb2be0dd4d8' : pro.userImage,
                                progressIndicatorBuilder: (context, url, progress) => SizedBox(
                                  width: 100,
                                  height: 100,
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
                                width: 100,
                                height: 100,
                              ),
                            ),
                            MaterialButton(
                              color: Colors.grey[800],
                              onPressed: () => Navigator.pushNamed(context, editProfile),
                              child: const Text(
                                "Edit Profile",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        pro.name,
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                      ),
                      Text('${pro.dailCode} ${pro.phoneNumber.text}'),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 3.0),
                        child: FittedBox(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.location_on),
                              const Text("Location:"),
                              Text("${pro.country ?? ''}/Confidential"),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        height: 80,
                        width: getWidth(context),
                        color: Colors.grey[800],
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Birthday ${pro.dobFormat.day} ${pro.dobFormat != null ? formtr.format(pro.dobFormat) : ''}",
                              style: const TextStyle(color: Colors.white, fontSize: 18),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              "${pro.diffDays ?? 0} Days Left",
                              style: const TextStyle(color: Colors.white, fontSize: 25, fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      InkWell(
                        onTap: () => Navigator.pushNamed(context, addPOst),
                        child: Container(
                          height: 40,
                          width: double.maxFinite,
                          color: Colors.lightBlueAccent,
                          child: Center(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Icon(
                                  Icons.add_circle_outline,
                                  color: Colors.white,
                                ),
                                SizedBox(width: 4),
                                Text(
                                  "Post Something",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'EdwardianScriptITC',
                                    fontSize: 24,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 5),
                      pro.myPosts.isEmpty
                          ? Container(
                              height: 40,
                              color: lightBlue,
                              child: const Center(
                                child: Text("Photos"),
                              ),
                            )
                          : Container(),
                      const SizedBox(height: 5),
                      GridView.builder(
                        itemCount: pro.myPosts.length,
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisSpacing: 4.0,
                          mainAxisSpacing: 8.0,
                          childAspectRatio: 0.6,
                          crossAxisCount: 3,
                        ),
                        itemBuilder: (ctx, i) {
                          return Container(
                            decoration: BoxDecoration(
                              color: Colors.black,
                              border: Border.all(color: const Color(0xFFFFFAFA), width: 5),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: InkWell(
                              onTap: () {
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return StatefulBuilder(
                                        builder: (
                                          BuildContext context,
                                          void Function(void Function()) setState,
                                        ) {
                                          return Container(
                                            color: Colors.black,
                                            height: getHeight(context),
                                            child: Stack(
                                              children: [
                                                CarouselSlider(
                                                  carouselController: _controller,
                                                  items: _getCarouselItemsWidget(pro.myPosts),
                                                  options: CarouselOptions(
                                                    initialPage: i,
                                                    height: double.infinity,
                                                    viewportFraction: 1.0,
                                                    enlargeCenterPage: false,
                                                    onPageChanged: (index, reason) {
                                                      setState(() {
                                                        i = index;
                                                      });
                                                    },
                                                  ),
                                                ),
                                                Positioned(
                                                  bottom: 24,
                                                  left: 0,
                                                  right: 0,
                                                  child: AnimatedContainer(
                                                    duration: const Duration(milliseconds: 500),
                                                    child: Wrap(
                                                      alignment: WrapAlignment.center,
                                                      spacing: 8,
                                                      children: pro.myPosts.map((element) {
                                                        int index = pro.myPosts.indexOf(element);
                                                        return Container(
                                                          width: 12,
                                                          height: 12,
                                                          decoration: BoxDecoration(
                                                            shape: BoxShape.circle,
                                                            color: i == index ? Colors.yellow : Colors.grey,
                                                          ),
                                                        );
                                                      }).toList(),
                                                    ),
                                                  ),
                                                ),
                                                Positioned(
                                                  top: 16,
                                                  left: 16,
                                                  child: GestureDetector(
                                                    onTap: () {
                                                      Navigator.pop(context);
                                                    },
                                                    child: const Icon(
                                                      Icons.close_sharp,
                                                      size: 24,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                      );
                                    });
                              },
                              child: CachedNetworkImage(
                                imageUrl: pro.myPosts[i],
                                //width: double.infinity,
                                progressIndicatorBuilder: (context, url, progress) => SizedBox(
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
                                fit: BoxFit.fitWidth,
                              ),
                            ),
                          );
                        },
                      )
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  List<Widget> _getCarouselItemsWidget(List<String> items) {
    return items.map((e) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: CachedNetworkImage(
          imageUrl: e,
          progressIndicatorBuilder: (context, url, progress) => SizedBox(
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
        ),
      );
    }).toList();
  }
}
