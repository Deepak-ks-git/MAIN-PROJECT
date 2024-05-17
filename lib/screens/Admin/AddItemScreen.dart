import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:project3/screens/Admin/ViewItems.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

class AddItemScreen extends StatefulWidget {
  const AddItemScreen({Key? key}) : super(key: key);

  @override
  State<AddItemScreen> createState() => _AddItemScreenState();
}

class _AddItemScreenState extends State<AddItemScreen> {
  String? status;

  final TextEditingController pname = TextEditingController();
  final TextEditingController color = TextEditingController();
  final TextEditingController dimension = TextEditingController();

  Future<void> addItem() async {
    final response = await http.post(
      Uri.parse('http://192.168.1.142:3000/add_item'),
      body: {
        'name': pname.text,
        'color': color.text,
        'dimensions': dimension.text,
        'status': 'Active'
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      status = responseData['message'];
    } else {
      status = 'Internal Server Error';
    }

    pname.clear();
    color.clear();
    dimension.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add new item')),
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
                  "Enter Item details below..",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              const SizedBox(height: 40),
              CustomTextField(
                hintText: "Product Name",
                prefixIcon: Icons.inventory,
                controller: pname,
              ),
              const SizedBox(height: 12),
              CustomTextField(
                hintText: "Color / Finish",
                prefixIcon: Icons.color_lens,
                controller: color,
              ),
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
                  controller: dimension,
                  decoration: InputDecoration(
                    hintText: "Dimensions",
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
                  if (dimension.text.isEmpty ||
                      color.text.isEmpty ||
                      pname.text.isEmpty) {
                    QuickAlert.show(
                      context: context,
                      type: QuickAlertType.warning,
                      text: 'All fields are required',
                    );
                  } else {
                    await addItem();
                    if (status == 'Item Added') {
                      QuickAlert.show(
                        context: context,
                        type: QuickAlertType.success,
                        title: 'Success',
                        text: 'Item Added',
                      );
                      await Future.delayed(const Duration(seconds: 2));
                      Navigator.pop(context); 
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ViewItems()),
                      );
                    }
                  }
                },
                child: const Text(
                  "Add Item",
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  minimumSize: const Size(double.infinity, 0),
                  backgroundColor: const Color.fromARGB(255, 4, 18, 67),
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
