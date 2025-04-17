import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_manager/item_provider.dart';
import 'package:food_manager/recipe_provider.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Future.delayed(const Duration(seconds: 1)), // Simulate loading
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          Future.microtask(() async {
            final user = FirebaseAuth.instance.currentUser;

            if (!context.mounted) {
              context.go('/login');
            } else {
              if (user != null) {
                await Provider.of<ItemProvider>(context, listen: false).fetchItems();
                await Provider.of<RecipeProvider>(context, listen: false).fetchRecipes();
                context.go('/');
              } else {
                context.go('/login');
              }
            }
          });
        }

        return const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        );
      },
    );
  }
}
