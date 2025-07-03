import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pasteleria_v2/theme/app_theme.dart';
import 'package:pasteleria_v2/services/firebase_services.dart';
import 'package:pasteleria_v2/services/cart_service.dart';
import 'package:pasteleria_v2/widgets/animated_cart_icon.dart';
import 'package:pasteleria_v2/widgets/product_modal_card.dart';
import 'dart:collection';
import 'package:pasteleria_v2/screens/login_screen.dart';
import 'dart:math';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:pasteleria_v2/screens/location_screen.dart';
import 'package:pasteleria_v2/screens/order_history_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String searchQuery = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: Stack(
        children: [
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
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
                  const SizedBox(height: 16),
                  Text('¡Bienvenido!', style: AppTheme.headingStyle),
                  const SizedBox(height: 8),
                  Text('Elige tu dulce favorito', style: AppTheme.subheadingStyle),
                  const SizedBox(height: 16),
                  // Buscador
                  TextField(
                    decoration: InputDecoration(
                      hintText: 'Buscar producto...',
                      prefixIcon: Icon(Icons.search, color: AppTheme.primaryColor),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: AppTheme.surfaceColor,
                    ),
                    onChanged: (value) {
                      setState(() {
                        searchQuery = value.trim();
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: FutureBuilder(
                      future: getProductos(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          List productos = snapshot.data as List;
                          // Filtrar productos por búsqueda
                          if (searchQuery.isNotEmpty) {
                            productos = productos.where((p) {
                              final nombre = (p['nombre'] ?? '').toString().toLowerCase();
                              return nombre.startsWith(searchQuery.toLowerCase());
                            }).toList();
                          }
                          // Seleccionar productos destacados aleatorios
                          List destacados = [];
                          if (productos.length > 3) {
                            productos.shuffle(Random());
                            destacados = productos.take(3).toList();
                          } else {
                            destacados = List.from(productos);
                          }
                          // Agrupar productos por categoría
                          Map<String, List> secciones = {
                            'Tortas': [],
                            'Panes': [],
                            'Galletas': [],
                            'Postres': [],
                          };
                          for (var producto in productos) {
                            final nombre = (producto['nombre'] ?? '').toString().toLowerCase();
                            if (nombre.startsWith('torta')) {
                              secciones['Tortas']!.add(producto);
                            } else if (nombre.startsWith('pan')) {
                              secciones['Panes']!.add(producto);
                            } else if (nombre.startsWith('galleta')) {
                              secciones['Galletas']!.add(producto);
                            } else {
                              secciones['Postres']!.add(producto);
                            }
                          }
                          // Mostrar destacados
                          return AnimationLimiter(
                            child: ListView(
                              children: [
                                if (destacados.isNotEmpty)
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Icon(Icons.star, color: AppTheme.accentColor),
                                          const SizedBox(width: 8),
                                          Text('Destacados', style: AppTheme.headingStyle.copyWith(fontSize: 18)),
                                        ],
                                      ),
                                      const SizedBox(height: 8),
                                      SizedBox(
                                        height: 220,
                                        child: ListView.builder(
                                          scrollDirection: Axis.horizontal,
                                          itemCount: destacados.length,
                                          itemBuilder: (context, i) {
                                            var producto = destacados[i];
                                            return AnimationConfiguration.staggeredList(
                                              position: i,
                                              duration: const Duration(milliseconds: 500),
                                              child: SlideAnimation(
                                                horizontalOffset: 50.0,
                                                child: FadeInAnimation(
                                                  child: _buildFeaturedProductCard(producto, context),
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                      const SizedBox(height: 16),
                                    ],
                                  ),
                                // Mostrar secciones
                                ...secciones.entries.where((e) => e.value.isNotEmpty).map((entry) {
                                  IconData icono;
                                  switch (entry.key) {
                                    case 'Tortas':
                                      icono = Icons.cake;
                                      break;
                                    case 'Panes':
                                      icono = Icons.bakery_dining;
                                      break;
                                    case 'Galletas':
                                      icono = Icons.cookie;
                                      break;
                                    default:
                                      icono = Icons.icecream;
                                  }
                                  return Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Icon(icono, color: AppTheme.primaryColor),
                                          const SizedBox(width: 8),
                                          Text(entry.key, style: AppTheme.headingStyle.copyWith(fontSize: 20)),
                                        ],
                                      ),
                                      const Divider(height: 24, thickness: 1),
                                      AnimationLimiter(
                                        child: GridView.builder(
                                          shrinkWrap: true,
                                          physics: const NeverScrollableScrollPhysics(),
                                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: 2,
                                            childAspectRatio: 1.35,
                                            crossAxisSpacing: 8,
                                            mainAxisSpacing: 8,
                                          ),
                                          itemCount: entry.value.length,
                                          itemBuilder: (context, index) {
                                            var producto = entry.value[index];
                                            return AnimationConfiguration.staggeredGrid(
                                              position: index,
                                              duration: const Duration(milliseconds: 400),
                                              columnCount: 2,
                                              child: ScaleAnimation(
                                                child: FadeInAnimation(
                                                  child: _buildProductCard(producto, context, visual: true),
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ],
                                  );
                                }).toList(),
                              ],
                            ),
                          );
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
          // Botón flotante de perfil (derecha)
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
                  showModalBottomSheet(
                    context: context,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                    ),
                    builder: (context) {
                      final userProvider = Provider.of<UserProvider>(context);
                      return Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Center(
                              child: CircleAvatar(
                                radius: 36,
                                backgroundColor: AppTheme.primaryColor.withOpacity(0.1),
                                child: Icon(Icons.person, size: 48, color: AppTheme.primaryColor),
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text('Perfil', style: AppTheme.headingStyle.copyWith(fontSize: 22)),
                            const SizedBox(height: 16),
                            Text('ID: ${userProvider.id ?? '-'}', style: AppTheme.bodyStyle),
                            const SizedBox(height: 8),
                            Text('Correo: ${userProvider.correo ?? '-'}', style: AppTheme.bodyStyle),
                            const SizedBox(height: 24),
                            Center(
                              child: ElevatedButton(
                                onPressed: () {
                                  userProvider.clearUser();
                                  Navigator.of(context).pop();
                                  Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(builder: (_) => const LoginScreen()),
                                  );
                                },
                                style: AppTheme.primaryButtonStyle,
                                child: const Text('Cerrar sesión'),
                              ),
                            ),
                            const SizedBox(height: 12),
                            Center(
                              child: ElevatedButton.icon(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => const LocationScreen()),
                                  );
                                },
                                icon: const Icon(Icons.location_on),
                                label: const Text('Mi Ubicación'),
                                style: AppTheme.secondaryButtonStyle,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Center(
                              child: ElevatedButton.icon(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => const OrderHistoryScreen()),
                                  );
                                },
                                icon: const Icon(Icons.history),
                                label: const Text('Mi Historial'),
                                style: AppTheme.secondaryButtonStyle,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
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
          // Botón flotante de carrito (al lado del perfil)
          Positioned(
            top: 32,
            right: 80,
            child: Material(
              color: Colors.transparent,
              elevation: 4,
              shape: const CircleBorder(),
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppTheme.primaryColor,
                ),
                child: const AnimatedCartIcon(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeaturedProductCard(Map<String, dynamic> producto, BuildContext context) {
    return GestureDetector(
      onTap: () {
        _showProductModal(context, producto);
      },
      child: Container(
        width: 160,
        margin: const EdgeInsets.only(right: 12),
        decoration: BoxDecoration(
          color: AppTheme.surfaceColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 4,
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
                      style: AppTheme.subheadingStyle.copyWith(fontSize: 9),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      'S/ ${(producto['precio'] ?? 0).toStringAsFixed(2)}',
                      style: TextStyle(
                        color: AppTheme.accentColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 8,
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

  Widget _buildProductCard(Map<String, dynamic> producto, BuildContext context, {bool visual = false}) {
    return GestureDetector(
      onTap: () {
        _showProductModal(context, producto);
      },
      child: Container(
        decoration: BoxDecoration(
          color: AppTheme.surfaceColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 4,
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
                      style: AppTheme.subheadingStyle.copyWith(fontSize: 10),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      'S/ ${(producto['precio'] ?? 0).toStringAsFixed(2)}',
                      style: TextStyle(
                        color: AppTheme.accentColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 9,
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