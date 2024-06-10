import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:project3/screens/manager/AddStock.dart';
import 'package:project3/screens/manager/AppDrawerMan.dart';
import 'package:project3/screens/manager/Dash_MANAGER.dart';
import 'package:project3/screens/manager/Man_Supplier.dart';
import 'package:project3/screens/manager/Man_TAB_Procurements.dart';
import 'package:project3/screens/manager/New_Order_Details.dart';
import 'package:project3/screens/manager/PlaceOrders.dart';
import 'package:project3/screens/manager/Quotations.dart';
import 'package:project3/screens/manager/ReportPage.dart';
import 'package:project3/screens/manager/SettingsPage.dart';
import 'package:project3/screens/manager/Stock.dart';
import 'package:project3/screens/manager/VerifyOrders.dart';

class New_Orders extends StatefulWidget {
  const New_Orders({Key? key}) : super(key: key);

  @override
  State<New_Orders> createState() => _New_OrdersState();
}

class _New_OrdersState extends State<New_Orders> {
  List<dynamic> orders = []; 

  final Map<String, Color> statusColorMap = {
    'PLACED': Colors.blue[100]!,
    'PROCESSING': Colors.amber[100]!,
    'PROCESSED': Colors.cyan[100]!,
    'SHIPPED': Colors.green[100]!,
    'DELIVERED': Colors.orange[100]!,
    'CANCELLED': Colors.red[100]!,
    'COMPLETED': Colors.red[100]!,


    
  };

  @override
  void initState() {
    super.initState();
    fetchOrders();
  }

  Future<void> fetchOrders() async {
    try {
      final response = await http.get(Uri.parse('http://192.168.1.143:3000/PLACED_ORDERS'));

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

  @override
  Widget build(BuildContext context) {
            Color myColor = Color(0xFF1E2736);

    return Scaffold(
   appBar: AppBar(
        title: Text('Orders', style: TextStyle(color: Colors.white)),
        backgroundColor: myColor,
        iconTheme: IconThemeData(color: Colors.white), // Set the icon theme to white
      ),
      body: Center(
        child: orders.isEmpty
            ? CircularProgressIndicator() // Show loading indicator if orders are being fetched
            : ListView.builder(
                itemCount: orders.length,
                itemBuilder: (context, index) {
                  final order = orders[index];
                  String status = order[4]; // Extract status

                  // Determine color based on status
                  Color statusColor = statusColorMap.containsKey(status)
                      ? statusColorMap[status]!
                      : Colors.grey[100]!; // Default color if status not mapped or null

                  return GestureDetector(
                    onTap: () {
                      // Navigate to New_Order_Details page with parameters
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => New_Order_Details(
                            procId: order[0], // Extract procId from order
                            purchaseReqId: order[3], // Extract purchaseReqId from order
                          ),
                        ),
                      );
                    },
                    child: Container(
                      margin: EdgeInsets.all(8.0),
                      padding: EdgeInsets.all(12.0),
                      decoration: BoxDecoration(
                        color: statusColor, // Assign the determined status color
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
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                         
                          Text(
                            '${order[1]}',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            'Status: $status',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          // Add more order details as needed
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
          );; // Close drawer if already on Report page
        },
        onOrdersTap: () {
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
        onAddStocktTap: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => AddStock()),
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
         onProcurementTap:() {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => Man_TAB_Procurements()),
          );
        },
      ),
    );
  }
}
