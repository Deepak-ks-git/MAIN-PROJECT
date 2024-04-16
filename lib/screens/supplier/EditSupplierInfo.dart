import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:project3/SupplierHome.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

class EditSupplierInfo extends StatefulWidget {
  final List<dynamic> supplierDetails;

  const EditSupplierInfo({Key? key, required this.supplierDetails})
      : super(key: key);

  @override
  _EditSupplierInfoState createState() => _EditSupplierInfoState();
}

class _EditSupplierInfoState extends State<EditSupplierInfo> {
  String? status;

  late String _status;
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _companyNameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _alternateNumberController;
  late TextEditingController _address1Controller;
  late TextEditingController _address2Controller;
  late TextEditingController _address3Controller;
  late TextEditingController _gstNumberController;

  @override
  void initState() {
    super.initState();
    _status = widget.supplierDetails[11];
    _firstNameController =
        TextEditingController(text: widget.supplierDetails[1]);
    _lastNameController =
        TextEditingController(text: widget.supplierDetails[2]);
    _companyNameController =
        TextEditingController(text: widget.supplierDetails[3]);
    _emailController = TextEditingController(text: widget.supplierDetails[4]);
    _phoneController =
        TextEditingController(text: widget.supplierDetails[5].toString());
    _alternateNumberController =
        TextEditingController(text: widget.supplierDetails[6].toString());
    _address1Controller =
        TextEditingController(text: widget.supplierDetails[7]);
    _address2Controller =
        TextEditingController(text: widget.supplierDetails[8]);
    _address3Controller =
        TextEditingController(text: widget.supplierDetails[9]);
    _gstNumberController =
        TextEditingController(text: widget.supplierDetails[10]);
  }

  Future<void> editSupplierDetails() async {
    final response = await http.post(
      Uri.parse('http://192.168.0.102:3000/EditSupplierDetails'),
      body: {
        'username': widget
            .supplierDetails[0], // Assuming supplier_id is passed as username
        'firstName': _firstNameController.text,
        'lastName': _lastNameController.text,
        'companyName': _companyNameController.text,
        'email': _emailController.text,
        'phone': _phoneController.text,
        'alternateNumber': _alternateNumberController.text,
        'address1': _address1Controller.text,
        'address2': _address2Controller.text,
        'address3': _address3Controller.text,
        'gstNumber': _gstNumberController.text,
        'status': _status,
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      status = responseData['message'];

      // Handle success message
    } else {
      // Handle error message
      status = 'Internal Server Error';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Supplier Info'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildNameRow(),
                SizedBox(height: 20),
                _buildTextField('Company Name', _companyNameController),
                _buildTextField('Email', _emailController),
                _buildTextField('Phone', _phoneController),
                _buildTextField('Alternate Number', _alternateNumberController),
                _buildTextField('Address 1', _address1Controller),
                _buildTextField('Address 2', _address2Controller),
                _buildTextField('Address 3', _address3Controller),
                _buildTextField('GST Number', _gstNumberController),
                SizedBox(height: 20),
                _buildStatusDropdown(),
                SizedBox(height: 20),
                Center(
                  child: ElevatedButton(
                    onPressed: () async {
                      if (_firstNameController.text.isEmpty ||
                          _lastNameController.text.isEmpty ||
                          _companyNameController.text.isEmpty ||
                          _emailController.text.isEmpty ||
                          _phoneController.text.isEmpty ||
                          _alternateNumberController.text.isEmpty ||
                          _address1Controller.text.isEmpty ||
                          _address2Controller.text.isEmpty ||
                          _address3Controller.text.isEmpty ||
                          _gstNumberController.text.isEmpty) {
                        QuickAlert.show(
                          context: context,
                          type: QuickAlertType.warning,
                          text: 'All fields are required',
                        );
                      } else {
                        await editSupplierDetails();
                        if (status == 'Updated') {
                          QuickAlert.show(
                            context: context,
                            type: QuickAlertType.success,
                            title: 'Success',
                            text: 'Details Updated',
                          );
                          await Future.delayed(
                              Duration(seconds: 3)); // Add a delay of 1 second
                          Navigator.pop(context);

                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SupplierHome(
                                  username: widget.supplierDetails[0]),
                            ),
                          );
                        }
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.blue,
                    ),
                    child: Text('Save'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNameRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Expanded(
            child: _buildTextField('First Name', _firstNameController),
          ),
          SizedBox(width: 20),
          Expanded(
            child: _buildTextField('Last Name', _lastNameController),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 2,
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: TextFormField(
          controller: controller,
          style: TextStyle(fontSize: 14.0),
          decoration: InputDecoration(
            labelText: label,
            border: InputBorder.none,
            contentPadding: EdgeInsets.zero,
          ),
        ),
      ),
    );
  }

  Widget _buildStatusDropdown() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: DropdownButtonFormField<String>(
        value: _status,
        onChanged: (value) {
          setState(() {
            _status = value!;
          });
        },
        items: ['Active', 'Inactive']
            .map((status) => DropdownMenuItem<String>(
                  value: status,
                  child: Text(status),
                ))
            .toList(),
        decoration: InputDecoration(
          labelText: 'Status',
          border: InputBorder.none,
          contentPadding: EdgeInsets.zero,
        ),
      ),
    );
  }
}
