import 'package:flutter/material.dart';

//Importaciones de Firebase
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:pasteleria_v2/services/firebase_services.dart';
import 'package:pasteleria_v2/services/cart_service.dart';
import 'package:pasteleria_v2/screens/login_screen.dart';
import 'package:pasteleria_v2/theme/app_theme.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => CartService(),
      child: MaterialApp(
        title: 'Pastelería App',
        theme: AppTheme.theme,
        home: const LoginScreen(),
      ),
    );
  }
}

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pastelería App'),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {
              // TODO: Implementar navegación al carrito
            },
          ),
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              // TODO: Implementar navegación al perfil
            },
          ),
        ],
      ),
      body: FutureBuilder(
        future: getUsuarios(),
        builder: ((context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data?.length,
              itemBuilder: (context, index) {
                return Text(snapshot.data?[index]['id']);
              },
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        }),
      ),
    );
  }
}
