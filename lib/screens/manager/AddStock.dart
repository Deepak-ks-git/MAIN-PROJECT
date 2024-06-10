import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:project3/screens/manager/AppDrawerMan.dart';
import 'package:project3/screens/manager/Dash_MANAGER.dart';
import 'package:project3/screens/manager/Man_Supplier.dart';
import 'package:project3/screens/manager/Man_TAB_Procurements.dart';
import 'package:project3/screens/manager/New_Orders.dart';
import 'package:project3/screens/manager/PlaceOrders.dart';
import 'package:project3/screens/manager/Quotations.dart';
import 'package:project3/screens/manager/ReportPage.dart';
import 'package:project3/screens/manager/SettingsPage.dart';
import 'package:project3/screens/manager/Stock.dart';
import 'package:project3/screens/manager/Stock_details.dart';
import 'package:project3/screens/manager/VerifyOrders.dart';
import 'package:project3/screens/manager/View_Stock.dart';

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
      final response = await http.get(Uri.parse('http://192.168.1.143:3000/COMPLETED_ORDERS'));

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
        Uri.parse('http://192.168.1.143:3000/AddStock'),
        body: jsonEncode({'quotId': quotId}),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        // Stock and order status updated successfully
        print('Stock and order status updated successfully');
        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Stock added successfully'),
            duration: Duration(seconds: 2),
          ),
        );
        // Delay and navigate to another page
        await Future.delayed(Duration(seconds: 1));
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => View_Stock()),
        );
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
    Color myColor = Color(0xFF1E2736);
    return Scaffold(
      appBar: AppBar(
        title: Text('Stock', style: TextStyle(color: Colors.white)),
        backgroundColor: myColor,
        iconTheme: IconThemeData(color: Colors.white), // Set the icon theme to white
      ),
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
                        color: Color.fromARGB(255, 218, 226, 230),
                        borderRadius: BorderRadius.circular(12.0),
                        border: Border.all(color: Colors.grey),
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
      drawer: AppDrawerMan(
        drawerColor: myColor,
        onHomeTap: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => Dash_MANAGER()),
          );
        },
        onSettingsTap: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => SettingsPage()),
          );
        },
        onReportTap: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => ReportPage()),
          );
        },
        onAddStocktTap: () {
          Navigator.pop(context); // Close drawer if already on Report page
        },
        onStockTap: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => Stock()),
          );
        },
        onSupplierstTap: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => Man_Supplier()),
          );
        },
        onOrdersTap: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => New_Orders()),
          );
        },
        onPlaceOrdersTap: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => PlaceOrders()),
          );
        },
        onVerifyOrdersTap: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => VerifyOrders()),
          );
        },
        onQuotationsTap: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => Quotations()),
          );
        },
        onProcurementTap: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => Man_TAB_Procurements()),
          );
        },
      ),
    );
  }
}
