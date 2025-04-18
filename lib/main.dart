import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:food_manager/item_provider.dart';
import 'package:food_manager/recipe_provider.dart';
import 'package:food_manager/router.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'package:flutter/services.dart';
import 'theme/app_theme.dart';

// Custom transition builder
class SlowPageTransitionBuilder extends PageTransitionsBuilder {
  const SlowPageTransitionBuilder();

  @override
  Widget buildTransitions<T>(
      PageRoute<T> route,
      BuildContext context,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
      Widget child,
      ) {
    return FadeTransition(
      opacity: CurvedAnimation(
        parent: animation,
        curve: Curves.easeInOut,
      ),
      child: child,
    );
  }
}

late FirebaseFirestore _firestore;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Lock device to portrait
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  _firestore = FirebaseFirestore.instance;

  runApp(const AppInitializer());
}

FirebaseFirestore get db => _firestore;

class AppInitializer extends StatelessWidget {
  const AppInitializer({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ItemProvider()),
        ChangeNotifierProvider(create: (_) => RecipeProvider()),
      ],
      child: const MyApp(),
    );
  }
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeIn;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _fadeIn = Tween<double>(begin: 0.0, end: 1.0).animate(_controller);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeIn,
      child: MaterialApp.router(
        routerConfig: router,
        title: 'Flutter Demo',
        theme: AppTheme.getLightTheme().copyWith(
          pageTransitionsTheme: const PageTransitionsTheme(
            builders: {
              TargetPlatform.android: SlowPageTransitionBuilder(),
              TargetPlatform.iOS: SlowPageTransitionBuilder(),
            },
          ),
        ),
        darkTheme: AppTheme.getDarkTheme(),
        themeMode: ThemeMode.system,
      ),
    );
  }
}
