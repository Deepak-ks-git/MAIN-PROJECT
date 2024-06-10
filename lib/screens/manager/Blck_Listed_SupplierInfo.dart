import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Blck_Listed_SupplierInfo extends StatefulWidget {
  final String supplierId;

  const Blck_Listed_SupplierInfo({Key? key, required this.supplierId}) : super(key: key);

  @override
  _Blck_Listed_SupplierInfoState createState() => _Blck_Listed_SupplierInfoState();
}

class _Blck_Listed_SupplierInfoState extends State<Blck_Listed_SupplierInfo> {
  late Future<List<String?>> _supplierDetails;

  @override
  void initState() {
    super.initState();
    _supplierDetails = fetchSupplierDetails(widget.supplierId);
  }

  Future<List<String?>> fetchSupplierDetails(String supplierId) async {
    final response = await http.get(Uri.parse('http://192.168.1.143:3000/SupplierDetails?username=$supplierId'));

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return List<String?>.from(data.map((e) => e.toString()));
    } else {
      throw Exception('Failed to load supplier details');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Supplier Details'),
      ),
      body: Container(
        color: Colors.grey.withOpacity(0.5), // Set background color here
        child: FutureBuilder<List<String?>>(
          future: _supplierDetails,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else {
              final supplierDetails = snapshot.data!;
              final screenHeight = MediaQuery.of(context).size.height;
              final detailsHeight = screenHeight * 3 / 4;

              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: SizedBox(
                    height: detailsHeight,
                    child: Container(
                      padding: EdgeInsets.all(20.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 4,
                            offset: Offset(0, 2), // changes position of shadow
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildInfoRow('Supplier ID', supplierDetails[0]),
                          _buildInfoRow('First Name', supplierDetails[1]),
                          _buildInfoRow('Last Name', supplierDetails[2]),
                          _buildInfoRow('Company Name', supplierDetails[3]),
                          _buildInfoRow('Email', supplierDetails[4]),
                          _buildInfoRow('Phone', supplierDetails[5]),
                          _buildInfoRow('Alternate Number', supplierDetails[6]),
                          _buildInfoRow('Address 1', supplierDetails[7]),
                          _buildInfoRow('Address 2', supplierDetails[8]),
                          _buildInfoRow('Address 3', supplierDetails[9]),
                          _buildInfoRow('GST Number', supplierDetails[10]),
                          _buildInfoRow('Blacklisted By', supplierDetails[12],),
                          _buildInfoRow('Reason', supplierDetails[13]),


                          // Add more rows as needed
                        ], 
                      ),
                    ),
                  ),
                ),
              );
            }
          },
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label + ': ',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: Text(
              value ?? '',
              style: label == 'Status' ? _getStatusTextStyle(value) : null,
            ),
          ),
        ],
      ),
    );
  }

  TextStyle _getStatusTextStyle(String? status) {
    // Add your condition to determine the color based on the status value
    Color textColor = Colors.black; // Default color
    if (status == 'Active') {
      textColor = Colors.green; // Change color for Active status
    } else if (status == 'Inactive') {
      textColor = Colors.red; // Change color for Inactive status
    }

    return TextStyle(color: textColor, fontWeight: FontWeight.bold);
  }
}


