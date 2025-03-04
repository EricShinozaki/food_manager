import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key, required this.title});

  final String title;

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Column(
         children: [
           Expanded(
             flex: 40,
             child:
               Image(
                 image: NetworkImage(
                   'https://cdn.pixabay.com/photo/2024/02/23/08/27/apple-8591539_1280.jpg',
                 )
               ),
           ),
           Expanded(
             flex: 50,
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
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Email',
                    ),
                   ),
                 ),
                 Container(
                   margin: EdgeInsets.only(left: 35, right: 35, bottom: 10, top: 10),
                   child: TextField(
                     obscureText: true,
                     decoration: InputDecoration(
                       border: OutlineInputBorder(),
                       labelText: 'Password',
                     ),
                   ),
                 ),
                 Container(
                   margin: EdgeInsets.only(left: 35, right: 35, bottom: 10, top: 10),
                   child: Text(
                       'Forgot Password?',
                       style: TextStyle(
                         color: Colors.red,
                       )
                   ),
                 ),
                 Container(
                   margin: EdgeInsets.only(left: 35, right: 35),
                   child: FloatingActionButton(
                     child: Text("Login"),
                     onPressed:(){
                       context.go('/');
                     },
                   )
                 ),
               ],
             ),
           ),
           Expanded(
             flex: 10,
             child: Row(
               children: [
                 Text('App Logo')
               ],
             )
           )
         ],
      ),
    );
  }
}

/*
ElevatedButton(
onPressed: () {
// Navigate to the inventory screen
GoRouter.of(context).go('/');
},
child: const Text('Login'),
),
 */
