import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pasteleria_v2/theme/app_theme.dart';
import 'package:pasteleria_v2/services/firebase_services.dart';
import 'package:pasteleria_v2/services/cart_service.dart';
import 'package:pasteleria_v2/widgets/animated_cart_icon.dart';
import 'package:pasteleria_v2/widgets/product_modal_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.star, color: AppTheme.accentColor, size: 28),
            const SizedBox(width: 8),
            const Text('Dolce Estella'),
          ],
        ),
        backgroundColor: AppTheme.primaryColor.withOpacity(0.85),
        elevation: 0,
        actions: [
          const AnimatedCartIcon(),
          IconButton(
            icon: Icon(Icons.person, color: AppTheme.accentColor),
            onPressed: () {},
          ),
        ],
      ),
      body: Container(
        color: AppTheme.backgroundColor,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('¡Bienvenido a Dolce Estella!', style: AppTheme.headingStyle),
                const SizedBox(height: 8),
                Text('Elige tu dulce favorito', style: AppTheme.subheadingStyle),
                const SizedBox(height: 24),
                Expanded(
                  child: FutureBuilder(
                    future: getProductos(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        List productos = snapshot.data as List;
                        if (productos.isNotEmpty) {
                          return GridView.builder(
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 1.2,
                              crossAxisSpacing: 8,
                              mainAxisSpacing: 8,
                            ),
                            itemCount: productos.length,
                            itemBuilder: (context, index) {
                              var producto = productos[index];
                              return _buildProductCard(producto, context);
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
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProductCard(Map<String, dynamic> producto, BuildContext context) {
    return GestureDetector(
      onTap: () {
        _showProductModal(context, producto);
      },
      child: Container(
        decoration: AppTheme.cardDecoration,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 3,
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                child: Image.network(
                  producto['imagen_url'] ?? '',
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: AppTheme.primaryColor.withOpacity(0.1),
                      child: const Icon(Icons.image, size: 24, color: AppTheme.primaryColor),
                    );
                  },
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.all(2.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      producto['nombre'] ?? 'Sin nombre',
                      style: AppTheme.subheadingStyle.copyWith(fontSize: 12),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      'S/ ${(producto['precio'] ?? 0).toStringAsFixed(2)}',
                      style: TextStyle(
                        color: AppTheme.accentColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 11,
                      ),
                    ),
                    Expanded(
                      child: Center(
                        child: ElevatedButton(
                          onPressed: () {
                            _showProductModal(context, producto);
                          },
                          style: AppTheme.primaryButtonStyle.copyWith(
                            padding: MaterialStateProperty.all(const EdgeInsets.symmetric(horizontal: 12, vertical: 4)),
                            textStyle: MaterialStateProperty.all(const TextStyle(fontSize: 11)),
                          ),
                          child: const Text('Ver'),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showProductModal(BuildContext context, Map<String, dynamic> producto) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.9,
        builder: (context, scrollController) => ProductModalCard(producto: producto),
      ),
    );
  }
} 