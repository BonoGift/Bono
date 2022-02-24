class Vendor {
  int? id;
  String? login;
  String? firstName;
  String? lastName;
  String? niceName;
  String? displayName;
  String? email;
  String? url;
  String? registered;
  String? status;
  List<String>? roles;
  Allcaps? allcaps;
  String? timezoneString;
  String? gmtOffset;
  Shop? shop;
  Address? address;
  Social? social;
  Payment? payment;
  String? messageToBuyers;
  int? review;
  Links? lLinks;

  Vendor(
      {this.id,
      this.login,
      this.firstName,
      this.lastName,
      this.niceName,
      this.displayName,
      this.email,
      this.url,
      this.registered,
      this.status,
      this.roles,
      this.allcaps,
      this.timezoneString,
      this.gmtOffset,
      this.shop,
      this.address,
      this.social,
      this.payment,
      this.messageToBuyers,
      this.review,
      this.lLinks});

  Vendor.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    login = json['login'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    niceName = json['nice_name'];
    displayName = json['display_name'];
    email = json['email'];
    url = json['url'];
    registered = json['registered'];
    status = json['status'];
    roles = json['roles'].cast<String>();
    allcaps =
        json['allcaps'] != null ? new Allcaps.fromJson(json['allcaps']) : null;
    timezoneString = json['timezone_string'];
    gmtOffset = json['gmt_offset'];
    shop = json['shop'] != null ? new Shop.fromJson(json['shop']) : null;
    address =
        json['address'] != null ? new Address.fromJson(json['address']) : null;
    social =
        json['social'] != null ? new Social.fromJson(json['social']) : null;
    payment =
        json['payment'] != null ? new Payment.fromJson(json['payment']) : null;
    messageToBuyers = json['message_to_buyers'];
    review = json['review'];
    lLinks = json['_links'] != null ? new Links.fromJson(json['_links']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['login'] = this.login;
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['nice_name'] = this.niceName;
    data['display_name'] = this.displayName;
    data['email'] = this.email;
    data['url'] = this.url;
    data['registered'] = this.registered;
    data['status'] = this.status;
    data['roles'] = this.roles;
    if (this.allcaps != null) {
      data['allcaps'] = this.allcaps!.toJson();
    }
    data['timezone_string'] = this.timezoneString;
    data['gmt_offset'] = this.gmtOffset;
    if (this.shop != null) {
      data['shop'] = this.shop!.toJson();
    }
    if (this.address != null) {
      data['address'] = this.address!.toJson();
    }
    if (this.social != null) {
      data['social'] = this.social!.toJson();
    }
    if (this.payment != null) {
      data['payment'] = this.payment!.toJson();
    }
    data['message_to_buyers'] = this.messageToBuyers;
    data['review'] = this.review;
    if (this.lLinks != null) {
      data['_links'] = this.lLinks!.toJson();
    }
    return data;
  }
}

class Allcaps {
  bool? read;
  bool? manageProduct;
  bool? editPosts;
  bool? deletePosts;
  bool? viewWoocommerceReports;
  bool? assignProductTerms;
  bool? uploadFiles;
  bool? readProduct;
  bool? readShopCoupon;
  bool? editProduct;
  bool? deleteProduct;
  bool? editProducts;
  bool? deleteProducts;
  bool? publishProducts;
  bool? editPublishedProducts;
  bool? deletePublishedProducts;
  bool? editShopCoupon;
  bool? editShopCoupons;
  bool? deleteShopCoupon;
  bool? deleteShopCoupons;
  bool? publishShopCoupons;
  bool? editPublishedShopCoupons;
  bool? deletePublishedShopCoupons;
  bool? vendorImportCapability;
  bool? vendorExportCapability;
  bool? dcVendor;

  Allcaps(
      {this.read,
      this.manageProduct,
      this.editPosts,
      this.deletePosts,
      this.viewWoocommerceReports,
      this.assignProductTerms,
      this.uploadFiles,
      this.readProduct,
      this.readShopCoupon,
      this.editProduct,
      this.deleteProduct,
      this.editProducts,
      this.deleteProducts,
      this.publishProducts,
      this.editPublishedProducts,
      this.deletePublishedProducts,
      this.editShopCoupon,
      this.editShopCoupons,
      this.deleteShopCoupon,
      this.deleteShopCoupons,
      this.publishShopCoupons,
      this.editPublishedShopCoupons,
      this.deletePublishedShopCoupons,
      this.vendorImportCapability,
      this.vendorExportCapability,
      this.dcVendor});

  Allcaps.fromJson(Map<String, dynamic> json) {
    read = json['read'];
    manageProduct = json['manage_product'];
    editPosts = json['edit_posts'];
    deletePosts = json['delete_posts'];
    viewWoocommerceReports = json['view_woocommerce_reports'];
    assignProductTerms = json['assign_product_terms'];
    uploadFiles = json['upload_files'];
    readProduct = json['read_product'];
    readShopCoupon = json['read_shop_coupon'];
    editProduct = json['edit_product'];
    deleteProduct = json['delete_product'];
    editProducts = json['edit_products'];
    deleteProducts = json['delete_products'];
    publishProducts = json['publish_products'];
    editPublishedProducts = json['edit_published_products'];
    deletePublishedProducts = json['delete_published_products'];
    editShopCoupon = json['edit_shop_coupon'];
    editShopCoupons = json['edit_shop_coupons'];
    deleteShopCoupon = json['delete_shop_coupon'];
    deleteShopCoupons = json['delete_shop_coupons'];
    publishShopCoupons = json['publish_shop_coupons'];
    editPublishedShopCoupons = json['edit_published_shop_coupons'];
    deletePublishedShopCoupons = json['delete_published_shop_coupons'];
    vendorImportCapability = json['vendor_import_capability'];
    vendorExportCapability = json['vendor_export_capability'];
    dcVendor = json['dc_vendor'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['read'] = this.read;
    data['manage_product'] = this.manageProduct;
    data['edit_posts'] = this.editPosts;
    data['delete_posts'] = this.deletePosts;
    data['view_woocommerce_reports'] = this.viewWoocommerceReports;
    data['assign_product_terms'] = this.assignProductTerms;
    data['upload_files'] = this.uploadFiles;
    data['read_product'] = this.readProduct;
    data['read_shop_coupon'] = this.readShopCoupon;
    data['edit_product'] = this.editProduct;
    data['delete_product'] = this.deleteProduct;
    data['edit_products'] = this.editProducts;
    data['delete_products'] = this.deleteProducts;
    data['publish_products'] = this.publishProducts;
    data['edit_published_products'] = this.editPublishedProducts;
    data['delete_published_products'] = this.deletePublishedProducts;
    data['edit_shop_coupon'] = this.editShopCoupon;
    data['edit_shop_coupons'] = this.editShopCoupons;
    data['delete_shop_coupon'] = this.deleteShopCoupon;
    data['delete_shop_coupons'] = this.deleteShopCoupons;
    data['publish_shop_coupons'] = this.publishShopCoupons;
    data['edit_published_shop_coupons'] = this.editPublishedShopCoupons;
    data['delete_published_shop_coupons'] = this.deletePublishedShopCoupons;
    data['vendor_import_capability'] = this.vendorImportCapability;
    data['vendor_export_capability'] = this.vendorExportCapability;
    data['dc_vendor'] = this.dcVendor;
    return data;
  }
}

class Shop {
  String? url;
  String? title;
  String? slug;
  String? description;
  String? image;
  String? banner;

  Shop(
      {this.url,
      this.title,
      this.slug,
      this.description,
      this.image,
      this.banner});

  Shop.fromJson(Map<String, dynamic> json) {
    url = json['url'];
    title = json['title'];
    slug = json['slug'];
    description = json['description'];
    image = json['image'];
    banner = json['banner'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['url'] = this.url;
    data['title'] = this.title;
    data['slug'] = this.slug;
    data['description'] = this.description;
    data['image'] = this.image;
    data['banner'] = this.banner;
    return data;
  }
}

class Address {
  String? address1;
  String? address2;
  String? city;
  String? state;
  String? country;
  String? postcode;
  String? phone;

  Address(
      {this.address1,
      this.address2,
      this.city,
      this.state,
      this.country,
      this.postcode,
      this.phone});

  Address.fromJson(Map<String, dynamic> json) {
    address1 = json['address_1'];
    address2 = json['address_2'];
    city = json['city'];
    state = json['state'];
    country = json['country'];
    postcode = json['postcode'];
    phone = json['phone'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['address_1'] = this.address1;
    data['address_2'] = this.address2;
    data['city'] = this.city;
    data['state'] = this.state;
    data['country'] = this.country;
    data['postcode'] = this.postcode;
    data['phone'] = this.phone;
    return data;
  }
}

class Social {
  String? facebook;
  String? twitter;
  String? googlePlus;
  String? linkdin;
  String? youtube;
  String? instagram;

  Social(
      {this.facebook,
      this.twitter,
      this.googlePlus,
      this.linkdin,
      this.youtube,
      this.instagram});

  Social.fromJson(Map<String, dynamic> json) {
    facebook = json['facebook'];
    twitter = json['twitter'];
    googlePlus = json['google_plus'];
    linkdin = json['linkdin'];
    youtube = json['youtube'];
    instagram = json['instagram'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['facebook'] = this.facebook;
    data['twitter'] = this.twitter;
    data['google_plus'] = this.googlePlus;
    data['linkdin'] = this.linkdin;
    data['youtube'] = this.youtube;
    data['instagram'] = this.instagram;
    return data;
  }
}

class Payment {
  String? paymentMode;
  String? bankAccountType;
  String? bankName;
  String? bankAccountNumber;
  String? bankAddress;
  String? accountHolderName;
  String? abaRoutingNumber;
  String? destinationCurrency;
  String? iban;
  String? paypalEmail;

  Payment(
      {this.paymentMode,
      this.bankAccountType,
      this.bankName,
      this.bankAccountNumber,
      this.bankAddress,
      this.accountHolderName,
      this.abaRoutingNumber,
      this.destinationCurrency,
      this.iban,
      this.paypalEmail});

  Payment.fromJson(Map<String, dynamic> json) {
    paymentMode = json['payment_mode'];
    bankAccountType = json['bank_account_type'];
    bankName = json['bank_name'];
    bankAccountNumber = json['bank_account_number'];
    bankAddress = json['bank_address'];
    accountHolderName = json['account_holder_name'];
    abaRoutingNumber = json['aba_routing_number'];
    destinationCurrency = json['destination_currency'];
    iban = json['iban'];
    paypalEmail = json['paypal_email'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['payment_mode'] = this.paymentMode;
    data['bank_account_type'] = this.bankAccountType;
    data['bank_name'] = this.bankName;
    data['bank_account_number'] = this.bankAccountNumber;
    data['bank_address'] = this.bankAddress;
    data['account_holder_name'] = this.accountHolderName;
    data['aba_routing_number'] = this.abaRoutingNumber;
    data['destination_currency'] = this.destinationCurrency;
    data['iban'] = this.iban;
    data['paypal_email'] = this.paypalEmail;
    return data;
  }
}

class Links {
  List<Self>? self;
  List<Collection>? collection;

  Links({this.self, this.collection});

  Links.fromJson(Map<String, dynamic> json) {
    if (json['self'] != null) {
      self = <Self>[];
      json['self'].forEach((v) {
        self!.add(new Self.fromJson(v));
      });
    }
    if (json['collection'] != null) {
      collection = <Collection>[];
      json['collection'].forEach((v) {
        collection!.add(new Collection.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.self != null) {
      data['self'] = this.self!.map((v) => v.toJson()).toList();
    }
    if (this.collection != null) {
      data['collection'] = this.collection!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Self {
  String? href;

  Self({this.href});

  Self.fromJson(Map<String, dynamic> json) {
    href = json['href'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['href'] = this.href;
    return data;
  }
}

class Collection {
  String? href;

  Collection({this.href});

  Collection.fromJson(Map<String, dynamic> json) {
    href = json['href'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['href'] = this.href;
    return data;
  }
}
