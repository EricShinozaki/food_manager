import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:food_manager/ItemProvider.dart';
import 'package:food_manager/recipeProvider.dart';
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
          // Delay the navigation by a microtask so it doesn't trigger during build
          Future.microtask(() {
            final user = FirebaseAuth.instance.currentUser;
            if (user != null) {
              Provider.of<ItemProvider>(context, listen: false).fetchItems();
              Provider.of<RecipeProvider>(context, listen: false).fetchRecipes();
              context.go('/'); // assuming '/' is home
            } else {
              context.go('/login');
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
