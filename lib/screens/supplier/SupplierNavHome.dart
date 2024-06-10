import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:project3/screens/supplier/Approved_Quot.dart';
import 'package:project3/screens/supplier/DeliveryPage.dart';
import 'package:project3/screens/supplier/EditQuotation.dart';
import 'package:project3/screens/supplier/List_of_Accepted.dart';
import 'package:project3/screens/supplier/OrderHistory.dart';
import 'package:project3/screens/supplier/OrdersPage.dart';
import 'package:project3/screens/supplier/Request_Tab.dart';
import 'package:project3/screens/supplier/SupplierAppDrawer.dart';
import 'package:project3/screens/supplier/SupplierSettingsPage.dart.dart';
import 'package:project3/screens/supplier/Unsended_quot.dart';
import 'package:project3/screens/supplier/viewAllQuotation.dart';

class SupplierNavHome extends StatefulWidget {
  final String username;

  const SupplierNavHome({Key? key, required this.username}) : super(key: key);

  @override
  _SupplierNavHomeState createState() => _SupplierNavHomeState();
}

class _SupplierNavHomeState extends State<SupplierNavHome> {
  String supplierName = '';
    int newRequestCount = 0;
  int toCreateCount = 0;
  int toMakeCount = 0;
  int toSendCount = 0;
  int toSelectDateDeliveryCount = 0;
  int toStartDeliveryCount = 0;
  int toProcessDeliveryCount = 0;

  @override
  void initState() {
    super.initState();
        fetchCounts();

    fetchSupplierName(widget.username);
  }


