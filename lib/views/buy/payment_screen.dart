import 'package:bono_gifts/models/paypal_order_model.dart';
import 'package:bono_gifts/models/user_model.dart';
import 'package:bono_gifts/models/wcmp_api/vendor_product.dart';
import 'package:bono_gifts/payments/payment.dart';
import 'package:bono_gifts/provider/paypal_provider.dart';
import 'package:bono_gifts/provider/sign_up_provider.dart';
import 'package:bono_gifts/provider/wcmp_provider.dart';
import 'package:bono_gifts/views/buy/app_webview.dart';
import 'package:bono_gifts/views/buy/widgets/primary_button.dart';
import 'package:bono_gifts/views/gift/widgets/primary_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({Key? key}) : super(key: key);

  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
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

  PaypalOrderModel getOrderParams(
    BuildContext context, {
    required UserModel receiver,
  }) {
    final WooCommerceMarketPlaceProvider wooCommerceMarketPlaceProvider =
        Provider.of<WooCommerceMarketPlaceProvider>(context, listen: false);
    final SignUpProvider signUpProvider =
        Provider.of<SignUpProvider>(context, listen: false);

    VendorProduct product = wooCommerceMarketPlaceProvider.selectedProduct!;
    print("Product: ${product.toJson().toString()}");

    String returnURL = 'return.example.com';
    String cancelURL = 'cancel.example.com';

    PaypalOrderModel paypalOrderModel = PaypalOrderModel(
      intent: "sale",
      noteToPayer: "Contact us for any questions on your order",
      payer: Payer(paymentMethod: "paypal"),
      redirectUrls: RedirectUrls(
        returnUrl: returnURL,
        cancelUrl: cancelURL,
      ),
      transactions: [
        Transactions(
          amount: Amount(
            currency: "USD",
            total: wooCommerceMarketPlaceProvider.finalPrice().toString(),
            details: Details(
                tax: "0",
                handlingFee: "0",
                insurance: "0",
                shipping:
                    wooCommerceMarketPlaceProvider.deliveryPrice.toString(),
                shippingDiscount: "0",
                subtotal: product.price),
          ),
          description: product.description,
          itemList: ItemList(
            items: [
              Items(
                  name: product.name,
                  description: product.description,
                  price: product.price,
                  quantity: "1",
                  currency: "USD",
                  sku: product.id.toString(),
                  tax: "0"),
            ],
            shippingAddress: ShippingAddress(
                recipientName: receiver.name,
                city: receiver.city,
                phone: receiver.phoneNumber,
                countryCode: "AE",
                state: "Dubai",
                postalCode: "00000",
                line1:
                    "${receiver.buildingName} ${receiver.street} ${receiver.area}",
                line2: " "),
          ),
          paymentOptions:
              PaymentOptions(allowedPaymentMethod: "INSTANT_FUNDING_SOURCE"),
        ),
      ],
    );

    return paypalOrderModel;
  }

  @override
  Widget build(BuildContext context) {
    final WooCommerceMarketPlaceProvider wooCommerceMarketPlaceProvider =
        Provider.of<WooCommerceMarketPlaceProvider>(context);
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
            : wooCommerceMarketPlaceProvider.apiState == ApiState.loading
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
                        // const SizedBox(
                        //   height: 15,
                        // ),
                        // PrimaryButton(google, () {
                        //   setState(() {
                        //     apple = false;
                        //     paypal = false;
                        //     google = true;
                        //   });
                        // }, getColor(google)),
                        // const SizedBox(
                        //   height: 15,
                        // ),
                        // PrimaryButton(apple, () {
                        //   setState(() {
                        //     apple = true;
                        //     paypal = false;
                        //     google = false;
                        //   });
                        // }, getColor(apple), false, 'Apple'),
                        const SizedBox(
                          height: 20,
                        ),
                        Text(
                          'Total: ${wooCommerceMarketPlaceProvider.finalPrice().toString()}\$',
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
                                    Payments.requestGooglePay(
                                        context,
                                        wooCommerceMarketPlaceProvider
                                            .finalPrice());
                                  } else if (paypal == true) {
                                    // Payments.requestPayPal(
                                    //     context, finalPrice(pror.price.toString(), 3));
                                    context
                                        .read<PaypalProvider>()
                                        .createPaypalPayment(
                                            getOrderParams(context,
                                                receiver:
                                                    wooCommerceMarketPlaceProvider
                                                        .receiver!),
                                            accessToken)
                                        .then((value) => Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    AppWebView(
                                                        checkoutUrl: value![
                                                            "approvalUrl"]!,
                                                        executeUrl: value[
                                                            "executeUrl"]!,
                                                        accessToken:
                                                            accessToken))));
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

  Color getColor(bool value) {
    Color? color = Colors.grey[200];
    if (value) {
      color = aliceBlue;
      return color;
    }
    return color!;
  }
}
