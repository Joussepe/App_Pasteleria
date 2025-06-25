import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pasteleria_v2/services/cart_service.dart';
import 'package:pasteleria_v2/screens/cart_screen.dart';

class AnimatedCartIcon extends StatefulWidget {
  const AnimatedCartIcon({super.key});

  @override
  State<AnimatedCartIcon> createState() => _AnimatedCartIconState();
}

class _AnimatedCartIconState extends State<AnimatedCartIcon>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _bounceAnimation;
  int _previousItemCount = 0;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.3,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
    ));

    _bounceAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.bounceOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _triggerAnimation() {
    _animationController.forward().then((_) {
      _animationController.reverse();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CartService>(
      builder: (context, cartService, child) {
        // Verificar si se agregó un nuevo item
        if (cartService.itemCount > _previousItemCount && _previousItemCount > 0) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _triggerAnimation();
          });
        }
        _previousItemCount = cartService.itemCount;

        return Stack(
          children: [
            AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                return Transform.scale(
                  scale: _scaleAnimation.value,
                  child: IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const CartScreen(),
                        ),
                      );
                    },
                    icon: const Icon(Icons.shopping_cart),
                    color: Colors.white,
                  ),
                );
              },
            ),
            if (cartService.itemCount > 0)
              Positioned(
                right: 8,
                top: 8,
                child: AnimatedBuilder(
                  animation: _animationController,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _bounceAnimation.value,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 16,
                          minHeight: 16,
                        ),
                        child: Text(
                          '${cartService.itemCount}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    );
                  },
                ),
              ),
          ],
        );
      },
    );
  }
} 