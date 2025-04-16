import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:food_manager/ItemProvider.dart';
import 'package:food_manager/recipeProvider.dart';
import 'package:food_manager/router.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'package:flutter/services.dart';
import 'theme/app_theme.dart';

late FirebaseFirestore _firestore;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,  // Only allow normal portrait mode
    DeviceOrientation.portraitDown, // Optional: Allow upside-down portrait
  ]);

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  _firestore = FirebaseFirestore.instance;

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ItemProvider()), // ItemProvider
        ChangeNotifierProvider(create: (context) => RecipeProvider()), // AuthProvider
        // Add other providers here as needed
      ],
      child: MyApp(),
    ),
  );
}

FirebaseFirestore get db => _firestore;

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: router,
      title: 'Flutter Demo',
      theme: AppTheme.getDarkTheme(),
      darkTheme: AppTheme.getDarkTheme(),
      themeMode: ThemeMode.system,
    );
  }
}
