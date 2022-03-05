import 'package:bono_gifts/models/wcmp_api/order.dart';
import 'package:bono_gifts/provider/paypal_provider.dart';
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
                  billing: Billing(),
                  lineItems: [
                    LineItems(),
                  ],
                  shippingLines: [
                    ShippingLines(),
                  ],
                  shipping: Shipping(),
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
