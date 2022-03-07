import 'package:bono_gifts/services/paypal_services.dart';
import 'package:bono_gifts/services/wcmp_service.dart';
import 'package:flutter/material.dart';

class PaypalProvider with ChangeNotifier {
  final PaypalServices _paypalServices = PaypalServices();
  final WooCommerceMarketPlaceService wooCommerceMarketPlaceService =
      WooCommerceMarketPlaceService();

  init() {
    return _paypalServices.getAccessToken();
  }

  Future<Map<String, String>?> createPaypalPayment(
      transactions, accessToken) async {
    return _paypalServices.createPaypalPayment(transactions, accessToken);
  }

  Future<String?> executePayment(url, payerId, accessToken) async {
    return _paypalServices.executePayment(url, payerId, accessToken);
  }
}
