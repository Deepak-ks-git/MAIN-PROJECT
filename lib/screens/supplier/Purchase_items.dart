import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class PurchaseItems extends StatefulWidget {
  final String procId;

  const PurchaseItems({Key? key, required this.procId}) : super(key: key);

  @override
  _PurchaseItemsState createState() => _PurchaseItemsState();
}

class _PurchaseItemsState extends State<PurchaseItems> {
  List<dynamic> items = [];

  @override
  void initState() {
    super.initState();
    fetchPurchaseItems();
  }

  Future<void> fetchPurchaseItems() async {
    try {
      final response = await http.get(Uri.parse(
          'http://192.168.0.102:3000/Item_Reqeust_details?procId=${widget.procId}'));
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          items = data;
        });
      } else {
        throw Exception('Failed to load purchase items');
      }
    } catch (error) {
      print('Error fetching purchase items: $error');
    }
  }

  Future<void> acceptRequest() async {
    try {
      final response = await http.post(
        Uri.parse('http://192.168.0.102:3000/ACCEPT_REQUEST'),
        body: json.encode({'procId': widget.procId}),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        // Purchase request accepted
        print('Purchase request accepted');
        // You can update UI accordingly if needed
      } else {
        throw Exception('Failed to accept purchase request');
      }
    } catch (error) {
      print('Error accepting purchase request: $error');
    }
  }

  Future<void> rejectRequest() async {
    try {
      final response = await http.post(
        Uri.parse('http://192.168.0.102:3000/REJECT_REQUEST'),
        body: json.encode({'procId': widget.procId}),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        // Purchase request rejected
        print('Purchase request rejected');
        // You can update UI accordingly if needed
      } else {
        throw Exception('Failed to reject purchase request');
      }
    } catch (error) {
      print('Error rejecting purchase request: $error');
    }
  }

  Future<void> showConfirmationDialog(String action) async {
    bool? result = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmation'),
          content: Text('Are you sure you want to $action this request?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true); // User confirmed
              },
              child: Text('Yes'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false); // User cancelled
              },
              child: Text('No'),
            ),
          ],
        );
      },
    );

    if (result != null && result) {
      if (action == 'accept') {
        acceptRequest();
      } else if (action == 'reject') {
        rejectRequest();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'ITEMS',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          Divider(thickness: 1),
          SizedBox(
            height: 150, // Adjust height as needed
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: _buildGridRows(),
              ),
            ),
          ),
          SizedBox(height: 20),
          Container(
            alignment: Alignment.center,
            child: ElevatedButton(
              onPressed: () {
                // Add functionality for downloading PDF
              },
              child: Text('Download PDF', style: TextStyle(fontSize: 14)),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
          SizedBox(height: 70),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                children: [
                  IconButton(
                    onPressed: () {
                      showConfirmationDialog('accept');
                    },
                    icon: Image.asset('assets/accept.gif'),
                    tooltip: 'Accept',
                  ),
                  Text('Accept Order'),
                ],
              ),
              Column(
                children: [
                  IconButton(
                    onPressed: () {
                      showConfirmationDialog('reject');
                    },
                    icon: Image.asset('assets/reject.png',height: 65,width: 65,),
                    tooltip: 'Reject',
                  ),
                  Text('Reject Order'),
                ],
              ),
            ],
          ),
          
        ],
      ),
    );
  }

  List<Widget> _buildGridRows() {
    List<Widget> rows = [];
    for (var item in items) {
      rows.add(_buildGridRow(item));
    }
    return rows;
  }

  Widget _buildGridRow(item) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 5),
      child: Card(
        shape: RoundedRectangleBorder(
          side: BorderSide(color: Colors.grey), // Visible border
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('${item[1]}',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
              Text('Color: ${item[2]}'),
              Text('Dimensions: ${item[3]}'),
              const SizedBox(height: 10,),
              ClipRRect(
                borderRadius:
                    BorderRadius.circular(10), // Adjust the radius as needed
                child: Container(
                  padding: EdgeInsets.all(5),
                  color: const Color.fromARGB(
                      255, 4, 5, 6), // Change color as needed
                  child: Text(
                    'Quantity: ${item[4]}',
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.white),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
