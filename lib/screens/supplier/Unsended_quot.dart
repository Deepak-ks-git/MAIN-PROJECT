import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:project3/screens/supplier/Unsended_details.dart';

class Unsended_quot extends StatefulWidget {
  final String username;

  const Unsended_quot({Key? key, required this.username}) : super(key: key);

  @override
  State<Unsended_quot> createState() => _Unsended_quotState();
}

class _Unsended_quotState extends State<Unsended_quot> {
  List<Map<String, dynamic>> requests = [];

  @override
  void initState() {
    super.initState();
    fetchNewRequests();
  }

  Future<void> fetchNewRequests() async {
    try {
      final response = await http.get(Uri.parse('http://192.168.1.142:3000/NOTSENDED_of_Quotation?username=${widget.username}'));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          requests = data.map<Map<String, dynamic>>((item) => {
            'purchaseReqId': item[0] as String,
            'procId': item[1] as String,
            'supplierId': item[2] as String,
            'status': item[3] as String,
            'amount': item[4] as String?,
            'dateOfRequest': DateTime.parse(item[5] as String),
          }).toList();
        });
      } else {
        throw Exception('Failed to load new requests');
      }
    } catch (error) {
      print('Error fetching new requests: $error');
    }
  }

  Future<void> sendQuotation(String purchaseReqId) async {
    // Show dialog box for confirmation
    bool confirmed = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Send Quotation'),
        content: Text('Are you sure you want to send this quotation?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text('OK'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        final response = await http.post(
          Uri.parse('http://192.168.1.142:3000/send_quotation'),
          body: {'purchaseReqId': purchaseReqId},
        );

        if (response.statusCode == 200) {
          final Map<String, dynamic> responseData = json.decode(response.body);
          print(responseData['message']);
          // Perform any UI update or navigation after successful sending
        } else {
          throw Exception('Failed to send quotation. Status Code: ${response.statusCode}');
        }
      } catch (error) {
        print('Error sending quotation: $error');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Color.fromARGB(255, 211, 211, 240),
        child: ListView.builder(
          padding: EdgeInsets.all(8.0),
          itemCount: requests.length,
          itemBuilder: (context, index) {
            final request = requests[index];
            return Padding(
              padding: EdgeInsets.symmetric(vertical: 3.0),
              child: Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
                child: ListTile(
                  tileColor: Colors.grey[200],
                  title: Text(
                    'Purchase Request ID: ${request['purchaseReqId']}',
                    style: TextStyle(fontSize: 14),
                  ),
                  subtitle: Text(
                    'Date of Request: ${DateFormat.yMMMMd().add_jm().format(request['dateOfRequest'])}',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.send, color: Colors.blue), // Icon for sending
                    onPressed: () {
                      sendQuotation(request['purchaseReqId']); // Pass purchaseReqId to sendQuotation
                    },
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => UnsendedDetails(
                          procId: request['procId'],
                          purchaseReqId: request['purchaseReqId'],
                        ),
                      ),
                    );
                  },
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
