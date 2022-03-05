import 'package:bono_gifts/models/wcmp_api/order.dart';
import 'package:bono_gifts/provider/buy_provider.dart';
import 'package:bono_gifts/provider/paypal_provider.dart';
import 'package:bono_gifts/provider/sign_up_provider.dart';
import 'package:bono_gifts/provider/wcmp_provider.dart';
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
    final pro = Provider.of<SignUpProvider>(context);
    final pror = Provider.of<BuyProvider>(context);
    final wooCommerceMarketPlaceProvider =
        Provider.of<WooCommerceMarketPlaceProvider>(context);

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
                  .then((id) {
                Order order = Order(
                  setPaid: true,
                  paymentMethod: 'Paypal',
                  paymentMethodTitle: 'Paypal',
                  billing: Billing(
                    email: pro.email,
                    address1:
                        '${pro.street.text} ${pro.city.text} ${pro.country}',
                    address2: "",
                    postcode: "",
                    state: "",
                    city: pro.city.text,
                    country: pro.country,
                    firstName: pro.name,
                    lastName: pro.name,
                    phone: pro.phoneNumber.text,
                  ),
                  lineItems: [
                    LineItems(
                      quantity: 1,
                      variationId: 0,
                      productId: wooCommerceMarketPlaceProvider.id,
                    ),
                  ],
                  shippingLines: [
                    ShippingLines(
                      methodId: 'Paypal',
                      methodTitle: 'Paypal',
                      total: wooCommerceMarketPlaceProvider.price,
                    ),
                  ],
                  shipping: Shipping(
                      firstName: pror.userName,
                      lastName: pror.userName,
                      address1: pror.userAddress,
                      country: '',
                      state: '',
                      city: '',
                      address2: '',
                      postcode: ''),
                );
                paypalProvider.createOrder(order);
                Navigator.of(context).pop();
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
