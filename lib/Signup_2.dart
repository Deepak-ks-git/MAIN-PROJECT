import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:project3/HomeScreen.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:http/http.dart' as http;

class Signup_2 extends StatefulWidget {
  final String username;
  final String email;
  final String phone;
  final String password;

  const Signup_2({
    Key? key,
    required this.username,
    required this.email,
    required this.phone,
    required this.password,
  }) : super(key: key);

  @override
  _Signup_2State createState() => _Signup_2State();
}

class _Signup_2State extends State<Signup_2> {
  final TextEditingController fname = TextEditingController();
  final TextEditingController lname = TextEditingController();
  final TextEditingController cname = TextEditingController();
  final TextEditingController add1 = TextEditingController();
  final TextEditingController add2 = TextEditingController();
  final TextEditingController add3 = TextEditingController();
  final TextEditingController gst = TextEditingController();
  final TextEditingController phone2 = TextEditingController();

  String? status;

  Future<void> Register() async {
    final String first_name = fname.text;
    final String last_name = lname.text;
    final String alternate_number = phone2.text;
    final String company_name = cname.text;
    final String address1 = add1.text;
    final String address2 = add2.text;
    final String address3 = add3.text;
    final String gst_number = gst.text;
    final String supplier_id = widget.username;
    final String email = widget.email;
    final String password = widget.password;
    final String phone = widget.phone;

    final response = await http.post(
      Uri.parse('http://192.168.0.102:3000/s_register'),
      body: {
        'supplier_id': supplier_id,
        'password': password,
        'email': email,
        'phone': phone,
        'first_name': first_name,
        'last_name': last_name,
        'alternate_number': alternate_number,
        'company_name': company_name,
        'address1': address1,
        'address2': address2,
        'address3': address3,
        'gst_number': gst_number,
        'status':'Active'
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      status = responseData['message'];
    } else {
      status = 'Internal Server Error';
    }

    // Clear text fields after signup
    if (status == 'supplier registered') {
      showQuickAlert1(context, 'Registered Successfully');
      await Future.delayed(Duration(seconds: 2));
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomeScreen(),
        ),
      );
    } else {
      showQuickAlert2(context, 'Could not register');
      return;
    }
  }

  void showQuickAlert1(BuildContext context, String message) {
    QuickAlert.show(
      context: context,
      type: QuickAlertType.success,
      text: message,
    );
  }

  void showQuickAlert2(BuildContext context, String message) {
    QuickAlert.show(
      context: context,
      type: QuickAlertType.error,
      text: message,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Signup 2'),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const SizedBox(
                height: 30,
              ),
              Center(
                child: const Text(
                  "Complete Account Creation",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                "Provide your details",
                style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 30,
              ),
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
                hintText: "Company name",
                prefixIcon: Icons.business_center,
                controller: cname,
              ),
              const SizedBox(height: 12),
              CustomTextField(
                hintText: "Address 1",
                prefixIcon: Icons.place,
                controller: add1,
              ),
              const SizedBox(height: 12),
              CustomTextField(
                hintText: "Address 2",
                prefixIcon: Icons.place,
                controller: add2,
                obscureText: false,
              ),
              const SizedBox(height: 12),
              CustomTextField(
                hintText: "Address 3",
                prefixIcon: Icons.place,
                controller: add3,
                obscureText: true,
              ),
              const SizedBox(height: 12),
              CustomTextField(
                hintText: "GST Number",
                prefixIcon: Icons.numbers_sharp,
                controller: gst,
                obscureText: true,
              ),
              const SizedBox(height: 12),
              CustomTextField(
                hintText: "Alternate Phone no",
                prefixIcon: Icons.phone,
                controller: phone2,
                obscureText: true,
              ),
              const SizedBox(height: 12),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (fname.text.isEmpty ||
                      lname.text.isEmpty ||
                      cname.text.isEmpty ||
                      add1.text.isEmpty ||
                      add2.text.isEmpty ||
                      add3.text.isEmpty ||
                      gst.text.isEmpty ||
                      phone2.text.isEmpty) {
                    QuickAlert.show(
                      context: context,
                      type: QuickAlertType.warning,
                      text: 'All fields are required',
                    );
                  } else {
                    await Register();
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
              const SizedBox(height: 12),
              const SizedBox(height: 30),
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
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide.none,
        ),
        fillColor: Color.fromARGB(255, 52, 86, 208).withOpacity(0.1),
        filled: true,
        prefixIcon: Icon(prefixIcon),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 14, horizontal: 18),
      ),
      obscureText: obscureText,
    );
  }
}
