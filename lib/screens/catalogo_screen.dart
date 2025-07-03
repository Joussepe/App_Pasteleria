import 'package:flutter/material.dart';
import 'package:pasteleria_v2/theme/app_theme.dart';
import 'package:pasteleria_v2/services/firebase_services.dart';
import 'package:pasteleria_v2/screens/login_screen.dart';

class CatalogoScreen extends StatelessWidget {
  const CatalogoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: Stack(
        children: [
          SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.asset(
                          'assets/baner.png',
                          width: double.infinity,
                          height: 180,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text('¡Bienvenido!', style: AppTheme.headingStyle),
                    const SizedBox(height: 8),
                    Text('Descubre nuestros productos más deliciosos', style: AppTheme.subheadingStyle),
                    const SizedBox(height: 8),
                    FutureBuilder(
                      future: getProductos(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          List productos = snapshot.data as List;
                          if (productos.isNotEmpty) {
                            return GridView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                childAspectRatio: 1.5,
                                crossAxisSpacing: 8,
                                mainAxisSpacing: 8,
                              ),
                              itemCount: productos.length,
                              itemBuilder: (context, index) {
                                var producto = productos[index];
                                return Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  elevation: 2,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(16),
                                    child: Image.network(
                                      producto['imagen_url'] ?? '',
                                      width: double.infinity,
                                      height: double.infinity,
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) {
                                        return Container(
                                          color: AppTheme.primaryColor.withOpacity(0.1),
                                          child: const Icon(Icons.image, size: 24, color: AppTheme.primaryColor),
                                        );
                                      },
                                    ),
                                  ),
                                );
                              },
                            );
                          } else {
                            return const Center(child: Text('No hay productos disponibles'));
                          }
                        } else if (snapshot.hasError) {
                          return const Center(child: Text('Error al cargar productos'));
                        } else {
                          return const Center(child: CircularProgressIndicator());
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Botón flotante de perfil
          Positioned(
            top: 32,
            right: 32,
            child: Material(
              color: Colors.transparent,
              elevation: 4,
              shape: const CircleBorder(),
              child: InkWell(
                borderRadius: BorderRadius.circular(30),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginScreen()),
                  );
                },
                child: CircleAvatar(
                  radius: 20,
                  backgroundColor: AppTheme.primaryColor,
                  child: Icon(Icons.person, color: Colors.white, size: 22),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
} 