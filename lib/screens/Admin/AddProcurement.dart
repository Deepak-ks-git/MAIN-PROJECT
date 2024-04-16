import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

class AddProcurement extends StatefulWidget {
  const AddProcurement({Key? key}) : super(key: key);

  @override
  State<AddProcurement> createState() => _AddItemScreenState();
}

class _AddItemScreenState extends State<AddProcurement> {
  String? message;

  final TextEditingController desc = TextEditingController();


  Future<void> addProcList() async {
    final response = await http.post(
      Uri.parse('http://192.168.0.102:3000/addProc'),
      body: {

        'status':'CREATED',
        'description':desc.text,
        'user_id':'admin',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      message = responseData['message'];
    } else {
      message = 'Internal Server Error';
    }

    // Clear text fields after signup
    
    desc.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create A New Procurement')),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const SizedBox(height: 40.0),
              const SizedBox(height: 40),
              Center(
                child: const Text(
                  "Start with some Informaton ",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              
             
              const SizedBox(height: 12),
              Container(
                height: 120, // Adjust the height here for 3 lines
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
                  color:
                      const Color.fromARGB(255, 52, 86, 208).withOpacity(0.1),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: TextField(
                  controller: desc,
                  decoration: InputDecoration(
                    hintText: "Description of the Procurment",
                    border: InputBorder.none,
                  ),
                  keyboardType: TextInputType.multiline,
                  maxLines: null, // Allow multiple lines
                  textInputAction:
                      TextInputAction.newline, // Allow creating new lines
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (desc.text.isEmpty 
                     ) {
                    QuickAlert.show(
                      context: context,
                      type: QuickAlertType.warning,
                      text: 'All fields are required',
                    );
                  } else {
                    await addProcList();
                    if (message == 'Procurement Added') {
                      QuickAlert.show(
                        context: context,
                        type: QuickAlertType.success,
                        title: 'Success',
                        text: 'Procurement Created',
                      );
                      await Future.delayed(const Duration(seconds: 2));
                      Navigator.pop(context); 
                    
                    }
                  }
                },
                child: const Text(
                  "Create Procurement",
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  minimumSize: const Size(double.infinity, 0),
                  backgroundColor: Color.fromARGB(255, 144, 6, 156),
                ),
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
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide.none,
        ),
        fillColor: const Color.fromARGB(255, 52, 86, 208).withOpacity(0.1),
        filled: true,
        prefixIcon: Icon(prefixIcon),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 14, horizontal: 18),
      ),
      obscureText: obscureText,
    );
  }
}

