import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:project3/AdminSignUp.dart';
import 'package:project3/LoginPage.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

class CompanyRegisterPage extends StatefulWidget {
  const CompanyRegisterPage({Key? key}) : super(key: key);

  @override
  State<CompanyRegisterPage> createState() => _CompanyRegisterPageState();
}

class _CompanyRegisterPageState extends State<CompanyRegisterPage> {
  final TextEditingController id = TextEditingController();
  final TextEditingController name = TextEditingController();
  final TextEditingController add1 = TextEditingController();
  final TextEditingController add2 = TextEditingController();
  final TextEditingController add3 = TextEditingController();
  final TextEditingController code = TextEditingController();
  final TextEditingController mail = TextEditingController();
  final TextEditingController web = TextEditingController();
  final TextEditingController phone = TextEditingController();
  String? message;
  String status = '';

  Future<void> CompanyRegister() async {
    final String cid = id.text;
    final String email = mail.text;
    final String cname = name.text;

    // Check if username already exists
    final usernameResponse = await http.get(
      Uri.parse('http://192.168.1.142:3000/cid?cid=$cid'),
    );
    if (usernameResponse.statusCode == 200) {
      final Map<String, dynamic> userData = json.decode(usernameResponse.body);
      final String usernameMessage = userData['message'];
      if (usernameMessage == 'existing company') {
        showQuickAlert(context, 'Company already exists.');
        return; // Stop further processing
      }
      if (usernameMessage == 'new company') {
        message = 'new company';
      }
    }

    // Check if email already exists
    final emailResponse = await http.get(
      Uri.parse('http://192.168.1.142:3000/c_email?email=$email'),
    );
    if (emailResponse.statusCode == 200) {
      final Map<String, dynamic> emailData = json.decode(emailResponse.body);
      final String emailMessage = emailData['message'];
      if (emailMessage == 'existing company') {
        showQuickAlert(context, 'Email already exists.');
        return; // Stop further processing
      }
      if (emailMessage == 'new company') {
        message = 'new company';
      }
    }

    // Check if phone number already exists
    final phoneResponse = await http.get(
      Uri.parse('http://192.168.1.142:3000/c_name?cname=$cname'),
    );
    if (phoneResponse.statusCode == 200) {
      final Map<String, dynamic> phoneData = json.decode(phoneResponse.body);
      final String phoneMessage = phoneData['message'];

      if (phoneMessage == 'existing company') {
        showQuickAlert(context, 'Company already exists.');
        return; // Stop further processing
      }

      if (phoneMessage == 'new company') {
        message = 'new company';
      }
    }

    if (message == 'new company') {
      final response = await http.post(
        Uri.parse('http://192.168.1.142:3000/company_register'),
        body: {
          'id': id.text,
          'name': name.text,
          'add1': add1.text,
          'add2': add2.text,
          'add3': add3.text,
          'web': web.text,
          'mail': mail.text,
          'phone': phone.text,
          'code': code.text,
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        status = responseData['message'];
        if (status == 'company registered') {
          QuickAlert.show(
            context: context,
            type: QuickAlertType.success,
            title: 'Success',
            text: 'Company registered',
          );
          await Future.delayed(Duration(seconds: 2));
          Navigator.pop(context);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => AdminSignUp(),
            ),
          );
        } else {
          QuickAlert.show(
            context: context,
            type: QuickAlertType.error,
            text: 'Failed to register company',
          );
        }
      } else {
        status = 'Internal Server Error';
      }

      // Clear text fields after signup
      id.clear();
      name.clear();
      add1.clear();
      add2.clear();
      add3.clear();
      web.clear();
      mail.clear();
      phone.clear();
      code.clear();
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
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              
              const SizedBox(height: 40),
              Center(
                child: const Text(
                  "Welcome start a new journey",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Image.asset(
                'assets/company.jpg',
                height: 150,
                width: 100,
              ),
              const SizedBox(height: 10),
              Center(
                child: const Text(
                  "Register your Company",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              
              Row(
                children: [
                  Expanded(
                    child: CustomTextField(
                      hintText: "Company Id",
                      prefixIcon: Icons.business,
                      controller: id,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: CustomTextField(
                      hintText: "Name",
                      prefixIcon: Icons.business,
                      controller: name,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10,),
              Row(
                children: [
                  Expanded(
                    child: CustomTextField(
                      hintText: "Address Line 1",
                      prefixIcon: Icons.location_city,
                      controller: add1,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: CustomTextField(
                      hintText: "Address Line 2",
                      prefixIcon: Icons.location_city,
                      controller: add2,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10,),
              Row(
                children: [
                  Expanded(
                    child: CustomTextField(
                      hintText: "Address Line 3",
                      prefixIcon: Icons.location_city,
                      controller: add3,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: CustomTextField(
                      hintText: "Country code",
                      prefixIcon: Icons.code,
                      controller: code,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              CustomTextField(
                hintText: "Email",
                prefixIcon: Icons.mail,
                controller: mail,
              ),
              const SizedBox(height: 10,),
              CustomTextField(
                hintText: "Phone",
                prefixIcon: Icons.phone,
                controller: phone,
              ),
              const SizedBox(height: 10,),
              CustomTextField(
                hintText: "Website",
                prefixIcon: Icons.web,
                controller: web,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (id.text.isEmpty ||
                      name.text.isEmpty ||
                      add1.text.isEmpty ||
                      add2.text.isEmpty ||
                      add3.text.isEmpty ||
                      web.text.isEmpty ||
                      mail.text.isEmpty ||
                      phone.text.isEmpty ||
                      code.text.isEmpty) {
                    QuickAlert.show(
                      context: context,
                      type: QuickAlertType.warning,
                      text: 'All fields are required',
                    );
                  } else if (!isValidEmail(mail.text)) {
                    QuickAlert.show(
                      context: context,
                      type: QuickAlertType.warning,
                      text: 'Enter a valid email address',
                    );
                  } else if (!isValidPhoneNumber(phone.text)) {
                    QuickAlert.show(
                      context: context,
                      type: QuickAlertType.warning,
                      text: 'Enter a valid phone number',
                    );
                  } else {
                    await CompanyRegister();
                  }
                },
                child: const Text(
                  "Sign up",
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  minimumSize: const Size(double.infinity, 0),
                  backgroundColor: Color.fromARGB(255, 4, 18, 67),
                ),
              ),
              const SizedBox(height: 10,),
              const Text("Or", textAlign: TextAlign.center),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Text("Already have an account?"),
                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LoginPage(),
                        ),
                      );
                    },
                    child: const Text(
                      "Login",
                      style: TextStyle(color: Colors.blue),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40),
            ],
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
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide.none,
        ),
        fillColor: Color.fromARGB(255, 52, 86, 208).withOpacity(0.1),
        filled: true,
        prefixIcon: Icon(prefixIcon),
        contentPadding: EdgeInsets.symmetric(
            vertical: 3, horizontal: 5), // Adjust padding here
      ),
      obscureText: obscureText,
    );
  }
}

bool isValidEmail(String email) {
  final RegExp emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
  return emailRegex.hasMatch(email);
}

bool isValidPhoneNumber(String phoneNumber) {
  final RegExp phoneRegex = RegExp(r'^[0-9]{10,}$');
  return phoneRegex.hasMatch(phoneNumber);
}
