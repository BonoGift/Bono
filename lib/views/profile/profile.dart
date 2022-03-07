import 'package:bono_gifts/config/constants.dart';
import 'package:bono_gifts/helper/decorated_image.dart';
import 'package:bono_gifts/provider/sign_up_provider.dart';
import 'package:bono_gifts/routes/routes_names.dart';
import 'package:cached_network_image/cached_network_image.dart';
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
    return Scaffold(
      body: pro.name == null
          ? const Center(
              child: CircularProgressIndicator(),
            )
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
                            // const SizedBox(width: 20,),
                            ClipOval(
                              child: CachedNetworkImage(
                                imageUrl: pro.userImage,
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
                              backgroundImage: NetworkImage(pro.userImage),
                            ),*/
                            // const SizedBox(width: 20,),
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
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        pro.name,
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                      ),
                      Text(pro.phoneNumber.text),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 3.0),
                        child: FittedBox(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.location_on),
                              const Text("Location:"),
                              Text("${pro.country}/Confidential"),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
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
                            const SizedBox(
                              height: 5,
                            ),
                            Text(
                              "${pro.diffDays ?? 0} Days Left",
                              style: const TextStyle(color: Colors.white, fontSize: 25, fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Container(
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
                      const SizedBox(
                        height: 5,
                      ),
                      GridView.builder(
                        itemCount: pro.myPosts.length,
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                          crossAxisSpacing: 8.0,
                          mainAxisSpacing: 8.0,
                          childAspectRatio: 0.6,
                          maxCrossAxisExtent: 100,
                        ),
                        itemBuilder: (ctx, i) {
                          // return Image.network(
                          //   pro.myPosts[i],
                          //   // height: 100,
                          //   fit: BoxFit.cover,
                          // );
                          return DecoratedImage(
                            image: pro.myPosts[i],
                            fit: BoxFit.cover,
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
}
