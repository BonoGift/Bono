import 'package:bono_gifts/config/constants.dart';
import 'package:bono_gifts/routes/routes_names.dart';
import 'package:flutter/material.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({Key? key}) : super(key: key);

  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: getHeight(context),
        width: getWidth(context),
        decoration: const BoxDecoration(
            image: DecorationImage(
                fit: BoxFit.fill, image: AssetImage(welcomeBg))),
        child: Stack(
          children: [
            const Align(
              alignment: Alignment(0.0, -0.5),
              child: Text(
                "Welcome To Bono",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
              ),
            ),
            Align(
              alignment: const Alignment(0.0, 0.0),
              child: Image.asset(
                logo,
                height: 200,
                width: 200,
                fit: BoxFit.fill,
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    const Text(
                      'Click "Agree And Continue" to accept Bono',
                      textAlign: TextAlign.center,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text(
                          "Terms of Conditions ",
                          style: TextStyle(
                            color: Colors.blue,
                          ),
                        ),
                        Text("& "),
                        Text(
                          "Privacy Policy",
                          style: TextStyle(
                            color: Colors.blue,
                          ),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    MaterialButton(
                      color: Colors.blue,
                      minWidth: getWidth(context),
                      child: const Text(
                        "AGREE AND CONTINUE",
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () async {
                        Navigator.pushNamed(context, phoneAuth);
                      },
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
