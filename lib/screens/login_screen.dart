import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_manager/item_provider.dart';
import 'package:food_manager/recipe_provider.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:food_manager/theme/app_theme.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key, required this.title, required this.email});

  final String title;
  final String email;

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final passwordController = TextEditingController();
  final emailController =  TextEditingController();
  String loginButtonText = "Login";

  @override
  void initState() {
    super.initState();
    emailController.text = widget.email;
  }

  @override
  void didUpdateWidget(covariant LoginScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if(widget.email != oldWidget.email){
      emailController.text = widget.email;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Text(widget.title),
      ),
      resizeToAvoidBottomInset: false,
      body: Column(
        children: [
          Expanded(
            flex: 80,
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.only(left: 35, right: 35, bottom: 10, top: 50),
                  child: TextField(
                    obscureText: false,
                    controller:  emailController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(AppTheme.defaultBorderRadius),
                      ),
                      labelText: 'Email',
                      prefixIcon: Icon(Icons.email),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 35, right: 35, top: 10),
                  child: TextField(
                    obscureText: true,
                    controller: passwordController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(AppTheme.defaultBorderRadius),
                      ),
                      labelText: 'Password',
                      prefixIcon: Icon(Icons.password),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 180, right: 35),
                  child: Align(
                    alignment: Alignment.topRight,
                    child: TextButton(
                      onPressed: () => context.go('/login/forgotPassword'),
                      child: const Text('Forgot Password?'),
                    ),
                  ),
                ),
                Container(
                    margin: EdgeInsets.only(left: 35, right: 35),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.lightBlueAccent.shade100,
                          Colors.blueAccent.shade400,
                        ],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: FilledButton.tonal(onPressed: () async {
                          try {
                            await FirebaseAuth.instance.signInWithEmailAndPassword(
                              email: emailController.text,
                              password: passwordController.text,
                            );

                            setState(() {
                              loginButtonText = "Login Successful";
                            });

                            // Fetch data for the new user
                            await Future.wait([
                              Provider.of<ItemProvider>(context, listen: false).fetchItems(),
                              Provider.of<RecipeProvider>(context, listen: false).fetchRecipes(),
                            ]);

                            if (!context.mounted) return;
                            context.go('/');
                          } on FirebaseAuthException catch (e) {
                            if (e.code == 'user-not-found' || e.code == 'wrong-password') {
                              setState(() {
                                loginButtonText = "Incorrect email or password";
                              });
                            } else {
                              setState(() {
                                loginButtonText = "Invalid email or password";
                              });
                            }

                            await Future.delayed(Duration(seconds: 3));
                            setState(() {
                              loginButtonText = "Login";
                            });
                          }
                        },
                          style: ButtonStyle(
                            backgroundColor:
                            WidgetStateProperty.all(Colors.transparent),
                            shadowColor:
                            WidgetStateProperty.all(Colors.transparent),
                            shape: WidgetStateProperty.all(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            padding: WidgetStateProperty.all(
                              const EdgeInsets.symmetric(vertical: 18),
                            ),
                          ),
                          child: Text(loginButtonText, style: TextStyle(color: AppColors.buttonText)),
                        )
                    )
                ),
                Container(
                    margin: EdgeInsets.only(left: 35, right: 35, top: 20, bottom: 20),
                    child: Row(
                      children: [
                        Expanded(
                            child: Divider(
                              thickness: 1,
                              color: Colors.black,
                            )
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text('Or'),
                        ),
                        Expanded(
                            child: Divider(
                              thickness: 1,
                              color: Colors.black,
                            )
                        )
                      ],
                    )
                ),
                Container(
                    margin: EdgeInsets.only(left: 35, right: 35),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.orange.shade600,
                          Colors.red.shade400,
                        ],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: FilledButton.tonal(
                          onPressed:(){
                            context.go('/login/signUp');
                          },
                          style: ButtonStyle(
                            backgroundColor:
                            WidgetStateProperty.all(Colors.transparent),
                            shadowColor:
                            WidgetStateProperty.all(Colors.transparent),
                            shape: WidgetStateProperty.all(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            padding: WidgetStateProperty.all(
                              const EdgeInsets.symmetric(vertical: 18),
                            ),
                          ),
                          child: Text("Sign Up",
                              style: TextStyle(
                                  color: AppColors.buttonText
                              )
                          ),
                        )
                    )
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
