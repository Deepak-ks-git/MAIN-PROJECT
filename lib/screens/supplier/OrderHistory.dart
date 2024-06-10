import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:project3/screens/supplier/DeliveryPage.dart';
import 'package:project3/screens/supplier/EditQuotation.dart';
import 'package:project3/screens/supplier/List_of_Accepted.dart';
import 'package:project3/screens/supplier/OrderHistoryDetails.dart';
import 'package:project3/screens/supplier/OrdersPage.dart';
import 'package:project3/screens/supplier/Request_Tab.dart';
import 'package:project3/screens/supplier/SupplierAppDrawer.dart';
import 'package:project3/screens/supplier/SupplierNavHome.dart';
import 'package:project3/screens/supplier/SupplierSettingsPage.dart.dart';
import 'package:project3/screens/supplier/viewAllQuotation.dart';

class OrderHistory extends StatefulWidget {
    final String username;

  const OrderHistory({Key? key, required this.username}) : super(key: key);

  @override
  State<OrderHistory> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrderHistory> {
  List<dynamic> orders = []; 

  final Map<String, Color> statusColorMap = {
    'PLACED': Colors.blue[100]!,
    'PROCESSING': Colors.indigo[100]!,
    'PROCESSED': Colors.cyan[100]!,
    'SHIPPED': Colors.orange[100]!,
    'DELIVERED': Colors.white,
    'CANCELLED': Colors.red[100]!,

    
  };

  @override
  void initState() {
    super.initState();
    fetchOrders();
  }

  Future<void> fetchOrders() async {
    try {
      final response = await http.get(Uri.parse('http://192.168.1.143:3000/SUPPLIER_order_history'));

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
        title: Text('Order History',
            style: TextStyle(color: Colors.white, fontSize: 18)),
        backgroundColor: myColor,
        iconTheme: IconThemeData(color: Colors.white),
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
                          builder: (context) => OrderHistoryDetails(
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
                        borderRadius: BorderRadius.circular(8.0),
                        border: Border.all(color: Colors.grey),
                      
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                         
                          Text(
                            '${order[1]}',
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
       onorderHistoryTap : () {
          Navigator.pop(context); // Close drawer
        },
         onUpdateOrderTap: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    DeliveryPage(username: widget.username)),
          );
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
       onmakeQuotTap : () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => EditQuotation(username: widget.username)),
          );
        },
       onOrdersTap :
        () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    OrdersPage(username: widget.username)),
          );
        },
      ),
    );
  }
}