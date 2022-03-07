class PaypalOrderModel {
  String? intent;
  Payer? payer;
  List<Transactions>? transactions;
  String? noteToPayer;
  RedirectUrls? redirectUrls;

  PaypalOrderModel(
      {this.intent,
      this.payer,
      this.transactions,
      this.noteToPayer,
      this.redirectUrls});

  PaypalOrderModel.fromJson(Map<String, dynamic> json) {
    intent = json['intent'];
    payer = json['payer'] != null ? new Payer.fromJson(json['payer']) : null;
    if (json['transactions'] != null) {
      transactions = <Transactions>[];
      json['transactions'].forEach((v) {
        transactions!.add(new Transactions.fromJson(v));
      });
    }
    noteToPayer = json['note_to_payer'];
    redirectUrls = json['redirect_urls'] != null
        ? new RedirectUrls.fromJson(json['redirect_urls'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['intent'] = this.intent;
    if (this.payer != null) {
      data['payer'] = this.payer!.toJson();
    }
    if (this.transactions != null) {
      data['transactions'] = this.transactions!.map((v) => v.toJson()).toList();
    }
    data['note_to_payer'] = this.noteToPayer;
    if (this.redirectUrls != null) {
      data['redirect_urls'] = this.redirectUrls!.toJson();
    }
    return data;
  }
}

class Payer {
  String? paymentMethod;

  Payer({this.paymentMethod});

  Payer.fromJson(Map<String, dynamic> json) {
    paymentMethod = json['payment_method'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['payment_method'] = this.paymentMethod;
    return data;
  }
}

class Transactions {
  Amount? amount;
  String? description;
  String? custom;
  String? invoiceNumber;
  PaymentOptions? paymentOptions;
  String? softDescriptor;
  ItemList? itemList;

  Transactions(
      {this.amount,
      this.description,
      this.custom,
      this.invoiceNumber,
      this.paymentOptions,
      this.softDescriptor,
      this.itemList});

  Transactions.fromJson(Map<String, dynamic> json) {
    amount =
        json['amount'] != null ? new Amount.fromJson(json['amount']) : null;
    description = json['description'];
    custom = json['custom'];
    invoiceNumber = json['invoice_number'];
    paymentOptions = json['payment_options'] != null
        ? new PaymentOptions.fromJson(json['payment_options'])
        : null;
    softDescriptor = json['soft_descriptor'];
    itemList = json['item_list'] != null
        ? new ItemList.fromJson(json['item_list'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.amount != null) {
      data['amount'] = this.amount!.toJson();
    }
    data['description'] = this.description;
    data['custom'] = this.custom;
    data['invoice_number'] = this.invoiceNumber;
    if (this.paymentOptions != null) {
      data['payment_options'] = this.paymentOptions!.toJson();
    }
    data['soft_descriptor'] = this.softDescriptor;
    if (this.itemList != null) {
      data['item_list'] = this.itemList!.toJson();
    }
    return data;
  }
}

class Amount {
  String? total;
  String? currency;
  Details? details;

  Amount({this.total, this.currency, this.details});

  Amount.fromJson(Map<String, dynamic> json) {
    total = json['total'];
    currency = json['currency'];
    details =
        json['details'] != null ? new Details.fromJson(json['details']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['total'] = this.total;
    data['currency'] = this.currency;
    if (this.details != null) {
      data['details'] = this.details!.toJson();
    }
    return data;
  }
}

class Details {
  String? subtotal;
  String? tax;
  String? shipping;
  String? handlingFee;
  String? shippingDiscount;
  String? insurance;

  Details(
      {this.subtotal,
      this.tax,
      this.shipping,
      this.handlingFee,
      this.shippingDiscount,
      this.insurance});

  Details.fromJson(Map<String, dynamic> json) {
    subtotal = json['subtotal'];
    tax = json['tax'];
    shipping = json['shipping'];
    handlingFee = json['handling_fee'];
    shippingDiscount = json['shipping_discount'];
    insurance = json['insurance'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['subtotal'] = this.subtotal;
    data['tax'] = this.tax;
    data['shipping'] = this.shipping;
    data['handling_fee'] = this.handlingFee;
    data['shipping_discount'] = this.shippingDiscount;
    data['insurance'] = this.insurance;
    return data;
  }
}

class PaymentOptions {
  String? allowedPaymentMethod;

  PaymentOptions({this.allowedPaymentMethod});

  PaymentOptions.fromJson(Map<String, dynamic> json) {
    allowedPaymentMethod = json['allowed_payment_method'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['allowed_payment_method'] = this.allowedPaymentMethod;
    return data;
  }
}

class ItemList {
  List<Items>? items;
  ShippingAddress? shippingAddress;

  ItemList({this.items, this.shippingAddress});

  ItemList.fromJson(Map<String, dynamic> json) {
    if (json['items'] != null) {
      items = <Items>[];
      json['items'].forEach((v) {
        items!.add(new Items.fromJson(v));
      });
    }
    shippingAddress = json['shipping_address'] != null
        ? new ShippingAddress.fromJson(json['shipping_address'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.items != null) {
      data['items'] = this.items!.map((v) => v.toJson()).toList();
    }
    if (this.shippingAddress != null) {
      data['shipping_address'] = this.shippingAddress!.toJson();
    }
    return data;
  }
}

class Items {
  String? name;
  String? description;
  String? quantity;
  String? price;
  String? tax;
  String? sku;
  String? currency;

  Items(
      {this.name,
      this.description,
      this.quantity,
      this.price,
      this.tax,
      this.sku,
      this.currency});

  Items.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    description = json['description'];
    quantity = json['quantity'];
    price = json['price'];
    tax = json['tax'];
    sku = json['sku'];
    currency = json['currency'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['description'] = this.description;
    data['quantity'] = this.quantity;
    data['price'] = this.price;
    data['tax'] = this.tax;
    data['sku'] = this.sku;
    data['currency'] = this.currency;
    return data;
  }
}

class ShippingAddress {
  String? recipientName;
  String? line1;
  String? line2;
  String? city;
  String? countryCode;
  String? postalCode;
  String? phone;
  String? state;

  ShippingAddress(
      {this.recipientName,
      this.line1,
      this.line2,
      this.city,
      this.countryCode,
      this.postalCode,
      this.phone,
      this.state});

  ShippingAddress.fromJson(Map<String, dynamic> json) {
    recipientName = json['recipient_name'];
    line1 = json['line1'];
    line2 = json['line2'];
    city = json['city'];
    countryCode = json['country_code'];
    postalCode = json['postal_code'];
    phone = json['phone'];
    state = json['state'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['recipient_name'] = this.recipientName;
    data['line1'] = this.line1;
    data['line2'] = this.line2;
    data['city'] = this.city;
    data['country_code'] = this.countryCode;
    data['postal_code'] = this.postalCode;
    data['phone'] = this.phone;
    data['state'] = this.state;
    return data;
  }
}

class RedirectUrls {
  String? returnUrl;
  String? cancelUrl;

  RedirectUrls({this.returnUrl, this.cancelUrl});

  RedirectUrls.fromJson(Map<String, dynamic> json) {
    returnUrl = json['return_url'];
    cancelUrl = json['cancel_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['return_url'] = this.returnUrl;
    data['cancel_url'] = this.cancelUrl;
    return data;
  }
}
