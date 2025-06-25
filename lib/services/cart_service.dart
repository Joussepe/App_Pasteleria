import 'package:flutter/foundation.dart';
import 'package:pasteleria_v2/models/cart_item.dart';

class CartService extends ChangeNotifier {
  final List<CartItem> _items = [];

  List<CartItem> get items => _items;

  int get itemCount => _items.length;

  double get total => _items.fold(0, (sum, item) => sum + item.total);

  void addItem(Map<String, dynamic> product) {
    final existingIndex = _items.indexWhere((item) => item.productId == product['id']);
    
    if (existingIndex >= 0) {
      _items[existingIndex].quantity++;
    } else {
      _items.add(CartItem(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        productId: product['id'] ?? '',
        name: product['nombre'] ?? '',
        imageUrl: product['imagen_url'] ?? '',
        price: (product['precio'] ?? 0.0).toDouble(),
      ));
    }
    notifyListeners();
  }

  void removeItem(String id) {
    _items.removeWhere((item) => item.id == id);
    notifyListeners();
  }

  void updateQuantity(String id, int quantity) {
    final index = _items.indexWhere((item) => item.id == id);
    if (index >= 0) {
      if (quantity <= 0) {
        _items.removeAt(index);
      } else {
        _items[index].quantity = quantity;
      }
      notifyListeners();
    }
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }
} 