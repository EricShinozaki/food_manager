import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key, required this.title});

  final String title;

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final passwordController = TextEditingController();
  final emailController =  TextEditingController();

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
                      'Login',
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
                   margin: EdgeInsets.only(left: 35, right: 35, top: 10),
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
                     margin: EdgeInsets.only(left: 180, right: 35),
                     child: TextButton(
                       onPressed: () => context.go('/login/forgotPassword'),
                       child: const Text('Forgot Password?'),
                     )
                 ),
                 Container(
                   margin: EdgeInsets.only(left: 35, right: 35),
                   child: SizedBox(
                       width: double.infinity,
                       height: 56,
                       child: FilledButton.tonal(
                         onPressed:(){
                           context.go('/');
                         },
                         style: ButtonStyle(
                             shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                                 RoundedRectangleBorder(
                                     borderRadius: BorderRadius.circular(20.0),
                                 )
                             ),
                           backgroundColor: WidgetStateProperty.all(Colors.lightBlueAccent),
                         ),
                         child: Text("Login")
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
                     child: SizedBox(
                         width: double.infinity,
                         height: 56,
                         child: FilledButton.tonal(
                             onPressed:(){
                               context.go('/');
                             },
                             style: ButtonStyle(
                               shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                                   RoundedRectangleBorder(
                                     borderRadius: BorderRadius.circular(20.0),
                                     side: BorderSide(color: Colors.black),
                                   )
                               ),
                               backgroundColor: WidgetStateProperty.all(Colors.white),
                             ),
                             child: Text("Sign Up")
                         )
                     )
                 ),
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
