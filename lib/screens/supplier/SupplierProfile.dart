import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:project3/screens/supplier/EditSupplierInfo.dart';

class SupplierProfile extends StatefulWidget {
  final String username;

  const SupplierProfile({Key? key, required this.username}) : super(key: key);

  @override
  _SupplierProfileState createState() => _SupplierProfileState();
}

class _SupplierProfileState extends State<SupplierProfile> {
  late Future<List<dynamic>> _supplierDetails;

  @override
  void initState() {
    super.initState();
    _supplierDetails = fetchSupplierDetails(widget.username);
  }

  Future<List<dynamic>> fetchSupplierDetails(String username) async {
    final response = await http.get(
      Uri.parse('http://192.168.0.102:3000/SupplierDetails?username=$username'),
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load supplier details');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<dynamic>>(
        future: _supplierDetails,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final supplierDetails = snapshot.data!;
            print('Supplier Details: $supplierDetails');
            return Stack(
              children: [
                SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Container(
                      padding: const EdgeInsets.all(20.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.0),
                        border: Border.all(color: Colors.grey),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(child: Icon(Icons.person, size: 50)),
                          SizedBox(height: 20),
                          _buildStatusBox('${supplierDetails[11]}'),
                          SizedBox(height: 20),
                          _buildDetailRow('Name', '${supplierDetails[1]} ${supplierDetails[2]}'),
                          SizedBox(height: 20),
                          _buildDetailRow('Company Name', '${supplierDetails[3]}'),
                          SizedBox(height: 20),
                          _buildDetailRow('Email', '${supplierDetails[4]}'),
                          SizedBox(height: 20),
                          _buildDetailRow('Phone', '${supplierDetails[5]}'),
                          SizedBox(height: 20),
                          _buildDetailRow('Alternate Number', '${supplierDetails[6]}'),
                          SizedBox(height: 20),
                          _buildDetailRow('Address', '${supplierDetails[7]}, ${supplierDetails[8]}, ${supplierDetails[9]}'),
                          SizedBox(height: 20),
                          _buildDetailRow('GST Number', '${supplierDetails[10]}'),
                          SizedBox(height: 50),
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 20.0,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditSupplierInfo(supplierDetails: supplierDetails),
                          ),
                        );
                      },
                      child: Text(
                        'Edit',
                        style: TextStyle(color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.indigo,
                      ),
                    ),
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }

  Widget _buildDetailRow(String title, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 100, // Adjust the width as needed
          child: Text(
            title,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(width: 20),
        Expanded(
          child: Text(value),
        ),
      ],
    );
  }

  Widget _buildStatusBox(String status) {
    Color statusColor = status.toLowerCase() == 'active' ? Colors.green : Colors.grey;
    return Container(
      padding: EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: statusColor,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Text(
        status,
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
    );
  }
}
