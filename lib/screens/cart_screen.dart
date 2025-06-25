import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pasteleria_v2/services/cart_service.dart';
import 'package:pasteleria_v2/theme/app_theme.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('Mi Carrito'),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
      ),
      body: Consumer<CartService>(
        builder: (context, cartService, child) {
          if (cartService.items.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.shopping_cart_outlined, size: 80, color: AppTheme.primaryColor),
                  SizedBox(height: 16),
                  Text(
                    'Tu carrito está vacío',
                    style: TextStyle(fontSize: 18, color: AppTheme.textColor),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Agrega algunos productos deliciosos',
                    style: TextStyle(fontSize: 14, color: AppTheme.textColor),
                  ),
                ],
              ),
            );
          }

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: cartService.items.length,
                  itemBuilder: (context, index) {
                    final item = cartService.items[index];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: AppTheme.cardDecoration,
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                item.imageUrl,
                                width: 60,
                                height: 60,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    width: 60,
                                    height: 60,
                                    color: AppTheme.primaryColor.withOpacity(0.1),
                                    child: const Icon(Icons.image, color: AppTheme.primaryColor),
                                  );
                                },
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item.name,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'S/ ${item.price.toStringAsFixed(2)}',
                                    style: TextStyle(
                                      color: AppTheme.accentColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Column(
                              children: [
                                Row(
                                  children: [
                                    IconButton(
                                      onPressed: () {
                                        cartService.updateQuantity(item.id, item.quantity - 1);
                                      },
                                      icon: const Icon(Icons.remove_circle_outline),
                                      color: AppTheme.primaryColor,
                                    ),
                                    Text(
                                      '${item.quantity}',
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        cartService.updateQuantity(item.id, item.quantity + 1);
                                      },
                                      icon: const Icon(Icons.add_circle_outline),
                                      color: AppTheme.primaryColor,
                                    ),
                                  ],
                                ),
                                Text(
                                  'S/ ${item.total.toStringAsFixed(2)}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                            IconButton(
                              onPressed: () {
                                cartService.removeItem(item.id);
                              },
                              icon: const Icon(Icons.delete_outline),
                              color: Colors.red,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, -2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Total:',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'S/ ${cartService.total.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.primaryColor,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Medios de pago:',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildPaymentMethod('Visa', Icons.credit_card, Colors.blue),
                        _buildPaymentMethod('Mastercard', Icons.credit_card, Colors.orange),
                        _buildPaymentMethod('Yape', Icons.phone_android, Colors.green),
                        _buildPaymentMethod('Plin', Icons.phone_android, Colors.purple),
                      ],
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          // TODO: Implementar proceso de pago
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('¡Proceso de pago implementado próximamente!'),
                              backgroundColor: AppTheme.primaryColor,
                            ),
                          );
                        },
                        style: AppTheme.primaryButtonStyle,
                        child: const Text('Proceder al pago'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildPaymentMethod(String name, IconData icon, Color color) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color, size: 24),
        ),
        const SizedBox(height: 4),
        Text(
          name,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
} 