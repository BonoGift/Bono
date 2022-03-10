// To parse this JSON data, do
//
//     final zoneResponse = zoneResponseFromJson(jsonString);

import 'dart:convert';

class ZoneResponse {
  ZoneResponse({
    this.id,
    this.name,
    this.order,
    this.links,
  });

  int? id;
  String? name;
  int? order;
  Links? links;

  factory ZoneResponse.fromRawJson(String str) =>
      ZoneResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ZoneResponse.fromJson(Map<String, dynamic> json) => ZoneResponse(
        id: json["id"] == null ? null : json["id"],
        name: json["name"] == null ? null : json["name"],
        order: json["order"] == null ? null : json["order"],
        links: json["_links"] == null ? null : Links.fromJson(json["_links"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "name": name == null ? null : name,
        "order": order == null ? null : order,
        "_links": links == null ? null : links!.toJson(),
      };
}

class Links {
  Links({
    this.self,
    this.collection,
    this.describedby,
  });

  List<Collection>? self;
  List<Collection>? collection;
  List<Collection>? describedby;

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
        describedby: json["describedby"] == null
            ? null
            : List<Collection>.from(
                json["describedby"].map((x) => Collection.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "self": self == null
            ? null
            : List<dynamic>.from(self!.map((x) => x.toJson())),
        "collection": collection == null
            ? null
            : List<dynamic>.from(collection!.map((x) => x.toJson())),
        "describedby": describedby == null
            ? null
            : List<dynamic>.from(describedby!.map((x) => x.toJson())),
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
