import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomeNavigationBar extends StatelessWidget {
  final Widget child;
  const HomeNavigationBar({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    // Get the current route
    final String location = GoRouterState.of(context).uri.path;

    return Scaffold(
      bottomNavigationBar: NavigationBar(
        selectedIndex: _getIndex(location), // Determine selected tab
        onDestinationSelected: (index) {
          context.go(_getPath(index)); // Navigate on tap
        },
        destinations: const [
          NavigationDestination(icon: Icon(Icons.flatware), label: 'Recipes'),
          NavigationDestination(icon: Icon(Icons.inventory_2), label: 'Inventory'),
          NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.crop_free), label: 'Scan'),
          NavigationDestination(icon: Icon(Icons.settings), label: 'Settings'),
        ],
      )
    );
  }

  int _getIndex(String location) {
    // Check if the location path starts with any of the main routes
    if (location.startsWith('/recipes')) {
      return 0;  // Recipes tab
    } else if (location.startsWith('/inventory')) {
      return 1;  // Inventory tab
    } else if (location.startsWith('/scanning')) {
      return 3;  // Scan tab
    } else if (location.startsWith('/settings')) {
      return 4;  // settings tab
    }

    // Default to Home tab if no match
    return 2;
  }

  String _getPath(int index) {
    return ['/recipes', '/inventory', '/', '/scanning', '/settings'][index];
  }
}