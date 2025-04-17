import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key, required this.title});

  final String title;

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final emailController =  TextEditingController();
  String createAccountText = "Create Account";
  String errorMessage = "";

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
                  margin: EdgeInsets.only(top: 50, bottom: 15),
                  child: Text(
                    'Create an account',
                    style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 35, right: 35, bottom: 10, top: 10),
                  child: TextField(
                    obscureText: false,
                    controller:  emailController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      labelText: 'Email',
                      prefixIcon: Icon(Icons.email),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 35, right: 35, top: 10, bottom: 10),
                  child: TextField(
                    obscureText: true,
                    controller: passwordController,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        labelText: 'Password',
                        prefixIcon: Icon(Icons.password)
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 35, right: 35, top: 10, bottom: 10),
                  child: TextField(
                    obscureText: true,
                    controller: confirmPasswordController,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        labelText: 'Confirm Password',
                        prefixIcon: Icon(Icons.password)
                    ),
                  ),
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
                      ],
                    )
                ),
                Container(
                    margin: EdgeInsets.only(left: 35, right: 35),
                    child: SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: FilledButton.tonal(
                            onPressed: () async {
                              String emailText = emailController.text;
                              String passwordText = passwordController.text;
                              String confirmPasswordText = confirmPasswordController.text;

                              // Validate input fields
                              if (emailText.isEmpty || passwordText.isEmpty || confirmPasswordText.isEmpty) {
                                setState(() {
                                  createAccountText = "Please fill out all fields";
                                });
                                await Future.delayed(Duration(seconds: 3));
                                setState(() {
                                  createAccountText = "Create Account";
                                });
                                return; // Stop execution
                              }

                              if (passwordText != confirmPasswordText) {
                                setState(() {
                                  createAccountText = "Passwords do not match";
                                });
                                await Future.delayed(Duration(seconds: 3));
                                setState(() {
                                  createAccountText = "Create Account";
                                });
                                return;
                              }

                              try {
                                await FirebaseAuth.instance.createUserWithEmailAndPassword(
                                  email: emailText,
                                  password: passwordText,
                                );

                                setState(() {
                                  createAccountText = "Created account! Returning to log in...";
                                });

                                // Delay before navigation
                                await Future.delayed(Duration(seconds: 3));

                                if (!context.mounted) return;  // Prevents navigation if widget is unmounted
                                context.go('/login');
                              } on FirebaseAuthException catch (e) {
                                setState(() {
                                  if (e.code == 'weak-password') {
                                    createAccountText = 'The password provided is too weak.';
                                  } else if (e.code == 'email-already-in-use') {
                                    createAccountText = 'The account already exists for that email.';
                                  } else if (e.code == 'invalid-email') {
                                    createAccountText = 'The email address is badly formatted.';
                                  } else if (e.code == 'network-request-failed') {
                                    createAccountText = 'Network error, please try again later.';
                                  } else if (e.code == 'too-many-requests') {
                                    createAccountText = 'Too many requests. Please try again later.';
                                  } else if (e.code == 'operation-not-allowed') {
                                    createAccountText = 'Account creation is currently disabled.';
                                  } else {
                                    createAccountText = 'An unknown error occurred.';
                                  }
                                });

                                await Future.delayed(Duration(seconds: 3));
                                setState(() {
                                  createAccountText = "Create Account";
                                });
                              } catch (e) {
                                setState(() {
                                  createAccountText = e.toString();
                                });
                              }
                            },
                            style: ButtonStyle(
                              shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.0),
                                    side: BorderSide(color: Colors.black),
                                  )
                              ),
                              backgroundColor: WidgetStateProperty.all(Colors.lightBlueAccent),
                            ),
                            child: Text(createAccountText),
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

