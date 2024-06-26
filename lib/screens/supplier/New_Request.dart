import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:project3/screens/supplier/Purchase_items.dart';

class New_Request extends StatefulWidget {
  final String username;

  const New_Request({Key? key, required this.username}) : super(key: key);

  @override
  State<New_Request> createState() => _New_RequestState();
}

class _New_RequestState extends State<New_Request> {
  List<Map<String, dynamic>> requests = [];

  @override
  void initState() {
    super.initState();
    fetchNewRequests();
  }

  Future<void> fetchNewRequests() async {
    try {
      final response = await http.get(Uri.parse('http://192.168.1.143:3000/New_Requests?username=${widget.username}'));
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

  Future<String> fetchProcurementDescription(String procId) async {
    try {
      final response = await http.get(Uri.parse('http://192.168.1.143:3000/ProcurementDescription?procId=$procId'));
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
    print('Number of requests: ${requests.length}');

    return Scaffold(
      body: Container(
        color: Color.fromARGB(255, 255, 255, 255), // Background color of the body
        child: ListView.builder(
          itemCount: requests.length,
          itemBuilder: (context, index) {
            final request = requests[index];
            return Padding(
              padding: EdgeInsets.symmetric(vertical: 3.0),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PurchaseItems(procId: request['procId']),
                    ),
                  );
                },
                child: ListTile(
                  tileColor: Colors.grey[200], // Background color of the ListTile
                  title: FutureBuilder<String>(
                    future: fetchProcurementDescription(request['procId']),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Text('Error loading description');
                      } else {
                        final description = snapshot.data ?? 'No description available';
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              description,
                              style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold), // Reduce text size
                            ),
                             Text(
                              'REQUEST ID: ${request['purchaseReqId']}',
                              style: TextStyle(fontSize: 12,), // Reduce text size
                            ),
                            Text(
                              'Date of Request: ${DateFormat.yMMMMd().add_jm().format(request['dateOfRequest'])}', // Format the date and time
                              style: TextStyle(fontSize: 12, ),
                              // Reduce text size
                            ),

                            Divider(thickness: 2,)
                          ],
                        );
                      }
                    },
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

