import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:project3/Signup_2.dart';
import 'package:project3/SupplierLogin.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({Key? key}) : super(key: key);

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final TextEditingController username = TextEditingController();
  final TextEditingController password1 = TextEditingController();
  final TextEditingController password2 = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController phone = TextEditingController();

  String? message;

  Future<void> signUp() async {
    final String user = username.text;
    final String mail = email.text;
    final String phoneno = phone.text;

    try {
      final usernameResponse = await http.get(
        Uri.parse('http://192.168.1.143:3000/s_id?user=$user'),
      );
      if (usernameResponse.statusCode == 200) {
        final Map<String, dynamic> userData = json.decode(usernameResponse.body);
        final String usernameMessage = userData['message'];
        if (usernameMessage == 'existing user') {
          showQuickAlert(context, 'Username already exists.');
          return;
        }
        if (usernameMessage == 'new user') {
          message = 'new user';
        }
      }

      final emailResponse = await http.get(
        Uri.parse('http://192.168.1.143:3000/s_email?email=$mail'),
      );
      if (emailResponse.statusCode == 200) {
        final Map<String, dynamic> emailData = json.decode(emailResponse.body);
        final String emailMessage = emailData['message'];
        if (emailMessage == 'existing user') {
          showQuickAlert(context, 'Email already exists.');
          return;
        }
        if (emailMessage == 'new user') {
          message = 'new user';
        }
      }

      final phoneResponse = await http.get(
        Uri.parse('http://192.168.1.143:3000/s_phone?phone=$phoneno'),
      );
      if (phoneResponse.statusCode == 200) {
        final Map<String, dynamic> phoneData = json.decode(phoneResponse.body);
        final String phoneMessage = phoneData['message'];
        if (phoneMessage == 'existing user') {
          showQuickAlert(context, 'Phone number already exists.');
          return;
        }
        if (phoneMessage == 'new user') {
          message = 'new user';
        }
      }

      if (password1.text != password2.text) {
        showQuickAlert(context, 'Passwords are not matching');
        return;
      }

      if (message == 'new user') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => Signup_2(
              username: username.text,
              email: email.text,
              phone: phone.text,
              password: password1.text,
            ),
          ),
        );
      }
    } catch (e) {
      debugPrint('Error during sign up: $e');
      showQuickAlert(context, 'An error occurred. Please try again.');
    }
  }

  void showQuickAlert(BuildContext context, String message) {
    QuickAlert.show(
      context: context,
      type: QuickAlertType.error,
      text: message,
    );
  }

  bool isEmailValid(String email) {
    final emailRegExp = RegExp(
      r'^[^@]+@[^@]+\.[^@]+',
    );
    return emailRegExp.hasMatch(email);
  }

  bool isPhoneValid(String phone) {
    final phoneRegExp = RegExp(
      r'^\d{10}$',
    );
    return phoneRegExp.hasMatch(phone);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                const SizedBox(height: 40.0),
                const SizedBox(
                  height: 40,
                ),
                Center(
                  child: const Text(
                    "Sign up",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  "Create your account",
                  style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                CustomTextField(
                  hintText: "Username",
                  prefixIcon: Icons.person,
                  controller: username,
                ),
                const SizedBox(height: 10,),
                CustomTextField(
                  hintText: "Email",
                  prefixIcon: Icons.email,
                  controller: email,
                ),
                const SizedBox(height: 10,),
                CustomTextField(
                  hintText: "Phone No.",
                  prefixIcon: Icons.phone,
                  controller: phone,
                  obscureText: false,
                ),
                const SizedBox(height: 10,),
                CustomTextField(
                  hintText: "Password",
                  prefixIcon: Icons.lock,
                  controller: password1,
                  obscureText: true,
                ),
                const SizedBox(height: 10,),
                CustomTextField(
                  hintText: "Confirm Password",
                  prefixIcon: Icons.lock,
                  controller: password2,
                  obscureText: true,
                ),
                const SizedBox(height: 10,),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    if (username.text.isEmpty ||
                        email.text.isEmpty ||
                        phone.text.isEmpty ||
                        password1.text.isEmpty ||
                        password2.text.isEmpty) {
                      QuickAlert.show(
                        context: context,
                        type: QuickAlertType.warning,
                        text: 'All fields are required',
                      );
                    } else if (!isEmailValid(email.text)) {
                      QuickAlert.show(
                        context: context,
                        type: QuickAlertType.error,
                        text: 'Invalid email format',
                      );
                    } else if (!isPhoneValid(phone.text)) {
                      QuickAlert.show(
                        context: context,
                        type: QuickAlertType.error,
                        text: 'Phone number must be 10 digits',
                      );
                    } else if (password1.text != password2.text) {
                      QuickAlert.show(
                        context: context,
                        type: QuickAlertType.error,
                        text: 'Passwords are not matching',
                      );
                    } else {
                      await signUp();
                    }
                  },
                  child: const Text(
                    "Sign up",
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    minimumSize: const Size(double.infinity, 0),
                    backgroundColor: Color.fromARGB(255, 4, 18, 67),
                  ),
                ),
                const SizedBox(height: 10,),
                const Text("Or", textAlign: TextAlign.center),
                const SizedBox(height: 10,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const Text("Already have an account?"),
                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SupplierLogin()),
                        );
                      },
                      child: const Text(
                        "Login",
                        style: TextStyle(color: Colors.blue),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CustomTextField extends StatelessWidget {
  final String hintText;
  final IconData prefixIcon;
  final bool obscureText;
  final TextEditingController controller;

  const CustomTextField({
    Key? key,
    required this.hintText,
    required this.prefixIcon,
    required this.controller,
    this.obscureText = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(fontSize: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        fillColor: Color.fromARGB(255, 255, 255, 255),
        filled: true,
        prefixIcon: Icon(prefixIcon),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
      ),
      obscureText: obscureText,
    );
  }
}
