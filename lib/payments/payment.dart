import 'package:flutter/material.dart';
import 'package:flutter_braintree/flutter_braintree.dart';

class Payments {
  static const _token = 'sandbox_24wj54xr_ksdtm8mhg9mrf6tk';
  static const _currency = 'USD';

  static requestPayPal(context, price) async {
    var request = BraintreeDropInRequest(
      tokenizationKey: _token,
      collectDeviceData: true,
      paypalRequest: BraintreePayPalRequest(
        amount: price.toString(),
        displayName: 'Bono',
      ),
      cardEnabled: true,
    );
    final result = await BraintreeDropIn.start(request);
    if (result != null) {
      showNonce(result.paymentMethodNonce, context);
    }
  }

  static launchPayPal() async {
    final request = BraintreePayPalRequest(amount: '13.37');
    final result = await Braintree.requestPaypalNonce(
      _token,
      request,
    );
    if (result != null) {
      print('this is paypal result ------- $result');
    }
  }

  static requestGooglePay(context, price) async {
    var request = BraintreeDropInRequest(
      tokenizationKey: _token,
      collectDeviceData: true,
      googlePaymentRequest: BraintreeGooglePaymentRequest(
        totalPrice: price,
        currencyCode: 'USD',
        billingAddressRequired: false,
      ),
      cardEnabled: true,
    );
    final result = await BraintreeDropIn.start(request);
    if (result != null) {
      showNonce(result.paymentMethodNonce, context);
    }
  }

  static void showNonce(BraintreePaymentMethodNonce nonce, context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Payment method nonce:'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text('Nonce: ${nonce.nonce}'),
            SizedBox(height: 16),
            Text('Type label: ${nonce.typeLabel}'),
            SizedBox(height: 16),
            Text('Description: ${nonce.description}'),
          ],
        ),
      ),
    );
  }

  payWithPayPal(payment) async {
    final cardRequest = BraintreeCreditCardRequest(
        cardNumber: '4111 1111 1111 1111',
        cvv: '234',
        expirationMonth: '10',
        expirationYear: '25');

    BraintreePaymentMethodNonce? result =
        await Braintree.tokenizeCreditCard(_token, cardRequest);

    final paymentRequest = BraintreePayPalRequest(amount: '50.00');

    BraintreePaymentMethodNonce? requestResult =
        await Braintree.requestPaypalNonce(
      _token,
      paymentRequest,
    );

    print('this is request result' + requestResult.toString());
  }
}
