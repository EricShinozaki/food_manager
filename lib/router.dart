import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:food_manager/screens/add_item_screen.dart';
import 'package:food_manager/screens/add_recipe_screen.dart';
import 'package:food_manager/screens/forgot_password.dart';
import 'package:food_manager/screens/home_screen.dart';
import 'package:food_manager/screens/inventory_screen.dart';
import 'package:food_manager/screens/login_screen.dart';
import 'package:food_manager/screens/recipe_details_screen.dart';
import 'package:food_manager/screens/recipes_screen.dart';
import 'package:food_manager/screens/reset_password.dart';
import 'package:food_manager/screens/scanning_screen.dart';
import 'package:food_manager/screens/settings_screen.dart';
import 'package:food_manager/screens/sign_up_screen.dart';
import 'package:food_manager/screens/splash_screen.dart';
import 'package:food_manager/screens/view_receipt_screen.dart';
import 'package:food_manager/widgets/home_navigation_bar.dart';
import 'package:go_router/go_router.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _homeNavigatorKey = GlobalKey<NavigatorState>();

final GoRouter _router =  GoRouter(
  initialLocation: '/splash',
    navigatorKey: _rootNavigatorKey,
    routes: [
      ShellRoute(
        navigatorKey: _homeNavigatorKey,
        builder: (context, state, child) => HomeNavigationBar(child: child),
        routes: [
          GoRoute(
            name: "home",
            path: '/',
            builder: (context, state) => HomeScreen(title: "Home"),
            routes: [
              GoRoute(
                  name: "recipes",
                  path: 'recipes',
                  builder: (context, state) => RecipesScreen(),
                  routes: [
                    GoRoute(
                      name: "addRecipe",
                      path: 'addRecipe',
                      builder: (context, state) => AddRecipeScreen(title: "Add a recipe"),
                    ),
                    GoRoute(
                      name: "recipeDetails",
                      path: 'recipeDetails/:name',
                      builder: (context, state) {
                        final recipeName = state.pathParameters['name']!;
                        return RecipeDetailsScreen(title: recipeName);
                      },
                    ),
                  ]
              ),
              GoRoute(
                name: "scan",
                path: 'scanning',
                builder: (context, state) => ScanningScreen(title: "Scan"),
              ),
              GoRoute(
                  name: "inventory",
                  path: 'inventory',
                  builder: (context, state) => InventoryScreen(),
                  routes: [
                    GoRoute(
                      name: "addItem",
                      path: 'addItem',
                      builder: (context, state) => AddItemScreen(title: "Add item"),
                    )
                  ]
              ),
              GoRoute(
                name: "settings",
                path: '/settings',
                parentNavigatorKey: _rootNavigatorKey,
                builder: (context, state) => SettingsScreen(title: "Settings"),
              ),
            ]
          ),
        ],
      ),
      GoRoute(
        name: "login",
        path: '/login',
        builder: (context, state) {
          final email = state.extra as String?;
          return LoginScreen(title: "Login", email: email ?? "");
        },
        routes: [
          GoRoute(
            name: "forgotPassword",
            path: 'forgotPassword',
            builder: (context, state) => ForgotPasswordScreen(title: "Forgot Password"),
            routes: [
              GoRoute(
                name: "resetPassword",
                path: 'resetPassword',
                builder: (context, state) => ResetPasswordScreen(title: "Reset Password"),
              ),
            ]
          ),
          GoRoute(
            name: "signUp",
            path: 'signUp',
            builder: (context, state) => SignUpScreen(title: "Sign Up"),
          )
        ]
      ),
      GoRoute(
        name: "viewReceipt",
        path: "/viewReceipt",
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) {
          final file = state.extra as File?;
          return ViewReceiptScreen(imageFile: file);
        },
      ),
      GoRoute(
        name: "splashScreen",
        path: "/splash",
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => SplashScreen(),
      )
    ]
);

GoRouter get router => _router; // Getter to access router