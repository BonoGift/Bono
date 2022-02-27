import 'package:bono_gifts/payments/payment.dart';
import 'package:bono_gifts/provider/buy_provider.dart';
import 'package:bono_gifts/provider/paypal_provider.dart';
import 'package:bono_gifts/provider/wcmp_provider.dart';
import 'package:bono_gifts/views/buy/app_webview.dart';
import 'package:bono_gifts/views/buy/widgets/primary_button.dart';
import 'package:bono_gifts/views/gift/widgets/primary_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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

  String checkoutUrl = '';
  String executeUrl = '';
  String accessToken = '';

  bool isLoading = false;

  @override
  void initState() {
    setState(() {
      isLoading = true;
    });
    context.read<PaypalProvider>().init().then((value) {
      accessToken = value;
      setState(() {
        isLoading = false;
      });
    });
    super.initState();
  }

  Map<String, dynamic> getOrderParams(
    BuildContext context,
  ) {
    final pro = Provider.of<BuyProvider>(context, listen: false);
    final pror =
        Provider.of<WooCommerceMarketPlaceProvider>(context, listen: false);

    // you can change default currency according to your need
    Map<dynamic, dynamic> defaultCurrency = {
      "symbol": "USD ",
      "decimalDigits": 2,
      "symbolBeforeTheNumber": true,
      "currency": "USD"
    };

    List items = [
      {
        "name": pror.name,
        "quantity": 1,
        "price": pror.price,
        "currency": defaultCurrency["currency"]
      }
    ];

    // checkout invoice details
    String totalAmount = finalPrice(pror.price!, 3).toString();
    String subTotalAmount = pror.price!;
    String shippingCost = '3';
    int shippingDiscountCost = 0;
    String userFirstName = pro.userName.toString();
    String userLastName = pro.userName.toString();
    String addressCity = 'Karachi';
    String addressStreet = '';
    String addressZipCode = '75660';
    String addressCountry = 'Pakistan';
    String addressState = 'Sindh';
    String addressPhoneNumber = '+923152284272';

    bool isEnableShipping = false;
    bool isEnableAddress = false;

    String returnURL = 'return.example.com';
    String cancelURL = 'cancel.example.com';

    Map<String, dynamic> temp = {
      "intent": "sale",
      "payer": {"payment_method": "paypal"},
      "transactions": [
        {
          "amount": {
            "total": totalAmount,
            "currency": defaultCurrency["currency"],
            "details": {
              "subtotal": subTotalAmount,
              "shipping": shippingCost,
              "shipping_discount": ((-1.0) * shippingDiscountCost).toString()
            }
          },
          "description": "The payment transaction description.",
          "payment_options": {
            "allowed_payment_method": "INSTANT_FUNDING_SOURCE"
          },
          "item_list": {
            "items": items,
            if (isEnableShipping && isEnableAddress)
              "shipping_address": {
                "recipient_name": userFirstName + " " + userLastName,
                "line1": addressStreet,
                "line2": "",
                "city": addressCity,
                "country_code": addressCountry,
                "postal_code": addressZipCode,
                "phone": addressPhoneNumber,
                "state": addressState
              },
          }
        }
      ],
      "note_to_payer": "Contact us for any questions on your order.",
      "redirect_urls": {"return_url": returnURL, "cancel_url": cancelURL}
    };
    return temp;
  }

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
        body: isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Padding(
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
                                side: const BorderSide(
                                    color: Colors.transparent)),
                            color: Colors.lightBlueAccent,
                            onPressed: () {
                              print('pay clicked');
                              if (google == true) {
                                Payments.requestGooglePay(context,
                                    finalPrice(pror.price.toString(), 3));
                              } else if (paypal == true) {
                                // Payments.requestPayPal(
                                //     context, finalPrice(pror.price.toString(), 3));
                                context
                                    .read<PaypalProvider>()
                                    .createPaypalPayment(
                                        getOrderParams(context), accessToken)
                                    .then((value) => Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => AppWebView(
                                                checkoutUrl:
                                                    value!["approvalUrl"]!,
                                                executeUrl:
                                                    value["executeUrl"]!,
                                                accessToken: accessToken))));
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
