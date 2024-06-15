import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ShowProductScreens extends StatelessWidget {
  const ShowProductScreens({super.key});

  Future<List<Productmodles>> getProducts() async {
    var url = Uri.parse("https://fakestoreapi.com/products");
    var response = await http.get(url);
    if (response.statusCode == 200) {
      List<Productmodles> data = productmodlesFromJson(response.body);
      return data;
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Show Product"),
        backgroundColor: Colors.indigo,
      ),
      body: FutureBuilder<List<Productmodles>>(
        future: getProducts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()));
          } else if (snapshot.hasData) {
            var products = snapshot.data!;
            if (products.isEmpty) {
              return Center(child: Text("No Products Found"));
            } else {
              return ListView.builder(
                itemCount: products.length,
                itemBuilder: (context, index) {
                  var product = products[index];
                  return ListTile(
                    title: Text(product.id.toString() ?? 'No Title'),
                    subtitle: Text(product.price.toString()),
                    trailing: Text(product.category.toString()),
                  );
                },
              );
            }
          } else {
            return Center(child: Text("No Products Found"));
          }
        },
      ),
    );
  }
}

// To parse this JSON data, do
//
//     final productmodles = productmodlesFromJson(jsonString);

List<Productmodles> productmodlesFromJson(String str) => List<Productmodles>.from(json.decode(str).map((x) => Productmodles.fromJson(x)));

String productmodlesToJson(List<Productmodles> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Productmodles {
  int? id;
  String? title;
  double? price;
  String? description;
  Category? category;
  String? image;
  Rating? rating;

  Productmodles({
    this.id,
    this.title,
    this.price,
    this.description,
    this.category,
    this.image,
    this.rating,
  });

  factory Productmodles.fromJson(Map<String, dynamic> json) => Productmodles(
    id: json["id"],
    title: json["title"],
    price: json["price"]?.toDouble(),
    description: json["description"],
    category: categoryValues.map[json["category"]]!,
    image: json["image"],
    rating: json["rating"] == null ? null : Rating.fromJson(json["rating"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "price": price,
    "description": description,
    "category": categoryValues.reverse[category],
    "image": image,
    "rating": rating?.toJson(),
  };
}

enum Category {
  ELECTRONICS,
  JEWELERY,
  MEN_S_CLOTHING,
  WOMEN_S_CLOTHING
}

final categoryValues = EnumValues({
  "electronics": Category.ELECTRONICS,
  "jewelery": Category.JEWELERY,
  "men's clothing": Category.MEN_S_CLOTHING,
  "women's clothing": Category.WOMEN_S_CLOTHING
});

class Rating {
  double? rate;
  int? count;

  Rating({
    this.rate,
    this.count,
  });

  factory Rating.fromJson(Map<String, dynamic> json) => Rating(
    rate: json["rate"]?.toDouble(),
    count: json["count"],
  );

  Map<String, dynamic> toJson() => {
    "rate": rate,
    "count": count,
  };
}

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
