class Order {
  String? paymentMethod;
  String? paymentMethodTitle;
  bool? setPaid;
  Billing? billing;
  Shipping? shipping;
  List<LineItems>? lineItems;
  List<ShippingLines>? shippingLines;
  String? customerNote;

  Order(
      {this.paymentMethod,
      this.paymentMethodTitle,
      this.setPaid,
      this.billing,
      this.shipping,
      this.lineItems,
      this.shippingLines,
      this.customerNote});

  Order.fromJson(Map<String, dynamic> json) {
    paymentMethod = json['payment_method'];
    paymentMethodTitle = json['payment_method_title'];
    setPaid = json['set_paid'];
    billing =
        json['billing'] != null ? Billing.fromJson(json['billing']) : null;
    customerNote = json['customer_note'];
    shipping =
        json['shipping'] != null ? Shipping.fromJson(json['shipping']) : null;
    if (json['line_items'] != null) {
      lineItems = <LineItems>[];
      json['line_items'].forEach((v) {
        lineItems!.add(LineItems.fromJson(v));
      });
    }
    if (json['shipping_lines'] != null) {
      shippingLines = <ShippingLines>[];
      json['shipping_lines'].forEach((v) {
        shippingLines!.add(ShippingLines.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['payment_method'] = paymentMethod;
    data['payment_method_title'] = this.paymentMethodTitle;
    data['set_paid'] = setPaid;
    data['customer_note'] = customerNote;
    if (billing != null) {
      data['billing'] = billing!.toJson();
    }
    if (shipping != null) {
      data['shipping'] = this.shipping!.toJson();
    }
    if (lineItems != null) {
      data['line_items'] = lineItems!.map((v) => v.toJson()).toList();
    }
    if (this.shippingLines != null) {
      data['shipping_lines'] =
          this.shippingLines!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Billing {
  String? firstName;
  String? lastName;
  String? address1;
  String? address2;
  String? city;
  String? state;
  String? postcode;
  String? country;
  String? email;
  String? phone;

  Billing(
      {this.firstName,
      this.lastName,
      this.address1,
      this.address2,
      this.city,
      this.state,
      this.postcode,
      this.country,
      this.email,
      this.phone});

  Billing.fromJson(Map<String, dynamic> json) {
    firstName = json['first_name'];
    lastName = json['last_name'];
    address1 = json['address_1'];
    address2 = json['address_2'];
    city = json['city'];
    state = json['state'];
    postcode = json['postcode'];
    country = json['country'];
    email = json['email'];
    phone = json['phone'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['address_1'] = this.address1;
    data['address_2'] = this.address2;
    data['city'] = this.city;
    data['state'] = this.state;
    data['postcode'] = this.postcode;
    data['country'] = this.country;
    data['email'] = this.email;
    data['phone'] = this.phone;
    return data;
  }
}

class Shipping {
  String? firstName;
  String? lastName;
  String? address1;
  String? address2;
  String? city;
  String? state;
  String? postcode;
  String? country;
  String? phone;
  String? email;

  Shipping(
      {this.firstName,
      this.lastName,
      this.address1,
      this.address2,
      this.city,
      this.state,
      this.postcode,
      this.country,
      this.phone,
      this.email});

  Shipping.fromJson(Map<String, dynamic> json) {
    firstName = json['first_name'];
    lastName = json['last_name'];
    address1 = json['address_1'];
    address2 = json['address_2'];
    city = json['city'];
    state = json['state'];
    postcode = json['postcode'];
    country = json['country'];
    phone = json['phone'];
    email = json['shipping_email'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['address_1'] = this.address1;
    data['address_2'] = this.address2;
    data['city'] = this.city;
    data['state'] = this.state;
    data['postcode'] = this.postcode;
    data['country'] = this.country;
    data['shipping_email'] = this.email;
    data['phone'] = this.phone;
    return data;
  }
}

class LineItems {
  int? productId;
  int? quantity;
  int? variationId;

  LineItems({this.productId, this.quantity, this.variationId});

  LineItems.fromJson(Map<String, dynamic> json) {
    productId = json['product_id'];
    quantity = json['quantity'];
    variationId = json['variation_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['product_id'] = this.productId;
    data['quantity'] = this.quantity;
    data['variation_id'] = this.variationId;
    return data;
  }
}

class ShippingLines {
  String? methodId;
  String? methodTitle;
  String? total;

  ShippingLines({this.methodId, this.methodTitle, this.total});

  ShippingLines.fromJson(Map<String, dynamic> json) {
    methodId = json['method_id'];
    methodTitle = json['method_title'];
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['method_id'] = this.methodId;
    data['method_title'] = this.methodTitle;
    data['total'] = this.total;
    return data;
  }
}
