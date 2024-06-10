import 'dart:convert';

import 'package:emailjs/emailjs.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:project3/screens/Admin/Admin_Homepage.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

class AddManagersScreen extends StatefulWidget {
  const AddManagersScreen({Key? key}) : super(key: key);

  @override
  State<AddManagersScreen> createState() => _AdminSignUpState();
}

class _AdminSignUpState extends State<AddManagersScreen> {
  final TextEditingController username = TextEditingController();
  final TextEditingController password1 = TextEditingController();
  final TextEditingController password2 = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController phone = TextEditingController();
  final TextEditingController fname = TextEditingController();
  final TextEditingController lname = TextEditingController();

  String? message;
  String? status;
  String? loginuser;
  String? loginpass;

  Future<void> SignUp() async {
    final String user = username.text;
    final String mail = email.text;
    final String phoneno = phone.text;

    // Check if username already exists
    final usernameResponse = await http.get(
      Uri.parse('http://192.168.1.143:3000/emp_id?user=$user'),
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

    // Check if email already exists
    final emailResponse = await http.get(
      Uri.parse('http://192.168.1.143:3000/emp_email?email=$mail'),
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

    // Check if phone number already exists
    final phoneResponse = await http.get(
      Uri.parse('http://192.168.1.143:3000/emp_phone?phone=$phoneno'),
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
      final response = await http.post(
        Uri.parse('http://192.168.1.143:3000/emp_register'),
        body: {
          'empid': username.text,
          'first_name': fname.text,
          'last_name': lname.text,
          'password': password1.text,
          'email': email.text,
          'phone': phone.text,
          'type': 'manager'
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        status = responseData['message'];
      } else {
        status = 'Internal Server Error';
      }

      // Clear text fields after signup
      username.clear();
      fname.clear();
      lname.clear();
      email.clear();
      phone.clear();
      password1.clear();
      password2.clear();
    }
  }

 Future<int?> sendEmail() async {
  loginuser = username.text;
  loginpass = password1.text;
  final String mail = email.text;

  final url = Uri.parse("https://api.emailjs.com/api/v1.0/email/send");
  const serviceId = "service_o8lry5b";
  const templateId = "template_nvkn4lc";

  EmailJS.init(const Options(
  publicKey: 'DDEFKrUpyJr-1flWt',
  privateKey: 'jBNDnqSgwaFv0h0PCr1Ev',
));

  try {
    final response = await http.post(
      url,
      headers: {
        'orgin':'http://localhost/',
        'Content-Type': 'application/json',},
      body: json.encode({
        "service_id": serviceId,
        "template_id": templateId,
     
        "template_params": {
          "name": "DEEPAK",
          "subject": 'Login Credentials',
          "content": 'Your credentials are',
          "userid": loginuser,
          "pass": loginpass,
          "user_email": mail,
        }
      }),
    );

    if (response.statusCode == 200) {
      print('Email sent successfully');
    } else {
      print('Failed to send email: ${response.statusCode}');
    }

    return response.statusCode;
  } catch (e) {
    print('Exception while sending email: $e');
    return null; // Or handle the exception according to your needs
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
      r'^\d+$',
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
            padding: const EdgeInsets.symmetric(horizontal: 20),
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
                    "Enroll an Employee",
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
                  "Create account for employee",
                  style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),
                CustomTextField(
                  hintText: "Username",
                  prefixIcon: Icons.person,
                  controller: username,
                ),
                const SizedBox(height: 12),
                CustomTextField(
                  hintText: "Email",
                  prefixIcon: Icons.email,
                  controller: email,
                ),
                const SizedBox(height: 12),
                CustomTextField(
                  hintText: "Phone No.",
                  prefixIcon: Icons.phone,
                  controller: phone,
                  obscureText: false,
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: CustomTextField(
                        hintText: "First Name",
                        prefixIcon: Icons.person,
                        controller: fname,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: CustomTextField(
                        hintText: "Last Name",
                        prefixIcon: Icons.person,
                        controller: lname,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                CustomTextField(
                  hintText: "Password",
                  prefixIcon: Icons.password,
                  controller: password1,
                  obscureText: true,
                ),
                const SizedBox(height: 12),
                CustomTextField(
                  hintText: "Confirm Password",
                  prefixIcon: Icons.password,
                  controller: password2,
                  obscureText: true,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    if (username.text.isEmpty ||
                        password1.text.isEmpty ||
                        password2.text.isEmpty ||
                        email.text.isEmpty ||
                        phone.text.isEmpty ||
                        fname.text.isEmpty ||
                        lname.text.isEmpty) {
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
                        text: 'Phone number must be numeric',
                      );
                    } else if (password1.text != password2.text) {
                      QuickAlert.show(
                        context: context,
                        type: QuickAlertType.error,
                        text: 'Passwords are not matching',
                      );
                    } else {
                      await SignUp();
                      if (status == 'Employee registered') {
                        QuickAlert.show(
                          context: context,
                          type: QuickAlertType.success,
                          title: 'Success',
                          text: 'Employee registered',
                        );
                        await sendEmail();
                        await Future.delayed(Duration(seconds: 2));
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => NavHomePage()),
                        );
                      }
                    }
                  },
                  child: const Text(
                    "Add User",
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
                const SizedBox(height: 40),
                /* const Text("Or", textAlign: TextAlign.center),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const Text("Already have an account?"),
                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => LoginPage()),
                        );
                      },
                      child: const Text(
                        "Login",
                        style: TextStyle(color: Colors.blue),
                      ),
                    ),
                  ],
                ),*/
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
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        fillColor: Colors.white,
        filled: true,
        prefixIcon: Icon(prefixIcon),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      ),
      obscureText: obscureText,
    );
  }
}
