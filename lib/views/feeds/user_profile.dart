import 'package:bono_gifts/config/constants.dart';
import 'package:bono_gifts/provider/feeds_provider.dart';
import 'package:bono_gifts/provider/sign_up_provider.dart';
import 'package:bono_gifts/views/buy/buy.dart';
import 'package:bono_gifts/views/chat/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
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
      body: pro.name == null ? Center(child: CircularProgressIndicator(),):
      SafeArea(
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
                        onPressed: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context) => ChatScreen(recieverName: pro.name!,profileImage: pro.photo!,recieverPhone:pro.phonee!)));
                        },
                        child: const Text("Chat"),
                      ),
                      // const SizedBox(width: 20,),
                      CircleAvatar(
                        radius: 50,
                        backgroundImage: NetworkImage(pro.photo!),
                      ),
                      // const SizedBox(width: 20,),
                      MaterialButton(
                        color: Colors.grey,
                        onPressed: (){
                          Navigator.of(context).push(MaterialPageRoute(builder: (context) => BuyPage()));
                        },
                        child: const Text("Buy gift",style: TextStyle(color: Colors.white),),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20,),
                Text(pro.name!,style: const TextStyle(fontSize: 20,fontWeight: FontWeight.w500),),
                Text(pro.phonee!),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.location_on),
                    const Text("Location:"),
                    Flexible(
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text("${pro.room!} ${pro.building!} ${pro.area!} ${pro.street!} ${pro.country}", textAlign: TextAlign.start, maxLines: 1,),
                      ),
                    ),
                  ],
                ),
                Container(
                  height: 80,
                  width: getWidth(context),
                  color: Colors.grey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Birthday ${pro.dob!.day} ${formtr.format(pro.dob!)}",style: TextStyle(color: Colors.white,fontSize: 18),),
                      const SizedBox(height: 5,),
                      Text("${pro.networkDiffDays} Days Left",style: const TextStyle(color: Colors.white,fontSize: 25,fontWeight: FontWeight.w500),),
                    ],
                  ),
                ),
                const SizedBox(height: 5,),
                pro.postsUsers.length == 0 ? Container(
                  height: 40,
                  color: lightBlue,
                  child: Center(
                    child: Text("Photos"),
                  ),
                ) : Container(),
                const SizedBox(height: 5,),
                GridView.builder(
                  itemCount: pro.postsUsers.length,
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  gridDelegate:
                  const SliverGridDelegateWithMaxCrossAxisExtent(
                    crossAxisSpacing: 8.0,
                    mainAxisSpacing: 8.0,
                    childAspectRatio: 0.6,
                    maxCrossAxisExtent: 100,
                  ),
                  itemBuilder: (ctx,i){
                    return Image.network(pro.postsUsers.toSet().toList()[i],height: 100,fit: BoxFit.fill,);
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
