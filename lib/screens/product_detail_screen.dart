import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pasteleria_v2/theme/app_theme.dart';
import 'package:pasteleria_v2/services/cart_service.dart';

class ProductDetailScreen extends StatelessWidget {
  final Map<String, dynamic> producto;

  const ProductDetailScreen({super.key, required this.producto});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: Text(producto['nombre'] ?? 'Detalle del Producto'),
        backgroundColor: AppTheme.primaryColor.withOpacity(0.85),
        iconTheme: const IconThemeData(color: AppTheme.textColor),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.primaryColor.withOpacity(0.15),
                      blurRadius: 24,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: Image.network(
                    producto['imagen_url'] ?? '',
                    width: 260,
                    height: 260,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Icon(Icons.broken_image, size: 100, color: AppTheme.primaryColor);
                    },
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),
            Text(
              producto['nombre'] ?? '',
              style: AppTheme.headingStyle,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              'S/ ${(producto['precio'] ?? 0).toStringAsFixed(2)}',
              style: TextStyle(
                fontSize: 22,
                color: AppTheme.accentColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 32),
            Text(
              producto['descripcion'] ?? '',
              style: AppTheme.bodyStyle,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            Consumer<CartService>(
              builder: (context, cartService, child) {
                return ElevatedButton(
                  onPressed: () {
                    cartService.addItem(producto);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('¡${producto['nombre']} agregado al carrito!'),
                        backgroundColor: AppTheme.primaryColor,
                        duration: const Duration(seconds: 2),
                        action: SnackBarAction(
                          label: 'Ver carrito',
                          textColor: Colors.white,
                          onPressed: () {
                            Navigator.pop(context);
                            // TODO: Navegar al carrito
                          },
                        ),
                      ),
                    );
                  },
                  style: AppTheme.primaryButtonStyle,
                  child: const Text('Agregar al carrito'),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
} 