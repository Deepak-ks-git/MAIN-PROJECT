import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:project3/screens/supplier/DeliveryPage.dart';
import 'package:project3/screens/supplier/Edit_Quot_details.dart';
import 'package:project3/screens/supplier/List_of_Accepted.dart';
import 'package:project3/screens/supplier/OrderHistory.dart';
import 'package:project3/screens/supplier/OrdersPage.dart';
import 'package:project3/screens/supplier/Request_Tab.dart';
import 'package:project3/screens/supplier/SupplierAppDrawer.dart';
import 'package:project3/screens/supplier/SupplierNavHome.dart';
import 'package:project3/screens/supplier/SupplierSettingsPage.dart.dart';
import 'package:project3/screens/supplier/viewAllQuotation.dart';

class EditQuotation extends StatefulWidget {
  final String username;

  const EditQuotation({Key? key, required this.username}) : super(key: key);

  @override
  State<EditQuotation> createState() => _Accepted_RequestState();
}

class _Accepted_RequestState extends State<EditQuotation> {
  List<Map<String, dynamic>> requests = [];

  @override
  void initState() {
    super.initState();
    fetchNewRequests();
  }

  Future<void> fetchNewRequests() async {
    try {
      final response = await http.get(Uri.parse(
          'http://192.168.1.143:3000/List_of_Quotation?username=${widget.username}'));
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          requests = data
              .map<Map<String, dynamic>>((item) => {
                    'purchaseReqId': item[0] as String,
                    'procId': item[1] as String,
                    'supplierId': item[2] as String,
                    'status': item[3] as String,
                    'amount': item[4] as String?,
                    'dateOfRequest': DateTime.parse(
                        item[5] as String), // Parse the date string to DateTime
                  })
              .toList();
        });
      } else {
        throw Exception('Failed to load new requests');
      }
    } catch (error) {
      print('Error fetching new requests: $error');
    }
  }

  Future<String> fetchProcurementDescription(String procId) async {
    try {
      final response = await http.get(Uri.parse(
          'http://192.168.1.143:3000/ProcurementDescription?procId=$procId'));
      if (response.statusCode == 200) {
        final description = json.decode(response.body)['description'];
        return description;
      } else {
        throw Exception('Failed to load procurement description');
      }
    } catch (error) {
      print('Error fetching procurement description: $error');
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    Color myColor = Color(0xFF1E2736);

    print('Number of requests: ${requests.length}');

    return Scaffold(
      appBar: AppBar(
        title: Text('Quotations',
            style: TextStyle(color: Colors.white, fontSize: 18)),
        backgroundColor: myColor,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Container(
        color:
            Color.fromARGB(255, 211, 211, 240), // Background color of the body
        child: ListView.builder(
          padding: EdgeInsets.all(8.0), // Padding for the list
          itemCount: requests.length,
          itemBuilder: (context, index) {
            final request = requests[index];
            return Padding(
              padding: EdgeInsets.symmetric(vertical: 3.0),
              child: Card(
                elevation: 2, // Add elevation for a raised effect
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Edit_Quot_details(
                          procId: request['procId'],
                          purchaseReqId: request[
                              'purchaseReqId'], // Pass the purchaseReqId to Edit_Quot_details
                        ),
                      ),
                    );
                  },
                  child: ListTile(
                    tileColor:
                        Colors.grey[200], // Background color of the ListTile
                    title: FutureBuilder(
                      future: fetchProcurementDescription(request['procId']),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Text('Error loading description');
                        } else {
                          final description = snapshot.data.toString();
                          return Text(
                            description,
                            style: TextStyle(fontSize: 14), // Reduce text size
                          );
                        }
                      },
                    ),
                    subtitle: Text(
                      'Date of Request: ${DateFormat.yMMMMd().add_jm().format(request['dateOfRequest'])}', // Format the date and time
                      style:
                          TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                      // Reduce text size
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
      drawer: SupplierAppDrawer(
        drawerColor: myColor,
        onHomeTap: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    SupplierNavHome(username: widget.username)),
          );
        },
        onmakeQuotTap: () {
          Navigator.pop(context); // Close drawer
        },
        onSettingsTap: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    SupplierSettingsPage(username: widget.username)),
          );
        },
        onRequestTap: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => Request_Tab(username: widget.username)),
          );
        },
        onQuotationsTap: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    viewAllQuotation(username: widget.username)),
          );
        },
        onStartQuotTap: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    List_of_Accepted(username: widget.username)),
          );
        },
        onOrdersTap: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => OrdersPage(username: widget.username)),
          );
        },
        onUpdateOrderTap:
        () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    DeliveryPage(username: widget.username)),
          );
        },
         onorderHistoryTap :
        () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    OrderHistory(username: widget.username)),
          );
        },
      ),
    );
  }
}
