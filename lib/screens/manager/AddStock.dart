import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:project3/screens/manager/Stock_details.dart';

class AddStock extends StatefulWidget {
  const AddStock({Key? key}) : super(key: key);

  @override
  State<AddStock> createState() => _AddStockState();
}

class _AddStockState extends State<AddStock> {
  List<dynamic> orders = [];

  @override
  void initState() {
    super.initState();
    fetchOrders();
  }

  Future<void> fetchOrders() async {
    try {
      final response = await http.get(Uri.parse('http://192.168.1.142:3000/COMPLETED_ORDERS'));

      if (response.statusCode == 200) {
        setState(() {
          orders = jsonDecode(response.body);
        });
      } else {
        // Handle error response
        print('Failed to load orders: ${response.statusCode}');
      }
    } catch (e) {
      // Handle network or parsing errors
      print('Error fetching orders: $e');
    }
  }

  Future<void> addStock(String quotId) async {
    try {
      final response = await http.post(
        Uri.parse('http://192.168.1.142:3000/AddStock'),
        body: jsonEncode({'quotId': quotId}),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        // Stock and order status updated successfully
        print('Stock and order status updated successfully');
        // Perform any additional actions after successful update
      } else {
        // Handle error response
        print('Failed to update stock and order status: ${response.statusCode}');
      }
    } catch (e) {
      // Handle network or parsing errors
      print('Error updating stock and order status: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
   
      body: Center(
        child: orders.isEmpty
            ? CircularProgressIndicator()
            : ListView.builder(
                itemCount: orders.length,
                itemBuilder: (context, index) {
                  final order = orders[index];

                  return GestureDetector(
                    onTap: () {
                      // Navigate to Stock_details page with parameters
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Stock_details(
                            procId: order[0],
                            purchaseReqId: order[3],
                          ),
                        ),
                      );
                    },
                    child: Container(
                      margin: EdgeInsets.all(8.0),
                      padding: EdgeInsets.all(12.0),
                      decoration: BoxDecoration(
                        color: Colors.blueGrey[100],
                        borderRadius: BorderRadius.circular(12.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.3),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${order[1]}',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                'Status: ${order[4]}',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              // Add more order details as needed
                            ],
                          ),
                          TextButton(
                            onPressed: () {
                              // Call addStock function when button is tapped
                              addStock(order[2]); // Pass quotId to addStock function
                            },
                            child: Text(
                              'Add Stock',
                              style: TextStyle(color: Colors.white),
                            ),
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(Colors.green),
                            ),
                          ),
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
