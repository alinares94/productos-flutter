import 'dart:convert';

Map<String, Product> productFromMap(String str) => Map.from(json.decode(str)).map((k, v) => MapEntry<String, Product>(k, Product.fromMap(v)));

String productToMap(Map<String, Product> data) => json.encode(Map.from(data).map((k, v) => MapEntry<String, dynamic>(k, v.toMap())));

class Product {
    Product({
        required this.available,
        required this.name,
        this.picture,
        required this.price,
        this.id,
    });

    String? id;
    bool available;
    String name;
    String? picture;
    double price;

    factory Product.fromMap(Map<String, dynamic> json) => Product(
      available: json["Available"],
      name: json["Name"],
      picture: json["Picture"],
      price: json["Price"].toDouble(),
    );

    Map<String, dynamic> toMap() => {
      "Available": available,
      "Name": name,
      "Picture": picture,
      "Price": price,
    };

  Product clone() => Product(
    available: available, 
    name: name, 
    price: price,
    id: id,
    picture: picture
  );
}
