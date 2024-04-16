import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:project3/screens/supplier/details_List_Accepted.dart';

class List_of_Accepted extends StatefulWidget {
  final String username;

  const List_of_Accepted({Key? key, required this.username}) : super(key: key);

  @override
  State<List_of_Accepted> createState() => _Accepted_RequestState();
}

class _Accepted_RequestState extends State<List_of_Accepted> {
  List<Map<String, dynamic>> requests = [];

  @override
  void initState() {
    super.initState();
    fetchNewRequests();
  }

  Future<void> fetchNewRequests() async {
    try {
      final response = await http.get(Uri.parse('http://192.168.0.102:3000/List_of_Accepted?username=${widget.username}'));
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
      final response = await http.get(Uri.parse('http://192.168.0.102:3000/ProcurementDescription?procId=$procId'));
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
                        builder: (context) => DetailsListAccepted(procId: request['procId']),
                      ),
                    );
                  },
                  child: ListTile(
                    tileColor: Colors.grey[200], // Background color of the ListTile
                    title: FutureBuilder(
                      future: fetchProcurementDescription(request['procId']),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
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
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                      // Reduce text size
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
