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
  @override
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final emailController =  TextEditingController();
  String errorMessage = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      resizeToAvoidBottomInset: false,
      body: Column(
        children: [
          Expanded(
            flex: 20,
            child:
            Image(
                image: NetworkImage(
                    'https://cdn.pixabay.com/photo/2024/02/23/08/27/apple-8591539_1280.jpg'
                ),
                fit: BoxFit.cover
            ),
          ),
          Expanded(
            flex: 80,
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.only(top: 15, bottom: 15),
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
                                  errorMessage = "Please fill out all fields";
                                });
                                return; // Stop execution
                              }

                              if (passwordText != confirmPasswordText) {
                                setState(() {
                                  errorMessage = "Passwords do not match";
                                });
                                return;
                              }

                              try {
                                final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
                                  email: emailText,
                                  password: passwordText,
                                );

                                setState(() {
                                  errorMessage = "Successfully created account!";
                                });

                                // Delay before navigation
                                await Future.delayed(Duration(seconds: 3));

                                if (!context.mounted) return;  // Prevents navigation if widget is unmounted
                                context.go('/login');
                              } on FirebaseAuthException catch (e) {
                                setState(() {
                                  if (e.code == 'weak-password') {
                                    errorMessage = 'The password provided is too weak.';
                                  } else if (e.code == 'email-already-in-use') {
                                    errorMessage = 'The account already exists for that email.';
                                  } else {
                                    errorMessage = "An unknown error occurred.";
                                  }
                                });
                              } catch (e) {
                                setState(() {
                                  errorMessage = e.toString();
                                });
                              }

                              await Future.delayed(Duration(seconds: 3));

                              setState(() {
                                errorMessage = "";
                              });
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
                            child: Text("Create Account")
                        )
                    )
                ),
                Container(
                  margin: EdgeInsets.only(left: 35, right: 35, bottom: 10, top: 15),
                  child: Text(errorMessage),
                )
              ],
            ),
          )
          /*
           FloatingActionButton(
             onPressed: () {
               showDialog(
                 context: context,
                 builder: (context) {
                   return AlertDialog(
                     content: Text("password: ${passwordController.text} email: ${emailController.text}"),
                   );
                 },
               );
             }
           )
           */
        ],
      ),
    );
  }
}

