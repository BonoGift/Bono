import 'package:bono_gifts/provider/sign_up_provider.dart';
import 'package:bono_gifts/views/bottom_nav_bar.dart';
import 'package:bono_gifts/views/signup/welcome_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
class LoadingPage extends StatefulWidget {
  const LoadingPage({Key? key}) : super(key: key);

  @override
  _LoadingPageState createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {
  @override
  void initState() {
    super.initState();
    final pro = Provider.of<SignUpProvider>(context,listen: false);
    // pro.setShared();
    pro.getSharedData();
    Future.delayed(const Duration(seconds: 2),(){
      if(pro.phone == null || pro.phone == ''){
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) =>const WelcomePage()));
      }else{
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const BottomNavBar()));
      }
    });

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            CircularProgressIndicator(),
            Text("Please Wait!")
          ],
        ),
      ),
    );
  }
}
