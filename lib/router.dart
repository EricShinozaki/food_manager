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
import 'package:go_router/go_router.dart';

final GoRouter _router =  GoRouter(
  initialLocation: '/login',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => HomeScreen(title: "Home"),
      ),
      GoRoute(
        path: '/addRecipe',
        builder: (context, state) => AddRecipeScreen(title: "Add a recipe"),
      ),
      GoRoute(
        path: '/forgotPassword',
        builder: (context, state) => ForgotPasswordScreen(title: "Forgot Password"),
      ),
      GoRoute(
        path: '/inventory',
        builder: (context, state) => InventoryScreen(title: "Inventory"),
      ),
      GoRoute(
        path: '/itemDetails',  // Can probably make item a variable
        builder: (context, state) => ItemDetailsScreen(title: "Item Details"),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => LoginScreen(title: "Login"),
      ),
      GoRoute(
        path: '/notifications',
        builder: (context, state) => NotificationsScreen(title: "Notifications"),
      ),
      GoRoute(
        path: '/recipeDetails',
        builder: (context, state) => RecipeDetailsScreen(title: "Recipe Details"),
      ),
      GoRoute(
        path: '/recipes',
        builder: (context, state) => RecipesScreen(title: "Recipes"),
      ),
      GoRoute(
        path: '/resetPassword',
        builder: (context, state) => ResetPasswordScreen(title: "Reset Password"),
      ),
      GoRoute(
        path: '/scanning',
        builder: (context, state) => ScanningScreen(title: "Scan"),
      ),
      GoRoute(
        path: '/settings',
        builder: (context, state) => SettingsScreen(title: "Settings"),
      ),
    ]
);

GoRouter get router => _router; // Getter to access router