import 'package:bono_gifts/config/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../provider/sign_up_provider.dart';
import '../bottom_nav_bar.dart';
import '../signup/welcome_page.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    final pro = Provider.of<SignUpProvider>(context, listen: false);
    pro.getSharedData();
    Future.delayed(const Duration(seconds: 2), () {
      if (pro.phone == null || pro.phone == '') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const WelcomePage()),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const BottomNavBar()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Image.asset(
              'assets/images/icons/splash_screen_icon.png',
              width: getWidth(context) * 0.40,
            ),
          ),
          const Center(
            child: Text(
              'Bono',
              style: TextStyle(
                color: Color(0xFF0D68B5),
                fontSize: 36,
                fontFamily: 'CommercialScriptBT',
              ),
            ),
          ),
          SizedBox(height: getHeight(context) * 0.15),
        ],
      ),
    );
  }
}
