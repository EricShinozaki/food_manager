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
      body: child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: _getIndex(location), // Determine selected tab
        onDestinationSelected: (index) {
          context.go(_getPath(index)); // Navigate on tap
        },
        indicatorColor: Colors.blue.withOpacity(0.2),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.flatware), label: 'Recipes'),
          NavigationDestination(icon: Icon(Icons.inventory_2), label: 'Inventory'),
          NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.crop_free), label: 'Scan'),
          NavigationDestination(icon: Icon(Icons.notification_add), label: 'Notifications'),
        ],
      ),
      /*floatingActionButton: location != '/settings'
          ? FloatingActionButton(
            onPressed: () => context.go('/settings'),
            child: const Icon(Icons.settings),
          )
          : null, */
    );
  }

  int _getIndex(String location) {
    switch(location) {
      case '/notifications/itemNotification':
        return 2;

    }

    return ['/recipes', '/inventory', '/', '/scanning', '/notifications']
        .indexOf(location);
  }

  String _getPath(int index) {
    return ['/recipes', '/inventory', '/', '/scanning', '/notifications'][index];
  }
}