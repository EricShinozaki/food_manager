import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomeNavigationBar extends StatelessWidget {
  final Widget child;
  const HomeNavigationBar({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (index) {
          switch (index) {
            case 0:
              context.go('/recipes');
              break;
            case 1:
              context.go('/inventory');
              break;
            case 2:
              context.go('/');
              break;
            case 3:
              context.go('/scanning');
              break;
            case 4:
              context.go('/notifications');
              break;
          }
        },
        destinations: const [
          NavigationDestination(icon: Icon(Icons.flatware), label: 'Recipes'),
          NavigationDestination(icon: Icon(Icons.inventory_2), label: 'Inventory'),
          NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.crop_free), label: 'Scan'),
          NavigationDestination(icon: Icon(Icons.notification_add), label: 'Notifications'),
        ],
      ),
    );
  }

}