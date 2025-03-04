import 'package:flutter/cupertino.dart';
import 'package:food_manager/screens/add_recipe_screen.dart';
import 'package:food_manager/screens/forgot_password.dart';
import 'package:food_manager/screens/home_screen.dart';
import 'package:food_manager/screens/inventory_screen.dart';
import 'package:food_manager/screens/item_details_screen.dart';
import 'package:food_manager/screens/login_screen.dart';
import 'package:food_manager/screens/notifications_screen.dart';
import 'package:food_manager/screens/recipe_details_screen.dart';
import 'package:food_manager/screens/recipes_screen.dart';
import 'package:food_manager/screens/reset_password.dart';
import 'package:food_manager/screens/scanning_screen.dart';
import 'package:food_manager/screens/settings_screen.dart';
import 'package:food_manager/widgets/homeNavigationBar.dart';
import 'package:go_router/go_router.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _homeNavigatorKey = GlobalKey<NavigatorState>();

final GoRouter _router =  GoRouter(
  initialLocation: '/login',
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
                  builder: (context, state) => RecipesScreen(title: "Recipes"),
                  routes: [
                    GoRoute(
                      name: "addRecipe",
                      path: 'addRecipe',
                      builder: (context, state) => AddRecipeScreen(title: "Add a recipe"),
                    ),
                    GoRoute(
                      name: "recipeDetails",
                      path: 'recipeDetails',
                      builder: (context, state) => RecipeDetailsScreen(title: "Recipe Details"),
                      routes: [
                        GoRoute(
                          name: "ingredientDetails",
                          path: "ingredientDetails",
                          builder: (context, state) => ItemDetailsScreen(title: "Item Details"),
                        )
                      ]
                    ),
                  ]
              ),
              GoRoute(
                name: "scan",
                path: 'scanning',
                builder: (context, state) => ScanningScreen(title: "Scan"),
                routes: [
                  GoRoute(
                    name: "scannedItemDetails",
                    path: 'scannedItemDetails',
                    builder: (context, state) => ItemDetailsScreen(title: "Item Details"),
                  ),
                ],
              ),
              GoRoute(
                  name: "inventory",
                  path: 'inventory',
                  builder: (context, state) => InventoryScreen(title: "Inventory"),
                  routes: [
                    GoRoute(
                      name: "itemDetails",
                      path: 'itemDetails',
                      builder: (context, state) => ItemDetailsScreen(title: "Item Details"),
                    ),
                  ]
              ),
              GoRoute(
                name: "notifications",
                path: 'notifications',
                builder: (context, state) => NotificationsScreen(title: "Notifications"),
                  routes: [
                    GoRoute(
                      name: "itemNotification",
                      path: 'itemNotification',
                      builder: (context, state) => ItemDetailsScreen(title: "Temporary Notification info"),
                    ),
                  ]
              ),
              GoRoute(
                name: "settings",
                path: 'settings',
                builder: (context, state) => SettingsScreen(title: "Settings"),
              )
            ]
          ),
        ],
      ),
      GoRoute(
        name: "forgotPassword",
        path: '/forgotPassword',
        builder: (context, state) => ForgotPasswordScreen(title: "Forgot Password"),
      ),
      GoRoute(
        name: "login",
        path: '/login',
        builder: (context, state) => LoginScreen(title: "Login"),
      ),
      GoRoute(
        name: "resetPassword",
        path: '/resetPassword',
        builder: (context, state) => ResetPasswordScreen(title: "Reset Password"),
      ),
    ]
);

GoRouter get router => _router; // Getter to access router