import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:project3/screens/manager/PLACE_ORDER.dart';


class PlaceOrders extends StatefulWidget {
  const PlaceOrders({Key? key}) : super(key: key);

  @override
  State<PlaceOrders> createState() => _PlaceOrdersState();
}

class _PlaceOrdersState extends State<PlaceOrders> {
  List<dynamic> PlaceOrders = []; // List to store fetched PlaceOrders

  @override
  void initState() {
    super.initState();
    fetchPlaceOrders(); // Fetch PlaceOrders when the widget initializes
  }

  Future<void> fetchPlaceOrders() async {
    try {
      final response =
          await http.get(Uri.parse('http://192.168.1.142:3000/approved_quotation'));

      if (response.statusCode == 200) {
        // If the API call is successful, parse the JSON response
        setState(() {
          PlaceOrders = jsonDecode(response.body);
        });
      } else {
        // Handle error response
        print('Failed to load PlaceOrders: ${response.statusCode}');
      }
    } catch (e) {
      // Handle network or parsing errors
      print('Error fetching PlaceOrders: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PlaceOrders'),
      ),
      body: Center(
        child: PlaceOrders.isEmpty
            ? CircularProgressIndicator() // Show loading indicator if PlaceOrders are being fetched
            : ListView.builder(
                itemCount: PlaceOrders.length,
                itemBuilder: (context, index) {
                  final quotation = PlaceOrders[index];
                  // Build styled container for each quotation
                  return GestureDetector(
                    onTap: () {
                      // Navigate to Quot_details page with parameters
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PLACE_ORDER(
                            procId: quotation[0], // Extract procId from quotation
                            purchaseReqId: quotation[3], // Extract purchaseReqId from quotation
                          ),
                        ),
                      );
                    },
                    child: Container(
                      margin: EdgeInsets.all(8.0),
                      padding: EdgeInsets.all(12.0),
                      decoration: BoxDecoration(
                        color: Colors.blue[100], // Subtle blue color for the container
                        borderRadius: BorderRadius.circular(12.0), // Rounded corners
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.3),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: Offset(0, 2), // Shadow offset
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          Text('${quotation[1]}',style: TextStyle(fontWeight: FontWeight.bold),),
                          /*Text(
                            'PROC_ID: ${quotation[0]}',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 8.0),
                          Text('DESCRIPTION: ${quotation[1]}'),
                          SizedBox(height: 8.0),
                          Text('QUOT_ID: ${quotation[2]}'),
                          SizedBox(height: 8.0),
                          Text('PURCHASE_REQ_ID: ${quotation[3]}'),*/
                        ],
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
