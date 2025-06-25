import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pasteleria_v2/theme/app_theme.dart';
import 'package:pasteleria_v2/services/cart_service.dart';

class ProductModalCard extends StatelessWidget {
  final Map<String, dynamic> producto;

  const ProductModalCard({super.key, required this.producto});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Barra de arrastre
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 16),
          
          // Imagen del producto
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 24),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.primaryColor.withOpacity(0.15),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.network(
                producto['imagen_url'] ?? '',
                width: double.infinity,
                height: 200,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: double.infinity,
                    height: 200,
                    color: AppTheme.primaryColor.withOpacity(0.1),
                    child: const Icon(Icons.image, size: 60, color: AppTheme.primaryColor),
                  );
                },
              ),
            ),
          ),
          
          const SizedBox(height: 20),
          
          // Información del producto
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                Text(
                  producto['nombre'] ?? 'Sin nombre',
                  style: AppTheme.headingStyle.copyWith(fontSize: 20),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'S/ ${(producto['precio'] ?? 0).toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 18,
                    color: AppTheme.accentColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  producto['descripcion'] ?? 'Sin descripción disponible',
                  style: AppTheme.bodyStyle.copyWith(fontSize: 14),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                
                // Botón agregar al carrito
                Consumer<CartService>(
                  builder: (context, cartService, child) {
                    return SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          cartService.addItem(producto);
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('¡${producto['nombre']} agregado al carrito!'),
                              backgroundColor: AppTheme.primaryColor,
                              duration: const Duration(seconds: 2),
                              action: SnackBarAction(
                                label: 'Ver carrito',
                                textColor: Colors.white,
                                onPressed: () {
                                  // TODO: Navegar al carrito
                                },
                              ),
                            ),
                          );
                        },
                        style: AppTheme.primaryButtonStyle,
                        child: const Text('Agregar al carrito'),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 16),
                
                // Botón cerrar
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppTheme.primaryColor,
                      side: BorderSide(color: AppTheme.primaryColor),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('Cerrar'),
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ],
      ),
    );
  }
} 