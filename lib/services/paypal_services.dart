import 'dart:async';
import 'dart:convert' as convert;

import 'package:dio/dio.dart';

class PaypalServices {
  late Dio _dio;

  String domain = "https://api.sandbox.paypal.com"; // for sandbox mode
  // String domain = "https://api.paypal.com"; // for production mode

  // change clientId and secret with your own, provided by paypal
  // String clientId =
  //     'AV4aSB3gKsN5lf8wbPbi2IlVt0G-MElTjHIlhIo0fvfqSyQNWzkqGKCiuMWtb49h_dzA0ayeVnCEk11f';
  // String secret =
  //     'EEYLpF4iDoBdIVjnRefvjzeeN7shf1GaCIUnLRGc_RYquD2As_2SxFmuMBUszVT70y7xK6_9_7zjHsEK';

  /// Sandbox
  String clientId =
      'AXIeQdhSTYIMLnyJWqllbjYmmiJWNAeDQ-kW2GUZ_PsNB-dnF2r1iNSr7hrlFD5sB-YqomHhyLIMKIRY';
  String secret =
      'EOo0ca0UCu7n5FhNUQunO6mlYNHwMDVlx6JsyBYn4YuPRKsTdNDiNJs_ONzHUfRnoJX9ClBDdMTmUXnr';

  // for getting the access token from Paypal
  Future<String?> getAccessToken() async {
    try {
      _dio = Dio(
        BaseOptions(
          baseUrl: domain,
          contentType: 'application/x-www-form-urlencoded',
          headers: {
            'authorization':
                'Basic ${convert.base64Encode(convert.utf8.encode('$clientId:$secret'))}',
          },
        ),
      );
      _dio.interceptors.add(
        LogInterceptor(responseBody: true),
      );
      var response = await _dio
          .post('$domain/v1/oauth2/token?grant_type=client_credentials');
      if (response.statusCode == 200) {
        final body = response.data;
        return body["access_token"];
      }
      return null;
    } catch (e) {
      rethrow;
    }
  }

  // for creating the payment request with Paypal
  Future<Map<String, String>?> createPaypalPayment(
      transactions, accessToken) async {
    try {
      var response = await _dio.post("$domain/v1/payments/payment",
          data: convert.jsonEncode(transactions),
          options: Options(headers: {
            "content-type": "application/json",
            'Authorization': 'Bearer ' + accessToken
          }));

      final body = response.data;
      if (response.statusCode == 201) {
        if (body["links"] != null && body["links"].length > 0) {
          List links = body["links"];

          String executeUrl = "";
          String approvalUrl = "";
          final item = links.firstWhere((o) => o["rel"] == "approval_url",
              orElse: () => null);
          if (item != null) {
            approvalUrl = item["href"];
          }
          final item1 = links.firstWhere((o) => o["rel"] == "execute",
              orElse: () => null);
          if (item1 != null) {
            executeUrl = item1["href"];
          }
          return {"executeUrl": executeUrl, "approvalUrl": approvalUrl};
        }
        return null;
      } else {
        throw Exception(body["message"]);
      }
    } catch (e) {
      rethrow;
    }
  }

  // for executing the payment transaction
  Future<String?> executePayment(url, payerId, accessToken) async {
    try {
      var response = await _dio.post(url,
          data: convert.jsonEncode({"payer_id": payerId}),
          options: Options(headers: {
            "content-type": "application/json",
            'Authorization': 'Bearer ' + accessToken
          }));

      final body = response.data;
      if (response.statusCode == 200) {
        return body["id"];
      }
      return null;
    } catch (e) {
      rethrow;
    }
  }
}
