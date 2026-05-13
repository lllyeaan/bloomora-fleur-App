class ProductModel {
  final int id;
  final String name;
  final int price;
  final String description;

  ProductModel({
    this.id = 0,
    required this.name,
    required this.price,
    required this.description,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'] is int
          ? json['id']
          : int.tryParse(json['id']?.toString() ?? '') ?? 0,
      name: json['name']?.toString() ?? '',
      price: json['price'] is num
          ? (json['price'] as num).toInt()
          : int.tryParse(json['price']?.toString() ?? '') ?? 0,
      description: json['description']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'name': name, 'price': price, 'description': description};
  }
}
