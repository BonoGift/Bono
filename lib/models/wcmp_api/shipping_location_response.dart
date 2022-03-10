import 'dart:convert';

class ShippingLocationResponse {
  ShippingLocationResponse({
    this.code,
    this.type,
    this.links,
  });

  String? code;
  String? type;
  Links? links;

  factory ShippingLocationResponse.fromRawJson(String str) =>
      ShippingLocationResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ShippingLocationResponse.fromJson(Map<String, dynamic> json) =>
      ShippingLocationResponse(
        code: json["code"] == null ? null : json["code"],
        type: json["type"] == null ? null : json["type"],
        links: json["_links"] == null ? null : Links.fromJson(json["_links"]),
      );

  Map<String, dynamic> toJson() => {
        "code": code == null ? null : code,
        "type": type == null ? null : type,
        "_links": links == null ? null : links!.toJson(),
      };
}

class Links {
  Links({
    this.collection,
    this.describes,
  });

  List<Collection>? collection;
  List<Collection>? describes;

  factory Links.fromRawJson(String str) => Links.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Links.fromJson(Map<String, dynamic> json) => Links(
        collection: json["collection"] == null
            ? null
            : List<Collection>.from(
                json["collection"].map((x) => Collection.fromJson(x))),
        describes: json["describes"] == null
            ? null
            : List<Collection>.from(
                json["describes"].map((x) => Collection.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "collection": collection == null
            ? null
            : List<dynamic>.from(collection!.map((x) => x.toJson())),
        "describes": describes == null
            ? null
            : List<dynamic>.from(describes!.map((x) => x.toJson())),
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
        href: json["href"] == null ? null : json["href"],
      );

  Map<String, dynamic> toJson() => {
        "href": href == null ? null : href,
      };
}
