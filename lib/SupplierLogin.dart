import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:project3/SignupPage.dart';
import 'package:project3/screens/supplier/SupplierNavHome.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

class SupplierLogin extends StatefulWidget {
  const SupplierLogin({Key? key}) : super(key: key);

  @override
  State<SupplierLogin> createState() => _SupplierLoginState();
}

class _SupplierLoginState extends State<SupplierLogin> {
  String? message1;
  String? message2;

  final TextEditingController username = TextEditingController();
  final TextEditingController password = TextEditingController();

  Future<void> UserLogin() async {
    final String user = username.text;
    final response = await http.get(
      Uri.parse('http://192.168.1.143:3000/s_username?user=$user'),
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      message1 = data['message'];
    }
    if (message1 == 'invalid user') {
      username.clear();
      password.clear();
      showQuickAlert(context, 'Invalid username');
    } else {
      final String pass = password.text;
      final response = await http.get(
        Uri.parse('http://192.168.1.143:3000/s_password?pass=$pass&user=$user'),
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        message2 = data['message'];
      }
      if (message2 == 'valid') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => SupplierNavHome(username: username.text),
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
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: [
                  Text(
                    "Welcome Supplier",
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                  Text("Enter your credential to login"),
                ],
              ),
              SizedBox(
                height: 70,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextField(
                    controller: username,
                    decoration: InputDecoration(
                      hintText: "Username or Email",
                      hintStyle: TextStyle(fontSize: 16),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      fillColor: Colors.white,
                      filled: true,
                      prefixIcon: const Icon(Icons.person),
                      contentPadding: EdgeInsets.symmetric(
                          vertical: 10, horizontal: 20), // Adjust padding
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: password,
                    decoration: InputDecoration(
                      hintText: "Password,",
                      hintStyle: TextStyle(fontSize: 16),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      fillColor: Colors.white,
                      filled: true,
                      prefixIcon: const Icon(Icons.password),
                      contentPadding: EdgeInsets.symmetric(
                          vertical: 10, horizontal: 20), // Adjust padding
                    ),
                    obscureText: true,
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () async {
                      if (username.text.isEmpty || password.text.isEmpty) {
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
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding:  EdgeInsets.symmetric(
                          vertical: 10, horizontal: 20),
                      minimumSize: const Size(double.infinity, 0),
                      backgroundColor: Color.fromARGB(255, 4, 18, 67),
                      
                    ),
                    child: const Text(
                      "Login",
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Don't have an account? "),
                      TextButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SignupPage()),
                          );
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
            ],
          ),
        ),
      ),
    );
  }
}
