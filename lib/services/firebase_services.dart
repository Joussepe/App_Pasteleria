import 'package:cloud_firestore/cloud_firestore.dart';

FirebaseFirestore db = FirebaseFirestore.instance;

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