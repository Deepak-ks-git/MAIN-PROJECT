import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:project3/screens/supplier/Unsended_details.dart';

class Unsended_quot extends StatefulWidget {
  final String username;

  const Unsended_quot({Key? key, required this.username}) : super(key: key);

  @override
  State<Unsended_quot> createState() => _Accepted_RequestState();
}

class _Accepted_RequestState extends State<Unsended_quot> {
  List<Map<String, dynamic>> requests = [];

  @override
  void initState() {
    super.initState();
    fetchNewRequests();
  }

  Future<void> fetchNewRequests() async {
    try {
      final response = await http.get(Uri.parse('http://192.168.0.102:3000/NOTSENDED_of_Quotation?username=${widget.username}'));
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          requests = data.map<Map<String, dynamic>>((item) => {
            'purchaseReqId': item[0] as String,
            'procId': item[1] as String,
            'supplierId': item[2] as String,
            'status': item[3] as String,
            'amount': item[4] as String?,
            'dateOfRequest': DateTime.parse(item[5] as String), // Parse the date string to DateTime
          }).toList();
        });
      } else {
        throw Exception('Failed to load new requests');
      }
    } catch (error) {
      print('Error fetching new requests: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    print('Number of requests: ${requests.length}');

    return Scaffold(
      body: Container(
        color: Color.fromARGB(255, 211, 211, 240), // Background color of the body
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
                        builder: (context) => UnsendedDetails(
                          procId: request['procId'],
                          purchaseReqId: request['purchaseReqId'], // Pass the purchaseReqId to Unsended_details
                        ),
                      ),
                    );
                  },
                  child: ListTile(
                    tileColor: Colors.grey[200], // Background color of the ListTile
                    title: Text(
                      'Purchase Request ID: ${request['purchaseReqId']}', // Display the purchase request ID
                      style: TextStyle(fontSize: 14), // Reduce text size
                    ),
                    subtitle: Text(
                      'Date of Request: ${DateFormat.yMMMMd().add_jm().format(request['dateOfRequest'])}', // Format the date and time
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold), // Reduce text size
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
