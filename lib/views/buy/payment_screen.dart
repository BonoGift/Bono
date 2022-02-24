import 'package:bono_gifts/models/wcmp_api/vendor.dart';
import 'package:bono_gifts/payments/payment.dart';
import 'package:bono_gifts/payments/paypal_screen.dart';
import 'package:bono_gifts/provider/wcmp_provider.dart';
import 'package:bono_gifts/views/buy/widgets/primary_button.dart';
import 'package:bono_gifts/views/gift/widgets/primary_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_braintree/flutter_braintree.dart';
import 'package:provider/provider.dart';

class PaymnetScreen extends StatefulWidget {
  const PaymnetScreen({Key? key}) : super(key: key);

  @override
  _PaymnetScreenState createState() => _PaymnetScreenState();
}

class _PaymnetScreenState extends State<PaymnetScreen> {
  bool google = false;
  bool apple = false;
  bool paypal = true;
  String tokenizeKey = "sandbox_zjk38q83_d9s5x28jpgg8snjs";
  Color aliceBlue = const Color(0xffbcd4e6);

  @override
  Widget build(BuildContext context) {
    final pror = Provider.of<WooCommerceMarketPlaceProvider>(context);
    var activeColor = aliceBlue;
    var inActiveColor = Colors.grey[200];
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.lightBlueAccent,
          title: const Text(
            "Buy Gifts",
            style: TextStyle(fontSize: 20),
          ),
          centerTitle: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              const SizedBox(
                height: 40,
              ),
              PrimaryText(text: 'Choose Payment Method'),
              const SizedBox(
                height: 20,
              ),
              PrimaryButton(paypal, () {
                setState(() {
                  apple = false;
                  paypal = true;
                  google = false;
                });
              }, getColor(paypal), true),
              const SizedBox(
                height: 15,
              ),
              PrimaryButton(google, () {
                setState(() {
                  apple = false;
                  paypal = false;
                  google = true;
                });
              }, getColor(google)),
              const SizedBox(
                height: 15,
              ),
              PrimaryButton(apple, () {
                setState(() {
                  apple = true;
                  paypal = false;
                  google = false;
                });
              }, getColor(apple), false, 'Apple'),
              const SizedBox(
                height: 20,
              ),
              Text(
                'Total: ${finalPrice(pror.price.toString(), 3).toString()}\$',
                style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w900,
                    fontSize: 30),
              ),
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    TextButton(
                      onPressed: () {
                        // pro.checkIfUSer('+923033374110');
                        Navigator.pop(context);
                      },
                      child: const Text("Back"),
                    ),
                    MaterialButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                          side: const BorderSide(color: Colors.transparent)),
                      color: Colors.lightBlueAccent,
                      onPressed: () {
                        print('pay clicked');
                        if (google == true) {
                          Payments.requestGooglePay(
                              context, finalPrice(pror.price.toString(), 3));
                        } else if (paypal == true) {
                          Payments.requestPayPal(
                              context, finalPrice(pror.price.toString(), 3));
                        } else if (apple == true) {
                          //TODO implement apple pay later
                        }
                        // if(google == true){
                        //   final request = BraintreeDropInRequest(
                        //     clientToken: tokenizeKey,
                        //     collectDeviceData: true,
                        //     googlePaymentRequest: BraintreeGooglePaymentRequest(
                        //       totalPrice: '4.20',
                        //       currencyCode: 'USD',
                        //       billingAddressRequired: false,
                        //       googleMerchantID: 'bonoMirchent'
                        //     ),
                        //     // paypalRequest: BraintreePayPalRequest(
                        //     //   amount: '4.20',
                        //     //   displayName: 'Example company',
                        //     // ),
                        //   );
                        //   final result = await BraintreeDropIn.start(request);
                        //   if (result!.paymentMethodNonce != null) {
                        //     // print(result.deviceData.toString());
                        //     print(result.paymentMethodNonce.description);
                        //     print(result.paymentMethodNonce.nonce);
                        //     // print(result.paymentMethodNonce.typeLabel);
                        //     print(result.toString());
                        //   }else{
                        //     print("Payment cancel");
                        //   }
                        // }else if(apple == true){
                        //
                        // }else if(paypal == true){
                        //   final request = BraintreeDropInRequest(
                        //     // clientToken: "d9s5x28jpgg8snjs",
                        //     tokenizationKey: tokenizeKey,
                        //     collectDeviceData: true,
                        //     // googlePaymentRequest: BraintreeGooglePaymentRequest(
                        //     //     totalPrice: '4.20',
                        //     //     currencyCode: 'USD',
                        //     //     billingAddressRequired: false,
                        //     //     googleMerchantID: 'bonoMirchent'
                        //     // ),
                        //     paypalRequest: BraintreePayPalRequest(
                        //       amount: '4.20',
                        //       displayName: 'Example company',
                        //     ),
                        //   );
                        //   final result = await BraintreeDropIn.start(request);
                        //   if (result != null) {
                        //     print(result.paymentMethodNonce);
                        //   }
                        // }
                      },
                      child: const Text(
                        "Pay",
                        style: TextStyle(color: Colors.white),
                      ),
                    )
                  ],
                ),
              )
              // Card(
              //   child: Padding(
              //     padding: const EdgeInsets.all(15.0),
              //     child: Column(
              //       children: [
              //         Row(
              //           children: [
              //             Checkbox(
              //               value: google,
              //               onChanged: (val) {
              //                 setState(() {
              //                   apple = false;
              //                   paypal = false;
              //                   google = true;
              //                 });
              //               },
              //             ),
              //             Image.asset("assets/images/icons/Google.png",
              //                 height: 30)
              //           ],
              //         ),
              //         Row(
              //           children: [
              //             Checkbox(
              //               value: apple,
              //               onChanged: (val) {
              //                 setState(() {
              //                   apple = true;
              //                   paypal = false;
              //                   google = false;
              //                 });
              //               },
              //             ),
              //             Image.asset("assets/images/icons/Apple.png",
              //                 height: 30)
              //           ],
              //         ),
              //         Row(
              //           children: [
              //             Checkbox(
              //               value: paypal,
              //               onChanged: (val) {
              //                 setState(() {
              //                   apple = false;
              //                   paypal = true;
              //                   google = false;
              //                 });
              //               },
              //             ),
              //             Image.network(
              //                 "https://assets.stickpng.com/images/580b57fcd9996e24bc43c530.png",
              //                 height: 30)
              //           ],
              //         ),
              //         const SizedBox(
              //           height: 40,
              //         ),
              //         Row(
              //           mainAxisAlignment: MainAxisAlignment.end,
              //           children: [
              //             Text(
              //               "Total Price : ${pror.price!}",
              //               style: const TextStyle(
              //                   fontSize: 22, fontWeight: FontWeight.w500),
              //             ),
              //           ],
              //         ),
              //         const SizedBox(
              //           height: 20,
              //         ),
              //         Row(
              //           mainAxisAlignment: MainAxisAlignment.end,
              //           children: [
              //             TextButton(
              //               onPressed: () {
              //                 // pro.checkIfUSer('+923033374110');
              //                 Navigator.pop(context);
              //               },
              //               child: const Text("Back"),
              //             ),
              //             MaterialButton(
              //               color: Colors.blue,
              //               onPressed: () {
              //                 print('pay clicked');
              //                 if (google == true) {
              //                   Payments.requestGooglePay(context);
              //                 } else if (paypal == true) {
              //                   Payments.requestPayPal(context);
              //                 } else if (apple == true) {
              //                   //TODO implement apple pay later
              //                 }
              //                 // if(google == true){
              //                 //   final request = BraintreeDropInRequest(
              //                 //     clientToken: tokenizeKey,
              //                 //     collectDeviceData: true,
              //                 //     googlePaymentRequest: BraintreeGooglePaymentRequest(
              //                 //       totalPrice: '4.20',
              //                 //       currencyCode: 'USD',
              //                 //       billingAddressRequired: false,
              //                 //       googleMerchantID: 'bonoMirchent'
              //                 //     ),
              //                 //     // paypalRequest: BraintreePayPalRequest(
              //                 //     //   amount: '4.20',
              //                 //     //   displayName: 'Example company',
              //                 //     // ),
              //                 //   );
              //                 //   final result = await BraintreeDropIn.start(request);
              //                 //   if (result!.paymentMethodNonce != null) {
              //                 //     // print(result.deviceData.toString());
              //                 //     print(result.paymentMethodNonce.description);
              //                 //     print(result.paymentMethodNonce.nonce);
              //                 //     // print(result.paymentMethodNonce.typeLabel);
              //                 //     print(result.toString());
              //                 //   }else{
              //                 //     print("Payment cancel");
              //                 //   }
              //                 // }else if(apple == true){
              //                 //
              //                 // }else if(paypal == true){
              //                 //   final request = BraintreeDropInRequest(
              //                 //     // clientToken: "d9s5x28jpgg8snjs",
              //                 //     tokenizationKey: tokenizeKey,
              //                 //     collectDeviceData: true,
              //                 //     // googlePaymentRequest: BraintreeGooglePaymentRequest(
              //                 //     //     totalPrice: '4.20',
              //                 //     //     currencyCode: 'USD',
              //                 //     //     billingAddressRequired: false,
              //                 //     //     googleMerchantID: 'bonoMirchent'
              //                 //     // ),
              //                 //     paypalRequest: BraintreePayPalRequest(
              //                 //       amount: '4.20',
              //                 //       displayName: 'Example company',
              //                 //     ),
              //                 //   );
              //                 //   final result = await BraintreeDropIn.start(request);
              //                 //   if (result != null) {
              //                 //     print(result.paymentMethodNonce);
              //                 //   }
              //                 // }
              //               },
              //               child: const Text(
              //                 "Pay",
              //                 style: TextStyle(color: Colors.white),
              //               ),
              //             )
              //           ],
              //         )
              //       ],
              //     ),
              //   ),
              // )
            ],
          ),
        ),
      ),
    );
  }

  int finalPrice(String price, int delivery) {
    final int actualPrice = int.parse(price.toString());
    final int totalPrice = actualPrice + delivery;
    return totalPrice;
  }

  Color getColor(bool value) {
    Color? color = Colors.grey[200];
    if (value) {
      color = aliceBlue;
      return color;
    }
    return color!;
  }
}
