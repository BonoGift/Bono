import 'dart:convert';

class TaxResponse {
  TaxResponse({
    this.id,
    this.country,
    this.state,
    this.postcode,
    this.city,
    this.postcodes,
    this.cities,
    this.rate,
    this.name,
    this.priority,
    this.compound,
    this.shipping,
    this.order,
    this.taxResponseClass,
    this.links,
  });

  int? id;
  String? country;
  String? state;
  String? postcode;
  String? city;
  List<String>? postcodes;
  List<String>? cities;
  String? rate;
  String? name;
  int? priority;
  bool? compound;
  bool? shipping;
  int? order;
  String? taxResponseClass;
  Links? links;

  factory TaxResponse.fromRawJson(String str) =>
      TaxResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory TaxResponse.fromJson(Map<String, dynamic> json) => TaxResponse(
        id: json["id"] == null ? null : json["id"],
        country: json["country"] == null ? null : json["country"],
        state: json["state"] == null ? null : json["state"],
        postcode: json["postcode"] == null ? null : json["postcode"],
        city: json["city"] == null ? null : json["city"],
        postcodes: json["postcodes"] == null
            ? null
            : List<String>.from(json["postcodes"].map((x) => x)),
        cities: json["cities"] == null
            ? null
            : List<String>.from(json["cities"].map((x) => x)),
        rate: json["rate"] == null ? null : json["rate"],
        name: json["name"] == null ? null : json["name"],
        priority: json["priority"] == null ? null : json["priority"],
        compound: json["compound"] == null ? null : json["compound"],
        shipping: json["shipping"] == null ? null : json["shipping"],
        order: json["order"] == null ? null : json["order"],
        taxResponseClass: json["class"] == null ? null : json["class"],
        links: json["_links"] == null ? null : Links.fromJson(json["_links"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "country": country == null ? null : country,
        "state": state == null ? null : state,
        "postcode": postcode == null ? null : postcode,
        "city": city == null ? null : city,
        "postcodes": postcodes == null
            ? null
            : List<dynamic>.from(postcodes!.map((x) => x)),
        "cities":
            cities == null ? null : List<dynamic>.from(cities!.map((x) => x)),
        "rate": rate == null ? null : rate,
        "name": name == null ? null : name,
        "priority": priority == null ? null : priority,
        "compound": compound == null ? null : compound,
        "shipping": shipping == null ? null : shipping,
        "order": order == null ? null : order,
        "class": taxResponseClass == null ? null : taxResponseClass,
        "_links": links == null ? null : links!.toJson(),
      };
}

class Links {
  Links({
    this.self,
    this.collection,
  });

  List<Collection>? self;
  List<Collection>? collection;

  factory Links.fromRawJson(String str) => Links.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Links.fromJson(Map<String, dynamic> json) => Links(
        self: json["self"] == null
            ? null
            : List<Collection>.from(
                json["self"].map((x) => Collection.fromJson(x))),
        collection: json["collection"] == null
            ? null
            : List<Collection>.from(
                json["collection"].map((x) => Collection.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "self": self == null
            ? null
            : List<dynamic>.from(self!.map((x) => x.toJson())),
        "collection": collection == null
            ? null
            : List<dynamic>.from(collection!.map((x) => x.toJson())),
      };
}

class Collection {
  Collection({
    this.href,
  });

  String? href;

  factory Collection.fromRawJson(String str) =>
      Collection.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Collection.fromJson(Map<String, dynamic> json) => Collection(
        href: json["href"] ?? null,
      );

  Map<String, dynamic> toJson() => {
        "href": href == null ? null : href,
      };
}
