import 'package:bono_gifts/main.dart';
import 'package:bono_gifts/models/user_model.dart';
import 'package:bono_gifts/models/wcmp_api/order.dart';
import 'package:bono_gifts/models/wcmp_api/order_response_model.dart'
    as response;
import 'package:bono_gifts/models/wcmp_api/vendor_product.dart';
import 'package:bono_gifts/provider/buy_provider.dart';
import 'package:bono_gifts/provider/paypal_provider.dart';
import 'package:bono_gifts/provider/sign_up_provider.dart';
import 'package:bono_gifts/provider/wcmp_provider.dart';
import 'package:bono_gifts/views/bottom_nav_bar.dart';
import 'package:bono_gifts/views/gift/controller/history_controller.dart';
import 'package:bono_gifts/views/gift/model/history_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';

class AppWebView extends StatefulWidget {
  const AppWebView(
      {Key? key,
      required this.checkoutUrl,
      required this.executeUrl,
      required this.accessToken})
      : super(key: key);
  final String checkoutUrl;
  final String executeUrl;
  final String accessToken;

  @override
  _AppWebViewState createState() => _AppWebViewState();
}

class _AppWebViewState extends State<AppWebView> {
  String returnURL = 'return.example.com';
  String cancelURL = 'cancel.example.com';

  @override
  Widget build(BuildContext context) {
    final PaypalProvider paypalProvider = Provider.of<PaypalProvider>(context);
    final SignUpProvider signUpProvider = Provider.of<SignUpProvider>(context);
    final WooCommerceMarketPlaceProvider wooCommerceMarketPlaceProvider =
        Provider.of<WooCommerceMarketPlaceProvider>(context);
    final HistoryProvider historyProvider =
        Provider.of<HistoryProvider>(context);
    final BuyProvider buyProvider = Provider.of<BuyProvider>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).backgroundColor,
        leading: GestureDetector(
          child: const Icon(Icons.arrow_back_ios),
          onTap: () => Navigator.pop(context),
        ),
      ),
      body: WebView(
        initialUrl: widget.checkoutUrl,
        javascriptMode: JavascriptMode.unrestricted,
        navigationDelegate: (NavigationRequest request) {
          if (request.url.contains(returnURL)) {
            final uri = Uri.parse(request.url);
            final payerID = uri.queryParameters['PayerID'];
            if (payerID != null) {
              paypalProvider
                  .executePayment(
                      widget.executeUrl, payerID, widget.accessToken)
                  .then((id) async {
                UserModel receiver = wooCommerceMarketPlaceProvider.receiver!;

                VendorProduct product =
                    wooCommerceMarketPlaceProvider.selectedProduct!;

                Order order = Order(
                  setPaid: true,
                  paymentMethod: 'Paypal',
                  paymentMethodTitle: 'Paypal',
                  customerNote: buyProvider.noteController.text,
                  billing: Billing(
                    email: signUpProvider.email,
                    address1:
                        '${signUpProvider.room.text} ${signUpProvider.buildingName.text} ${signUpProvider.street.text} ${signUpProvider.area.text} ${signUpProvider.city.text} ${signUpProvider.country}',
                    address2: "",
                    postcode: "",
                    state: "",
                    city: signUpProvider.city.text,
                    country: signUpProvider.country,
                    firstName: signUpProvider.name.split(' ').first,
                    lastName: signUpProvider.name.split(' ').last,
                    phone: signUpProvider.phoneNumber.text,
                  ),
                  lineItems: [
                    LineItems(
                      quantity: 1,
                      variationId: 0,
                      productId: product.id,
                    ),
                  ],
                  shippingLines: [
                    ShippingLines(
                      methodId: 'Delivery',
                      methodTitle: 'Delivery',
                      total: wooCommerceMarketPlaceProvider.deliveryPrice
                          .toString(),
                    ),
                  ],
                  shipping: Shipping(
                    firstName: receiver.name.split(' ').first,
                    lastName: receiver.name.split(' ').last,
                    address1:
                        '${receiver.villa} ${receiver.buildingName} ${receiver.street} ${receiver.area} ${receiver.city} ${receiver.country}',
                    country: receiver.country,
                    state: '',
                    city: receiver.city,
                    address2: '',
                    postcode: '',
                    phone: receiver.phoneNumber,
                    email: receiver.email,
                  ),
                );

                response.OrderResponseModel? result =
                    await wooCommerceMarketPlaceProvider.createOrder(order);

                print('Result ${result?.toJson().toString()}');

                HistoryModel historyModel = HistoryModel(
                    id: result?.id,
                    date: Timestamp.now(),
                    price:
                        wooCommerceMarketPlaceProvider.finalPrice().toDouble(),
                    status: 'processing',
                    senderNumber: signUpProvider.phoneNumber.text,
                    senderName: signUpProvider.name,
                    receiverNumber: receiver.phoneNumber,
                    receiverName: receiver.name,
                    receiverImage: receiver.profileUrl,
                    giftImage: product.images!.first.src!,
                    senderImage: signUpProvider.userImage);
                await historyProvider.addOrderHistory(historyModel);
                historyProvider.index = 2;
                Navigator.pushAndRemoveUntil(
                    navigatorKey.currentContext!,
                    MaterialPageRoute(
                        builder: (context) => const BottomNavBar(
                              index: 1,
                            )),
                    (route) => route.isFirst);
              });
            } else {
              Navigator.of(context).pop();
            }
            Navigator.of(context).pop();
          }
          if (request.url.contains(cancelURL)) {
            Navigator.of(context).pop();
          }
          return NavigationDecision.navigate;
        },
      ),
    );
  }
}
