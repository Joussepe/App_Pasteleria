import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pasteleria_v2/services/cart_service.dart';
import 'package:pasteleria_v2/models/cart_item.dart';

FirebaseFirestore db = FirebaseFirestore.instance;

class UserProvider extends ChangeNotifier {
  String? id;
  String? correo;
  List<Order> orderHistory = [];

  void setUser({required String id, required String correo}) {
    this.id = id;
    this.correo = correo;
    notifyListeners();
  }

  void clearUser() {
    id = null;
    correo = null;
    orderHistory.clear();
    notifyListeners();
  }

  void addOrder(Order order) {
    orderHistory.add(order);
    notifyListeners();
  }
}

class Order {
  final String id;
  final DateTime date;
  final List<CartItem> items;
  final double total;
  final String status;

  Order({
    required this.id,
    required this.date,
    required this.items,
    required this.total,
    this.status = 'Preparando',
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'date': date.toIso8601String(),
      'items': items.map((item) => {
        'name': item.name,
        'price': item.price,
        'quantity': item.quantity,
        'total': item.total,
      }).toList(),
      'total': total,
      'status': status,
    };
  }
}

Future<List> getUsuarios() async {
  List usuarios = [];
  CollectionReference collectionReferenceUsuarios = db.collection('usuarios');

  QuerySnapshot queryUsuarios = await collectionReferenceUsuarios.get();

  queryUsuarios.docs.forEach((documento) {
    usuarios.add(documento.data());
  });

  return usuarios;
}

Future<List> getProductos() async {
  List productos = [];
  CollectionReference collectionReferenceProductos = db.collection('productos');

  QuerySnapshot queryProductos = await collectionReferenceProductos.get();

  queryProductos.docs.forEach((documento) {
    productos.add(documento.data());
  });

  return productos;
}

Future<bool> login(String email, String password) async {
  try {
    QuerySnapshot querySnapshot = await db
        .collection('usuarios')
        .where('correo', isEqualTo: email)
        .where('contrasenia', isEqualTo: password)
        .get();

    return querySnapshot.docs.isNotEmpty;
  } catch (e) {
    print('Error en login: $e');
    return false;
  }
}

Future<bool> register(String email, String password) async {
  try {
    // Verificar si el correo ya existe
    QuerySnapshot querySnapshot = await db
        .collection('usuarios')
        .where('correo', isEqualTo: email)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      return false; // El correo ya existe
    }

    // Crear nuevo usuario
    await db.collection('usuarios').add({
      'correo': email,
      'contrasenia': password,
      'id': DateTime.now().millisecondsSinceEpoch.toString(), // ID único
    });

    return true;
  } catch (e) {
    print('Error en registro: $e');
    return false;
  }
}