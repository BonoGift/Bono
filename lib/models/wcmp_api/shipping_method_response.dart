// To parse this JSON data, do
//
//     final shippingMethodResponse = shippingMethodResponseFromJson(jsonString);

import 'dart:convert';

class ShippingMethodResponse {
  ShippingMethodResponse({
    this.instanceId,
    this.title,
    this.order,
    this.enabled,
    this.methodId,
    this.methodTitle,
    this.methodDescription,
    this.settings,
    this.links,
  });

  int? instanceId;
  String? title;
  int? order;
  bool? enabled;
  String? methodId;
  String? methodTitle;
  String? methodDescription;
  Settings? settings;
  Links? links;

  factory ShippingMethodResponse.fromRawJson(String str) =>
      ShippingMethodResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ShippingMethodResponse.fromJson(Map<String, dynamic> json) =>
      ShippingMethodResponse(
        instanceId: json["instance_id"] == null ? null : json["instance_id"],
        title: json["title"] == null ? null : json["title"],
        order: json["order"] == null ? null : json["order"],
        enabled: json["enabled"] == null ? null : json["enabled"],
        methodId: json["method_id"] == null ? null : json["method_id"],
        methodTitle: json["method_title"] == null ? null : json["method_title"],
        methodDescription: json["method_description"] == null
            ? null
            : json["method_description"],
        settings: json["settings"] == null
            ? null
            : Settings.fromJson(json["settings"]),
        links: json["_links"] == null ? null : Links.fromJson(json["_links"]),
      );

  Map<String, dynamic> toJson() => {
        "instance_id": instanceId == null ? null : instanceId,
        "title": title == null ? null : title,
        "order": order == null ? null : order,
        "enabled": enabled == null ? null : enabled,
        "method_id": methodId == null ? null : methodId,
        "method_title": methodTitle == null ? null : methodTitle,
        "method_description":
            methodDescription == null ? null : methodDescription,
        "settings": settings == null ? null : settings!.toJson(),
        "_links": links == null ? null : links!.toJson(),
      };
}

class Links {
  Links({
    this.self,
    this.collection,
    this.describes,
  });

