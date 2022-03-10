import 'package:bono_gifts/models/product_models.dart';
import 'package:bono_gifts/models/user_model.dart';
import 'package:bono_gifts/models/wcmp_api/order.dart';
import 'package:bono_gifts/models/wcmp_api/order_response_model.dart';
import 'package:bono_gifts/models/wcmp_api/shipping_method_response.dart';
import 'package:bono_gifts/models/wcmp_api/vendor.dart';
import 'package:bono_gifts/models/wcmp_api/vendor_product.dart';
import 'package:bono_gifts/models/wcmp_api/zones_response.dart';
import 'package:bono_gifts/services/sign_up_service.dart';
import 'package:bono_gifts/services/wcmp_service.dart';
import 'package:flutter/material.dart';

enum ApiState {
  none,
  loading,
  completed,
  error,
}

class WooCommerceMarketPlaceProvider extends ChangeNotifier {
  final WooCommerceMarketPlaceService wooCommerceMarketPlaceService =
      WooCommerceMarketPlaceService();
  final SignUpService signUpService = SignUpService();

  ApiState apiState = ApiState.none;
  int? id;
  String? size;
  String? price;
  String? name;
  String? image;
  DateTime? dobFormat;
  String? dob;
  DateTime todayDate = DateTime.now();

  double deliveryPrice = 0.0;

  VendorProduct? selectedProduct;

  UserModel? receiver;
  UserModel? sender;

  List<Vendor> allVendors = <Vendor>[];
  List<Vendor> nearbyVendors = <Vendor>[];
  List<OrderResponseModel> allOrders = <OrderResponseModel>[];
  List<OrderResponseModel> receiverOrders = <OrderResponseModel>[];
  List<OrderResponseModel> senderOrders = <OrderResponseModel>[];

  List<Categories> categories = [];
  List<CategoriesShow> categoriesshow = [];
  List<VendorProduct> nearbyVendorProducts = <VendorProduct>[];
  setDOB(String dobb, DateTime date) {
    dob = dobb;
    dobFormat = date;
    notifyListeners();
  }

  Future<void> fetchVendors(String city) async {
    clearShops();
    apiState = ApiState.loading;
    try {
      allVendors = await wooCommerceMarketPlaceService.getAllVendors();
      nearbyVendors = allVendors.where((element) {
        print(element.address?.city);

        return element.address?.city!.trim().toLowerCase() ==
            city.trim().toLowerCase();
      }).toList();
      for (Vendor vendor in nearbyVendors) {
        List<VendorProduct> nearbyProducts =
            await wooCommerceMarketPlaceService.getVendorProducts(vendor.id!);
        nearbyVendorProducts.addAll(nearbyProducts);
      }
      for (VendorProduct product in nearbyVendorProducts) {
        if (product.categories != null) {
          bool found = false;
          print('Product Category Name ' +
              product.categories!.first.name.toString());

          for (Categories category in categories) {
            print('Category Name ' + category.name.toString());
            if (category.name ==
                product.categories![product.categories!.length - 1].name) {
              found = true;
              break;
            }
          }
          if (!found) {
            categories.add(product.categories![product.categories!.length - 1]);
            categoriesshow.add(CategoriesShow(
                isSelected: false,
                name: product.categories![product.categories!.length - 1].name,
                id: product.categories![product.categories!.length - 1].id,
                slug:
                    product.categories![product.categories!.length - 1].slug));
          }
        }
      }
      apiState = ApiState.completed;
    } catch (e) {
      apiState = ApiState.error;

      print(e.toString());
    }
    notifyListeners();
  }

  List<VendorProduct> filterByCategory(Categories category) {
    return nearbyVendorProducts
        .where((element) =>
            element.categories![element.categories!.length - 1].name ==
            category.name)
        .toList();
  }

  Future<Map<String, dynamic>> getUserInfo(String phone) async {
    return await signUpService.getUser(phone);
  }

  selectVendor(VendorProduct product) {
    selectedProduct = product;
    notifyListeners();
  }

  clearShops() {
    nearbyVendors.clear();
    categories.clear();
    categoriesshow.clear();
    allVendors.clear();
    nearbyVendorProducts.clear();
    notifyListeners();
  }

  int finalPrice() {
    final int actualPrice = int.parse(selectedProduct!.price!);
    final int totalPrice = actualPrice + deliveryPrice.toInt();
    return totalPrice;
  }

  selectReceiver(UserModel receiver) {
    print("Receiver assign ${receiver.toMap().toString()}");
    this.receiver = receiver;
    calculateTax(receiver.country).then((value) => deliveryPrice = value);
    notifyListeners();
  }

  selectSender(UserModel sender) {
    this.sender = sender;
    notifyListeners();
  }

  Future<OrderResponseModel?> createOrder(Order order) async {
    apiState = ApiState.loading;
    try {
      OrderResponseModel? orderResponseModel =
          await wooCommerceMarketPlaceService.createOrder(order);

      apiState = ApiState.completed;
      return orderResponseModel;
    } catch (e) {
      apiState = ApiState.error;

      print(e.toString());
    }
    notifyListeners();
  }

  Future<void> fetchOrders(String senderPhone) async {
    allOrders.clear();
    receiverOrders.clear();
    senderOrders.clear();

    apiState = ApiState.loading;
    try {
      List<OrderResponseModel> orders =
          await wooCommerceMarketPlaceService.getAllOrders();
      for (OrderResponseModel order in orders) {
        if (order.billing?.phone == senderPhone) {
          allOrders.add(order);
        } else if (order.billing?.phone == senderPhone) {
          senderOrders.add(order);
        }
      }
      apiState = ApiState.completed;
    } catch (e) {
      apiState = ApiState.error;

      print(e.toString());
    }
    notifyListeners();
  }

  Future<double> calculateTax(String country) async {
    apiState = ApiState.loading;

    try {
      List<ZoneResponse> zones =
          await wooCommerceMarketPlaceService.getAllZones();
      for (ZoneResponse zone in zones) {
        if (zone.name!.toLowerCase().trim() == country.toLowerCase().trim()) {
          List<ShippingMethodResponse> shippingMethods =
              await wooCommerceMarketPlaceService
                  .getAllShippingMethods(zone.id!);
          return double.parse(shippingMethods.first.settings!.cost!.value!);
        }
      }
      apiState = ApiState.completed;

      return 0.0;
    } catch (e) {
      apiState = ApiState.error;

      print(e.toString());
    }
    notifyListeners();
    return 0.0;
  }
}
