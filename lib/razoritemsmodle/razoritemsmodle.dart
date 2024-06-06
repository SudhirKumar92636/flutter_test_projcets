// To parse this JSON data, do
//
//     final razorpayitemsmodlesDart = razorpayitemsmodlesDartFromJson(jsonString);

import 'dart:convert';

RazorpayitemsmodlesDart razorpayitemsmodlesDartFromJson(String str) => RazorpayitemsmodlesDart.fromJson(json.decode(str));

String razorpayitemsmodlesDartToJson(RazorpayitemsmodlesDart data) => json.encode(data.toJson());

class RazorpayitemsmodlesDart {
  String? entity;
  int? count;
  List<Item>? items;

  RazorpayitemsmodlesDart({
    this.entity,
    this.count,
    this.items,
  });

  factory RazorpayitemsmodlesDart.fromJson(Map<String, dynamic> json) => RazorpayitemsmodlesDart(
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
  bool? active;
  String? name;
  String? description;
  int? amount;
  int? unitAmount;
  String? currency;
  String? type;
  dynamic unit;
  bool? taxInclusive;
  dynamic hsnCode;
  dynamic sacCode;
  dynamic taxRate;
  dynamic taxId;
  dynamic taxGroupId;
  int? createdAt;

  Item({
    this.id,
    this.active,
    this.name,
    this.description,
    this.amount,
    this.unitAmount,
    this.currency,
    this.type,
    this.unit,
    this.taxInclusive,
    this.hsnCode,
    this.sacCode,
    this.taxRate,
    this.taxId,
    this.taxGroupId,
    this.createdAt,
  });

  factory Item.fromJson(Map<String, dynamic> json) => Item(
    id: json["id"],
    active: json["active"],
    name: json["name"],
    description: json["description"],
    amount: json["amount"],
    unitAmount: json["unit_amount"],
    currency: json["currency"],
    type: json["type"],
    unit: json["unit"],
    taxInclusive: json["tax_inclusive"],
    hsnCode: json["hsn_code"],
    sacCode: json["sac_code"],
    taxRate: json["tax_rate"],
    taxId: json["tax_id"],
    taxGroupId: json["tax_group_id"],
    createdAt: json["created_at"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "active": active,
    "name": name,
    "description": description,
    "amount": amount,
    "unit_amount": unitAmount,
    "currency": currency,
    "type": type,
    "unit": unit,
    "tax_inclusive": taxInclusive,
    "hsn_code": hsnCode,
    "sac_code": sacCode,
    "tax_rate": taxRate,
    "tax_id": taxId,
    "tax_group_id": taxGroupId,
    "created_at": createdAt,
  };
}
