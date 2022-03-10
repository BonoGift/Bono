import 'package:flutter/material.dart';

class PrimaryButton extends StatelessWidget {
  final String img;
  final bool value;
  final Color color;
  final bool isPayPal;
  final Function() onChanged;
  PrimaryButton(this.value, this.onChanged, this.color,
      [this.isPayPal = false, this.img = 'Google']);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: MaterialButton(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
            side: BorderSide(color: color)),
        minWidth: double.maxFinite,
        color: color,
        onPressed: onChanged,
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Row(
            children: [
              Transform.scale(
                scale: 0.8,
                child: Checkbox(
                  side: MaterialStateBorderSide.resolveWith(
                    (states) =>
                        const BorderSide(width: 2.0, color: Colors.white),
                  ),
                  checkColor: color,
                  activeColor: Colors.white,
                  value: value,
                  onChanged: (val) {
                    onChanged();
                  },
                ),
              ),
              const SizedBox(
                width: 8,
              ),
              // Checkbox(
              //   value: google,
              //   onChanged: (val) {
              //     setState(() {
              //       apple = false;
              //       paypal = false;
              //       google = true;
              //     });
              //   },
              // ),
              Visibility(
                visible: isPayPal,
                child: Image.asset(
                  "assets/images/paypal.png",
                  height: 35,
                ),
              ),
              Visibility(
                  visible: !isPayPal,
                  child:
                      Image.asset("assets/images/icons/${img}.png", height: 22))
            ],
          ),
        ),
      ),
    );
  }
}