  List<Collection>? self;
  List<Collection>? collection;
  List<Collection>? describes;

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
        describes: json["describes"] == null
            ? null
            : List<Collection>.from(
                json["describes"].map((x) => Collection.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "self": self == null
            ? null
            : List<dynamic>.from(self!.map((x) => x.toJson())),
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

class Settings {
  Settings({
    this.title,
    this.taxStatus,
    this.cost,
    this.classCosts,
    this.classCost92,
    this.classCost91,
    this.noClassCost,
    this.type,
  });

  ClassCost91? title;
  TaxStatus? taxStatus;
  ClassCost91? cost;
  ClassCost91? classCosts;
  ClassCost91? classCost92;
  ClassCost91? classCost91;
  ClassCost91? noClassCost;
  Type? type;

  factory Settings.fromRawJson(String str) =>
      Settings.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Settings.fromJson(Map<String, dynamic> json) => Settings(
        title:
            json["title"] == null ? null : ClassCost91.fromJson(json["title"]),
        taxStatus: json["tax_status"] == null
            ? null
            : TaxStatus.fromJson(json["tax_status"]),
        cost: json["cost"] == null ? null : ClassCost91.fromJson(json["cost"]),
        classCosts: json["class_costs"] == null
            ? null
            : ClassCost91.fromJson(json["class_costs"]),
        classCost92: json["class_cost_92"] == null
            ? null
            : ClassCost91.fromJson(json["class_cost_92"]),
        classCost91: json["class_cost_91"] == null
            ? null
            : ClassCost91.fromJson(json["class_cost_91"]),
        noClassCost: json["no_class_cost"] == null
            ? null
            : ClassCost91.fromJson(json["no_class_cost"]),
        type: json["type"] == null ? null : Type.fromJson(json["type"]),
      );

  Map<String, dynamic> toJson() => {
        "title": title == null ? null : title!.toJson(),
        "tax_status": taxStatus == null ? null : taxStatus!.toJson(),
        "cost": cost == null ? null : cost!.toJson(),
        "class_costs": classCosts == null ? null : classCosts!.toJson(),
        "class_cost_92": classCost92 == null ? null : classCost92!.toJson(),
        "class_cost_91": classCost91 == null ? null : classCost91!.toJson(),
        "no_class_cost": noClassCost == null ? null : noClassCost!.toJson(),
        "type": type == null ? null : type!.toJson(),
      };
}

class ClassCost91 {
  ClassCost91({
    this.id,
    this.label,
    this.description,
    this.type,
    this.value,
    this.classCost91Default,
    this.tip,
    this.placeholder,
  });

  String? id;
  String? label;
  String? description;
  String? type;
  String? value;
  String? classCost91Default;
  String? tip;
  String? placeholder;

  factory ClassCost91.fromRawJson(String str) =>
      ClassCost91.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ClassCost91.fromJson(Map<String, dynamic> json) => ClassCost91(
        id: json["id"] == null ? null : json["id"],
        label: json["label"] == null ? null : json["label"],
        description: json["description"] == null ? null : json["description"],
        type: json["type"] == null ? null : json["type"],
        value: json["value"] == null ? null : json["value"],
        classCost91Default: json["default"] == null ? null : json["default"],
        tip: json["tip"] == null ? null : json["tip"],
        placeholder: json["placeholder"] == null ? null : json["placeholder"],
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "label": label == null ? null : label,
        "description": description == null ? null : description,
        "type": type == null ? null : type,
        "value": value == null ? null : value,
        "default": classCost91Default == null ? null : classCost91Default,
        "tip": tip == null ? null : tip,
        "placeholder": placeholder == null ? null : placeholder,
      };
}

class TaxStatus {
  TaxStatus({
    this.id,
    this.label,
    this.description,
    this.type,
    this.value,
    this.taxStatusDefault,
    this.tip,
    this.placeholder,
    this.options,
  });

  String? id;
  String? label;
  String? description;
  String? type;
  String? value;
  String? taxStatusDefault;
  String? tip;
  String? placeholder;
  TaxStatusOptions? options;

  factory TaxStatus.fromRawJson(String str) =>
      TaxStatus.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory TaxStatus.fromJson(Map<String, dynamic> json) => TaxStatus(
        id: json["id"] == null ? null : json["id"],
        label: json["label"] == null ? null : json["label"],
        description: json["description"] == null ? null : json["description"],
        type: json["type"] == null ? null : json["type"],
        value: json["value"] == null ? null : json["value"],
        taxStatusDefault: json["default"] == null ? null : json["default"],
        tip: json["tip"] == null ? null : json["tip"],
        placeholder: json["placeholder"] == null ? null : json["placeholder"],
        options: json["options"] == null
            ? null
            : TaxStatusOptions.fromJson(json["options"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "label": label == null ? null : label,
        "description": description == null ? null : description,
        "type": type == null ? null : type,
        "value": value == null ? null : value,
        "default": taxStatusDefault == null ? null : taxStatusDefault,
        "tip": tip == null ? null : tip,
        "placeholder": placeholder == null ? null : placeholder,
        "options": options == null ? null : options!.toJson(),
      };
}

class TaxStatusOptions {
  TaxStatusOptions({
    this.taxable,
    this.none,
  });

  String? taxable;
  String? none;

  factory TaxStatusOptions.fromRawJson(String str) =>
      TaxStatusOptions.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory TaxStatusOptions.fromJson(Map<String, dynamic> json) =>
      TaxStatusOptions(
        taxable: json["taxable"] == null ? null : json["taxable"],
        none: json["none"] == null ? null : json["none"],
      );

  Map<String, dynamic> toJson() => {
        "taxable": taxable == null ? null : taxable,
        "none": none == null ? null : none,
      };
}

class Type {
  Type({
    this.id,
    this.label,
    this.description,
    this.type,
    this.value,
    this.typeDefault,
    this.tip,
    this.placeholder,
    this.options,
  });

  String? id;
  String? label;
  String? description;
  String? type;
  String? value;
  String? typeDefault;
  String? tip;
  String? placeholder;
  TypeOptions? options;

  factory Type.fromRawJson(String str) => Type.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Type.fromJson(Map<String, dynamic> json) => Type(
        id: json["id"] == null ? null : json["id"],
        label: json["label"] == null ? null : json["label"],
        description: json["description"] == null ? null : json["description"],
        type: json["type"] == null ? null : json["type"],
        value: json["value"] == null ? null : json["value"],
        typeDefault: json["default"] == null ? null : json["default"],
        tip: json["tip"] == null ? null : json["tip"],
        placeholder: json["placeholder"] == null ? null : json["placeholder"],
        options: json["options"] == null
            ? null
            : TypeOptions.fromJson(json["options"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "label": label == null ? null : label,
        "description": description == null ? null : description,
        "type": type == null ? null : type,
        "value": value == null ? null : value,
        "default": typeDefault == null ? null : typeDefault,
        "tip": tip == null ? null : tip,
        "placeholder": placeholder == null ? null : placeholder,
        "options": options == null ? null : options!.toJson(),
      };
}

class TypeOptions {
  TypeOptions({
    this.optionsClass,
    this.order,
  });

  String? optionsClass;
  String? order;

  factory TypeOptions.fromRawJson(String str) =>
      TypeOptions.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory TypeOptions.fromJson(Map<String, dynamic> json) => TypeOptions(
        optionsClass: json["class"] == null ? null : json["class"],
        order: json["order"] == null ? null : json["order"],
      );

  Map<String, dynamic> toJson() => {
        "class": optionsClass == null ? null : optionsClass,
        "order": order == null ? null : order,
      };
}
