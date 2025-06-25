class Product {
  final String id;
  final String name;
  final String description;
  final double price;
  final String imageUrl;
  final String category;
  final bool isPopular;
  final bool isFeatured;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.category,
    this.isPopular = false,
    this.isFeatured = false,
  });

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      price: (map['price'] ?? 0.0).toDouble(),
      imageUrl: map['imageUrl'] ?? '',
      category: map['category'] ?? '',
      isPopular: map['isPopular'] ?? false,
      isFeatured: map['isFeatured'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'imageUrl': imageUrl,
      'category': category,
      'isPopular': isPopular,
      'isFeatured': isFeatured,
    };
  }
} 