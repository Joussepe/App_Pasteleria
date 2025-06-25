class CartItem {
  final String id;
  final String productId;
  final String name;
  final String imageUrl;
  final double price;
  int quantity;

  CartItem({
    required this.id,
    required this.productId,
    required this.name,
    required this.imageUrl,
    required this.price,
    this.quantity = 1,
  });

  double get total => price * quantity;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'productId': productId,
      'name': name,
      'imageUrl': imageUrl,
      'price': price,
      'quantity': quantity,
    };
  }

  factory CartItem.fromMap(Map<String, dynamic> map) {
    return CartItem(
      id: map['id'] ?? '',
      productId: map['productId'] ?? '',
      name: map['name'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      price: (map['price'] ?? 0.0).toDouble(),
      quantity: map['quantity'] ?? 1,
    );
  }
} 