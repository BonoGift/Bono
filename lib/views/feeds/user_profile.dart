import 'package:bono_gifts/config/constants.dart';
import 'package:bono_gifts/provider/feeds_provider.dart';
import 'package:bono_gifts/views/buy/buy.dart';
import 'package:bono_gifts/views/chat/chat_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({Key? key}) : super(key: key);

  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  @override
  Widget build(BuildContext context) {
    var formtr = DateFormat('MMM');
    final pro = Provider.of<FeedsProvider>(context);
    return Scaffold(
      body: pro.name == null
          ? const Center(child: CircularProgressIndicator())
          : SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SingleChildScrollView(
                  child: Stack(
                    children: [
                      Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                MaterialButton(
                                  color: Colors.grey[300],
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ChatScreen(
                                          recieverName: pro.name!,
                                          profileImage: pro.photo!,
                                          recieverPhone: pro.phonee!,
                                        ),
                                      ),
                                    );
                                  },
                                  child: const Text("Chat"),
                                ),
                                ClipOval(
                                  child: CachedNetworkImage(
                                    imageUrl: pro.photo!,
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
                                /*CircleAvatar(
                                  radius: 50,
                                  backgroundImage: NetworkImage(pro.photo!),
                                ),*/
                                MaterialButton(
                                  color: Colors.grey[800],
                                  onPressed: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) => const BuyPage(),
                                      ),
                                    );
                                  },
                                  child: const Text(
                                    "Buy gift",
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),
                          Text(
                            pro.name!,
                            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                          ),
                          Text(pro.phonee!),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.location_on),
                              const Text("Location:"),
                              Text("${pro.country}/Confidential"),
                              /*Flexible(
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    "${pro.room!} ${pro.building!} ${pro.area!} ${pro.street!} ${pro.country}",
                                    textAlign: TextAlign.start,
                                    maxLines: 1,
                                  ),
                                ),
                              ),*/
                            ],
                          ),
                          Container(
                            height: 80,
                            width: getWidth(context),
                            color: Colors.grey[800],
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Birthday ${pro.dob!.day} ${formtr.format(pro.dob!)}",
                                  style: const TextStyle(color: Colors.white, fontSize: 18),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  "${pro.networkDiffDays} Days Left",
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 25,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 5),
                          pro.postsUsers.isEmpty
                              ? Container(
                                  height: 40,
                                  color: lightBlue,
                                  child: const Center(
                                    child: Text("Photos"),
                                  ),
                                )
                              : Container(),
                          const SizedBox(
                            height: 5,
                          ),
                          GridView.builder(
                            itemCount: pro.postsUsers.length,
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                              crossAxisSpacing: 8.0,
                              mainAxisSpacing: 8.0,
                              childAspectRatio: 0.6,
                              maxCrossAxisExtent: 100,
                            ),
                            itemBuilder: (ctx, i) {
                              return Image.network(
                                pro.postsUsers.toSet().toList()[i],
                                height: 100,
                                fit: BoxFit.fill,
                              );
                            },
                          )
                        ],
                      ),
                      Positioned(
                        left: 8,
                        child: InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: const Icon(
                            Icons.arrow_back_ios,
                            color: Colors.black,
                            size: 24,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