  Future<void> fetchCounts() async {
    final response = await http.get(Uri.parse(
        'http://192.168.1.143:3000/getSupplierCounts?supplier_id=${widget.username}'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        newRequestCount = data['new_request'];
        toCreateCount = data['to_create'];
        toMakeCount = data['to_make'];
        toSendCount = data['to_send'];
        toSelectDateDeliveryCount = data['to_select_date_delivery'];
        toStartDeliveryCount = data['to_start_Delivery'];
        toProcessDeliveryCount = data['to_process_delivery'];
      });
    } else {
      print('Failed to load counts');
    }
  }

  Future<void> fetchSupplierName(String username) async {
    try {
      final response = await http.get(Uri.parse(
          'http://192.168.1.143:3000/user_name_get?userId=$username'));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          supplierName = '${data[0][0]} ${data[0][1]}';
        });
      } else {
        throw Exception('Failed to fetch supplier name');
      }
    } catch (error) {
      print('Error fetching supplier name: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    Color myColor = Color(0xFF1E2736);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: myColor,
        title: Text(
          'Supplier Home',
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: Icon(Icons.menu, color: Colors.white),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Center(
              child: Text(
                supplierName,
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Container(
                height: 120,
                color: myColor,
              ),
              Expanded(
                child: Container(
                  color: Color.fromARGB(244, 234, 233, 233),
                ),
              ),
            ],
          ),
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Card(
                    color: Color.fromRGBO(255, 255, 255, 1),
                    elevation: 1,
                    margin: EdgeInsets.symmetric(vertical: 10),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.auto_awesome),
                              SizedBox(width: 8.0),
                              Text(
                                'Get Started',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 8),
                          Padding(
                            padding: const EdgeInsets.only(right: 20),
                            child: Text(
                              'Welcome to the Smart-Way! We\'re excited to help you get started with your procurement.',
                              style: TextStyle(fontSize: 14),
                            ),
                          ),
                          SizedBox(height: 16),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Text(
                          'Your Activity',
                          style: TextStyle(
                              fontSize: 18,
                              color: Colors.grey[800],
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                      Spacer(),
                      IconButton(
                        icon: Icon(Icons.refresh),
                        onPressed: () {
                          fetchCounts();
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  ListView(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    children: [
                      SalesActivityItem(
                        icon: Icons.shopping_cart,
                        label: 'New purchase requests',
                        count: newRequestCount,
                        color: Colors.orange,
                        onPressed: newRequestCount > 0
                            ? () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Request_Tab(
                                            username: widget.username,
                                          )),
                                );
                              }
                            : null,
                      ),
                      SalesActivityItem(
                        icon: Icons.rocket_launch_outlined,
                        label: 'Quotations to be started',
                        count: toCreateCount,
                        color: Colors.blue,
                        onPressed: toCreateCount > 0
                            ? () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => List_of_Accepted(
                                            username: widget.username,
                                          )),
                                );
                                // Implement action for this item
                              }
                            : null,
                      ),
                      SalesActivityItem(
                        icon: Icons.receipt_long,
                        label: 'Quotations to be created',
                        count: toMakeCount,
                        color: Colors.yellow.shade600,
                        onPressed: toMakeCount > 0
                            ? () {
                               Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => EditQuotation(
                                            username: widget.username,
                                          )),
                                );
                                // Implement action for this item
                              }
                            : null,
                      ),
                      SalesActivityItem(
                        icon:Icons.send,
                        label: 'Quotations to send',
                        count: toSendCount,
                        color: Colors.green,
                        onPressed: toSendCount > 0
                            ? () {
                               Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Unsended_quot(
                                            username: widget.username,
                                          )),
                                );
                                // Implement action for this item
                              }
                            : null,
                      ),
                      SalesActivityItem(
                        icon: Icons.calendar_month_outlined,
                        label: 'To select delivery date',
                        count: toSelectDateDeliveryCount,
                        color: Color.fromARGB(255, 222, 119, 54),
                        onPressed: toSelectDateDeliveryCount > 0
                            ? () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Approved_Quot(
                                            username: widget.username,
                                          )),
                                );
                              }
                            : null,
                      ),
                      SalesActivityItem(
                        icon: Icons.local_shipping_outlined,
                        label: 'To start delivery',
                        count: toStartDeliveryCount,
                        color: Color.fromARGB(255, 0, 0, 0),
                        onPressed: toStartDeliveryCount > 0
                            ? () {
                               Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => OrdersPage(
                                            username: widget.username,
                                          )),
                                );
                                // Implement action for this item
                              }
                            : null,
                      ),
                      SalesActivityItem(
                        icon: Icons.wifi_protected_setup_sharp,
                        label: 'In delivery',
                        count: toProcessDeliveryCount,
                        color: Color.fromARGB(255, 113, 26, 106),
                        onPressed: toProcessDeliveryCount > 0
                            ? () {
                               Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => DeliveryPage(
                                            username: widget.username,
                                          )),
                                );
                          
                                // Implement action for this item
                              }
                            : null,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
     drawer: SupplierAppDrawer(
        drawerColor: myColor,
        onHomeTap: () {
          // Navigator.pop(context);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    SupplierNavHome(username: widget.username)),
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
                builder: (context) =>
                    Request_Tab(username: widget.username)),
          );
        },
        onQuotationsTap:
        () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    viewAllQuotation(username: widget.username)),
          );
        },
        
         onStartQuotTap:
        () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    List_of_Accepted(username: widget.username)),
          );
        },
         onmakeQuotTap:
         () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    EditQuotation(username:widget. username)),
          );
        },
         onOrdersTap:
         () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    OrdersPage(username:widget. username)),
          );
        },
        onUpdateOrderTap:
        () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    DeliveryPage(username: widget.username)),
          );
        },
         onorderHistoryTap :
        () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    OrderHistory(username: widget.username)),
          );
        },
      ),
    );
  }
}


class SalesActivityItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final int count;
  final Color color;
  final VoidCallback? onPressed;

  SalesActivityItem({
    required this.icon,
    required this.label,
    required this.count,
    required this.color,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 5,
              offset: Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: color,
                child: Icon(icon, color: Colors.white),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '$count',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      label,
                      style: TextStyle(
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 8),
              Icon(Icons.arrow_forward_ios),
            ],
          ),
        ),
      ),
    );
  }
}
