import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:project3/screens/Admin/ViewItems.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

class EditItemPage extends StatefulWidget {
  final Item item;

  const EditItemPage({Key? key, required this.item}) : super(key: key);

  @override
  _EditItemPageState createState() => _EditItemPageState();
}

class _EditItemPageState extends State<EditItemPage> {
  String? status;

  late TextEditingController _nameController;
  late TextEditingController _colorController;
  late TextEditingController _dimensionController;
  late String _status;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.item.name);
    _colorController = TextEditingController(text: widget.item.color);
    _dimensionController = TextEditingController(text: widget.item.dimension);
    _status = widget.item.status;
  }

Future<void> EditItem() async {
  final response = await http.post(
    Uri.parse('http://192.168.1.143:3000/EditItem'),
    body: {
    
      'name': _nameController.text,
      'color': _colorController.text,
      'dimensions': _dimensionController.text,
      'status': _status,
      'itemId': widget.item.itemId.toString(), // Pass item ID
    },
  );

  if (response.statusCode == 200) {
    final Map<String, dynamic> responseData = json.decode(response.body);
    status = responseData['message'];
  } else {
    status = 'Internal Server Error';
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Item'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Item ID: ${widget.item.itemId}',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 25),
              CustomTextField(
                hintText: 'Product Name',
                prefixIcon: Icons.inventory,
                controller: _nameController,
              ),
              SizedBox(height: 25),
              CustomTextField(
                hintText: 'Color / Finish',
                prefixIcon: Icons.color_lens,
                controller: _colorController,
              ),
              SizedBox(height: 25),
              CustomTextField(
                hintText: 'Dimensions',
                prefixIcon: Icons.aspect_ratio,
                controller: _dimensionController,
                maxLines: 3,
              ),
              SizedBox(height: 25),
              DropdownButtonFormField<String>(
                value: _status,
                onChanged: (newValue) {
                  setState(() {
                    _status = newValue!;
                  });
                },
                items: ['Active', 'Inactive']
                    .map<DropdownMenuItem<String>>(
                      (value) => DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      ),
                    )
                    .toList(),
                decoration: InputDecoration(
                  labelText: 'Status',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                  filled: true,
                  fillColor: Color.fromARGB(255, 52, 86, 208).withOpacity(0.1),
                  contentPadding: EdgeInsets.symmetric(
                    vertical: 14,
                    horizontal: 18,
                  ),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (_nameController.text.isEmpty ||
                      _colorController.text.isEmpty ||
                      _dimensionController.text.isEmpty) {
                    QuickAlert.show(
                      context: context,
                      type: QuickAlertType.warning,
                      text: 'All fields are required',
                    );
                  } else {
                    await EditItem();
                    if (status == 'Item Updated') {
                      QuickAlert.show(
                        context: context,
                        type: QuickAlertType.success,
                        title: 'Success',
                        text: 'Item Updated',
                      );

                      await Future.delayed(Duration(seconds: 2));
                       Navigator.pop(context);
                      
                   
                    }
                  }
                },
                child: Text(
                  'Update',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  padding: EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                  minimumSize: Size(double.infinity, 0),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _colorController.dispose();
    _dimensionController.dispose();
    super.dispose();
  }
}

class CustomTextField extends StatelessWidget {
  final String hintText;
  final IconData prefixIcon;
  final TextEditingController controller;
  final int maxLines;

  const CustomTextField({
    Key? key,
    required this.hintText,
    required this.prefixIcon,
    required this.controller,
    this.maxLines = 1,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        hintText: hintText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide.none,
        ),
        prefixIcon: Icon(prefixIcon),
        filled: true,
        fillColor: Color.fromARGB(255, 52, 86, 208).withOpacity(0.1),
        contentPadding: EdgeInsets.symmetric(vertical: 14, horizontal: 18),
      ),
    );
  }
}
