import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:project3/screens/manager/DetailedSupplierInfo.dart';

class BlacklistedSuppliers extends StatefulWidget {
  const BlacklistedSuppliers({Key? key}) : super(key: key);

  @override
  State<BlacklistedSuppliers> createState() => _BlacklistedSuppliersState();
}

class _BlacklistedSuppliersState extends State<BlacklistedSuppliers> {
  late Future<List<List<String>>> _BlacklistedSuppliers;

  @override
  void initState() {
    super.initState();
    _BlacklistedSuppliers = fetchBlacklistedSuppliers();
  }

  Future<List<List<String>>> fetchBlacklistedSuppliers() async {
    final response =
        await http.get(Uri.parse('http://192.168.1.142:3000/blacklisted_suppliers'));

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return List<List<String>>.from(data.map((e) => List<String>.from(e)));
    } else {
      throw Exception('Failed to load active suppliers');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<List<String>>>(
        future: _BlacklistedSuppliers,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final BlacklistedSuppliers = snapshot.data!;
            return Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 4,
                    offset: Offset(0, 2), // changes position of shadow
                  ),
                ],
              ),
              child: ListView.builder(
                itemCount: BlacklistedSuppliers.length + 1, // Add 1 for the extra space
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return SizedBox(height: 16.0); // Add space at the top
                  } else {
                    final supplier = BlacklistedSuppliers[index - 1];
                    return Container(
                      margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 20.0),
                      padding: EdgeInsets.all(5.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: ListTile(
                        title: Text(supplier[1], style: TextStyle(fontWeight: FontWeight.w600)), // Company Name
                        subtitle: Text("${supplier[2]} ${supplier[3]}"), // First Name + Last Name
                        trailing: Text(supplier[0]), // Supplier ID
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DetailedSupplierInfo(supplierId: supplier[0]),
                            ),
                          );
                        },
                      ),
                    );
                  }
                },
              ),
            );
          }
        },
      ),
    );
  }
}
