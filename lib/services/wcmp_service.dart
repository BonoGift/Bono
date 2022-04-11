import 'dart:convert';

import 'package:bono_gifts/models/wcmp_api/order.dart';
import 'package:bono_gifts/models/wcmp_api/order_response_model.dart';
import 'package:bono_gifts/models/wcmp_api/shipping_location_response.dart';
import 'package:bono_gifts/models/wcmp_api/shipping_method_response.dart';
import 'package:bono_gifts/models/wcmp_api/vendor.dart';
import 'package:bono_gifts/models/wcmp_api/vendor_product.dart';
import 'package:bono_gifts/models/wcmp_api/zones_response.dart';
import 'package:dio/dio.dart';

class WooCommerceMarketPlaceService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'https://www.giftbono.com',
      contentType: 'application/json',
      headers: {
        'authorization':
            'Basic ${base64Encode(utf8.encode('ck_b7380eae008aeb8dc81dce2fc5378c58866fbc5b:cs_1e58611ffbecf461f78bf5dcf0b1d252493fc999'))}',
      },
    ),
  );

  WooCommerceMarketPlaceService() {
    _dio.interceptors.add(
      LogInterceptor(responseBody: true),
    );
  }

  Future<List<Vendor>> getAllVendors() async {
    return _dio.get('/wp-json/wcmp/v1/vendors?per_page=100').then((value) {
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
    return _dio.get('/wp-json/wc/v2/products/?vendor=$id&per_page=100').then(
        (value) {
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

  Future<OrderResponseModel?> createOrder(Order order) async {
    return _dio.post('/wp-json/wc/v3/orders', data: order.toJson()).then(
        (value) {
      if (value.statusCode == 201) {
        if (value.data != null) {
          return OrderResponseModel.fromJson(value.data);
        }
      } else {
        return null;
      }
    }, onError: (error) {
      return null;
    });
  }

  Future<List<OrderResponseModel>> getAllOrders() async {
    return _dio.get('/wp-json/wc/v3/orders').then((value) {
      if (value.statusCode == 200) {
        List<OrderResponseModel> orders = [];
        if (value.data != null) {
          value.data.forEach((v) {
            orders.add(OrderResponseModel.fromJson(v));
          });
        }
        return orders;
      } else {
        return [];
      }
    }, onError: (error) {
      print(error.toString());
      return [];
    });
  }

  Future<List<ZoneResponse>> getAllZones() async {
    return _dio.get('/wp-json/wc/v3/shipping/zones').then((value) {
      if (value.statusCode == 200) {
        List<ZoneResponse> zones = [];
        if (value.data != null) {
          value.data.forEach((v) {
            zones.add(ZoneResponse.fromJson(v));
          });
        }
        return zones;
      } else {
        return [];
      }
    }, onError: (error) {
      print(error.toString());
      return [];
    });
  }

  Future<List<ShippingLocationResponse>> getShippingLocation(int id) async {
    return _dio.get('/wp-json/wc/v3/shipping/zones/$id/locations').then(
        (value) {
      if (value.statusCode == 200) {
        List<ShippingLocationResponse> shippingLocations = [];
        if (value.data != null) {
          value.data.forEach((v) {
            shippingLocations.add(ShippingLocationResponse.fromJson(v));
          });
        }
        return shippingLocations;
      } else {
        return [];
      }
    }, onError: (error) {
      print(error.toString());
      return [];
    });
  }

  Future<List<ShippingMethodResponse>> getAllShippingMethods(int id) async {
    return _dio.get('/wp-json/wc/v3/shipping/zones/$id/methods').then((value) {
      if (value.statusCode == 200) {
        List<ShippingMethodResponse> shippingMethods = [];
        if (value.data != null) {
          value.data.forEach((v) {
            shippingMethods.add(ShippingMethodResponse.fromJson(v));
          });
        }
        return shippingMethods;
      } else {
        return [];
      }
    }, onError: (error) {
      print(error.toString());
      return [];
    });
  }
}
