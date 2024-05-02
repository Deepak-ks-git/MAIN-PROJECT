import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:project3/AdminHome.dart';
import 'package:project3/ManagerHome.dart';
import 'package:project3/SignupPage.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key});

  @override
  State<LoginPage> createState() => _EmpLoginState();
}

class _EmpLoginState extends State<LoginPage> {
  String? message1;
  String? message2;
  String? role;

  final TextEditingController username = TextEditingController();
  final TextEditingController password = TextEditingController();
  Future<void> UserLogin() async {
    final String user = username.text;
    final response = await http.get(
      Uri.parse('http://192.168.1.142:3000/username?user=$user'),
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      // Assign the message to the class variable
      message1 = data['message'];
    }
    if (message1 == 'invalid user') {
      username.clear();
      password.clear();
      showQuickAlert(context, 'Invalid username');
    } else {
      final String pass = password.text;
      final response = await http.get(
        Uri.parse('http://192.168.1.142:3000/login?user=$user&pass=$pass'),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        // Assign the message to the class variable
        message2 = data['message'];
      }
      if (message2 == 'valid') {
        final roleResponse = await http.get(
          Uri.parse('http://192.168.1.142:3000/role?user=$user'),
        );
        if (roleResponse.statusCode == 200) {
          final Map<String, dynamic> roleData = json.decode(roleResponse.body);
          role = roleData['role'];
          if (role == 'admin') {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => AdminHome()),
            );
          } else {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => ManagerHome()),
            );
          }
        }
      } else {
        showQuickAlert(context, 'Invalid Password');
      }
    }
  }

  void showQuickAlert(BuildContext context, String message) {
    QuickAlert.show(
      context: context,
      type: QuickAlertType.error,
      text: message,
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Container(
          margin: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                children: [
                  Text(
                    "Welcome Back",
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                  Text("Enter your credential to login"),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextField(
                    controller: username,
                    decoration: InputDecoration(
                      hintText: "Username or Email",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(18),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      prefixIcon: const Icon(Icons.person),
                      contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 15), // Adjust padding
                    ),
                    style: TextStyle(
                      height: 0.5, // Adjust height
                    ),
                  ),
                  const SizedBox(height: 5), // Reduced height between input boxes
                  TextField(
                    controller: password,
                    decoration: InputDecoration(
                      hintText: "Password",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(18),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      prefixIcon: const Icon(Icons.password),
                      contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 15), // Adjust padding
                    ),
                    obscureText: true,
                    style: TextStyle(
                      height: 0.5, // Adjust height
                    ),
                  ),
                  const SizedBox(height: 10), // Reduced height between input boxes and button
                  ElevatedButton(
                    onPressed: () async {
                      if (username.text.isEmpty && password.text.isEmpty) {
                        QuickAlert.show(
                          context: context,
                          type: QuickAlertType.warning,
                          text: 'All fields are required',
                        );
                      } else {
                        await UserLogin();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 50), // Adjust padding
                      backgroundColor: Color.fromARGB(255, 4, 18, 67),
                    ),
                    child: const Text(
                      "Login",
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    ),
                  )
                ],
              ),
              /* TextButton(
                onPressed: () {},
                child: const Text(
                  "Forgot password?",
                  //style: TextStyle(color: Colors.purple),
                ),
              ),*/
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Dont have an account? "),
                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SignupPage()));
                    },
                    child: const Text(
                      "Sign Up",
                      style: TextStyle(color: Colors.blue),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
