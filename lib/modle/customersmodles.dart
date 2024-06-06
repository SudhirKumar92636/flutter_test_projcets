// To parse this JSON data, do
//
//     final customersmodles = customersmodlesFromJson(jsonString);

import 'dart:convert';

Customersmodles customersmodlesFromJson(String str) => Customersmodles.fromJson(json.decode(str));

String customersmodlesToJson(Customersmodles data) => json.encode(data.toJson());

class Customersmodles {
  String? entity;
  int? count;
  List<Item>? items;

  Customersmodles({
    this.entity,
    this.count,
    this.items,
  });

  factory Customersmodles.fromJson(Map<String, dynamic> json) => Customersmodles(
    entity: json["entity"],
    count: json["count"],
    items: json["items"] == null ? [] : List<Item>.from(json["items"]!.map((x) => Item.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "entity": entity,
    "count": count,
    "items": items == null ? [] : List<dynamic>.from(items!.map((x) => x.toJson())),
  };
}

class Item {
  String? id;
  Entity? entity;
  String? name;
  String? email;
  String? contact;
  dynamic gstin;
  List<dynamic>? notes;
  int? createdAt;

  Item({
    this.id,
    this.entity,
    this.name,
    this.email,
    this.contact,
    this.gstin,
    this.notes,
    this.createdAt,
  });

  factory Item.fromJson(Map<String, dynamic> json) => Item(
    id: json["id"],
    entity: entityValues.map[json["entity"]]!,
    name: json["name"],
    email: json["email"],
    contact: json["contact"],
    gstin: json["gstin"],
    notes: json["notes"] == null ? [] : List<dynamic>.from(json["notes"]!.map((x) => x)),
    createdAt: json["created_at"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "entity": entityValues.reverse[entity],
    "name": name,
    "email": email,
    "contact": contact,
    "gstin": gstin,
    "notes": notes == null ? [] : List<dynamic>.from(notes!.map((x) => x)),
    "created_at": createdAt,
  };
}

enum Entity {
  CUSTOMER
}

final entityValues = EnumValues({
  "customer": Entity.CUSTOMER
});

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
