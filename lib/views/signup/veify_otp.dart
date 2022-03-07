import 'package:bono_gifts/config/constants.dart';
import 'package:bono_gifts/provider/sign_up_provider.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';

class VerifyOTP extends StatefulWidget {
  const VerifyOTP({Key? key}) : super(key: key);

  @override
  _VerifyOTPState createState() => _VerifyOTPState();
}

class _VerifyOTPState extends State<VerifyOTP> {
  @override
  void initState() {
    super.initState();
    Provider.of<SignUpProvider>(context, listen: false).startTimer();
  }

  @override
  Widget build(BuildContext context) {
    final pro = Provider.of<SignUpProvider>(context);
    pro.requestPermissions();
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 30),
              const Text(
                "We sent code via SMS to",
                style: TextStyle(fontSize: 22, color: Colors.blue),
                textAlign: TextAlign.center,
              ),
              Text(
                "${pro.dailCode} ${pro.phoneNumber.text}",
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: getWidth(context) / 1.4,
                child: PinCodeTextField(
                  validator: (val) {
                    if (val!.isEmpty) {
                      return "Please Enter Code";
                    }
                  },
                  appContext: context,
                  length: 6,
                  obscureText: false,
                  animationType: AnimationType.fade,
                  keyboardType: TextInputType.number,
                  pinTheme: PinTheme(
                    inactiveColor: Colors.blue,
                    inactiveFillColor: Colors.white,
                    selectedColor: Colors.blue,
                    selectedFillColor: Colors.white,
                    shape: PinCodeFieldShape.box,
                    borderRadius: BorderRadius.circular(5),
                    fieldHeight: 50,
                    fieldWidth: 40,
                    activeFillColor: Colors.white,
                  ),
                  enablePinAutofill: true,
                  animationDuration: const Duration(milliseconds: 300),
                  enableActiveFill: true,
                  onCompleted: (v) {
                    // pro.verifyEmail(context);
                    pro.verifyOTP(context);
                    pro.makeWaitingState();
                  },
                  onChanged: (value) {
                    pro.setOTP(value);
                    // pro.verificationCode = value;
                  },
                  beforeTextPaste: (text) {
                    print("Allowing to paste $text");
                    return true;
                  },
                ),
              ),
              Text(
                pro.otpErro,
                style: const TextStyle(color: Colors.red),
              ),
              const Text("Please enter 6 digit code here"),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("Cancel"),
                  ),
                  MaterialButton(
                    color: Colors.blue,
                    onPressed: () {
                      pro.makeWaitingState();
                      pro.verifyOTP(context);
                    },
                    child: pro.isWaitingCon
                        ? const CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          )
                        : const Text(
                            "Next",
                            style: TextStyle(color: Colors.white),
                          ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Image.asset(
                          chatIcon,
                          height: 25,
                          width: 25,
                        ),
                        TextButton(
                          onPressed: () {
                            pro.authUserWithPhone();
                          },
                          child: const Text("Resend SMS"),
                        ),
                      ],
                    ),
                    Text("00.${pro.time.toString()}")
                  ],
                ),
              ),
              const Divider(thickness: 2)
            ],
          ),
        ),
      ),
    );
  }
}
