import 'dart:convert';

import 'package:bono_gifts/models/wcmp_api/vendor.dart';
import 'package:bono_gifts/models/wcmp_api/vendor_product.dart';
import 'package:dio/dio.dart';

class WooCommerceMarketPlaceService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'https://www.giftbono.com',
      contentType: 'application/json',
      headers: {
        'authorization':
            'Basic ${base64Encode(utf8.encode('ck_542ab1805cfc5701ef7abdc54de9650bf59ede78:cs_fa172cd7845d961d251e6b41c2db37c4d8aab9ae'))}',
      },
    ),
  );

  WooCommerceMarketPlaceService() {
    _dio.interceptors.add(
      LogInterceptor(responseBody: true),
    );
  }

  Future<List<Vendor>> getAllVendors() async {
    return _dio.get('/wp-json/wcmp/v1/vendors').then((value) {
      if (value.statusCode == 200) {
        List<Vendor> vendors = [];
        if (value.data != null) {
          value.data.forEach((v) {
            vendors.add(Vendor.fromJson(v));
          });
        }
        return vendors;
      } else {
        return [];
      }
    }, onError: (error) {
      print(error.toString());
      return [];
    });
  }

  Future<List<VendorProduct>> getVendorProducts(int id) async {
    return _dio.get('/wp-json/wc/v2/products/?vendor=$id').then((value) {
      if (value.statusCode == 200) {
        List<VendorProduct> vendorProducts = [];
        if (value.data != null) {
          value.data.forEach((v) {
            vendorProducts.add(VendorProduct.fromJson(v));
          });
        }
        return vendorProducts;
      } else {
        return <VendorProduct>[];
      }
    }, onError: (error) {
      return <VendorProduct>[];
    });
  }
}
