import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:project3/SignupPage.dart';
import 'package:project3/SupplierHome.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:http/http.dart' as http;

class SupplierLogin extends StatefulWidget {
  const SupplierLogin({Key? key});

  @override
  State<SupplierLogin> createState() => _EmpLoginState();
}

class _EmpLoginState extends State<SupplierLogin> {
  String? message1;
  String? message2;
  String? role;

  final TextEditingController username = TextEditingController();
  final TextEditingController password = TextEditingController();
  Future<void> UserLogin() async {
    final String user = username.text;
    final response = await http.get(
      Uri.parse('http://192.168.1.142:3000/s_username?user=$user'),
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
        Uri.parse('http://192.168.1.142:3000/s_password?pass=$pass'),
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        // Assign the message to the class variable
        message2 = data['message'];
      }
      if (message2 == 'valid') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => SupplierHome(username: username.text),
          ),
        );
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
                    "Welcome Supplier",
                    style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
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
                      fillColor:
                          Color.fromARGB(255, 52, 86, 208).withOpacity(0.1),
                      filled: true,
                      prefixIcon: const Icon(Icons.person),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: password,
                    decoration: InputDecoration(
                      hintText: "Password",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(18),
                        borderSide: BorderSide.none,
                      ),
                      fillColor:
                          Color.fromARGB(255, 52, 86, 208).withOpacity(0.1),
                      filled: true,
                      prefixIcon: const Icon(Icons.password),
                    ),
                    obscureText: true,
                  ),
                  const SizedBox(height: 20),
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
                      shape: const StadiumBorder(),
                      padding: const EdgeInsets.symmetric(vertical: 16),
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
