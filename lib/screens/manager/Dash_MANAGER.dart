import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:line_icons/line_icons.dart';
import 'package:project3/screens/manager/AddStock.dart';
import 'package:project3/screens/manager/AppDrawerMan.dart';
import 'package:project3/screens/manager/Man_Supplier.dart';
import 'package:project3/screens/manager/Man_TAB_Procurements.dart';
import 'package:project3/screens/manager/New_Orders.dart';
import 'package:project3/screens/manager/PlaceOrders.dart';
import 'package:project3/screens/manager/Quotations.dart';
import 'package:project3/screens/manager/ReportPage.dart';
import 'package:project3/screens/manager/SettingsPage.dart';
import 'package:project3/screens/manager/Stock.dart';
import 'package:project3/screens/manager/VerifyOrders.dart';
import 'package:project3/screens/manager/View_Stock.dart';

class Dash_MANAGER extends StatefulWidget {
  const Dash_MANAGER({super.key});

  @override
  State<Dash_MANAGER> createState() => _Dash_MANAGERState();
}

class _Dash_MANAGERState extends State<Dash_MANAGER> {
  int completedOrdersCount = 0;
  int deliveredOrdersCount = 0;
  int sentQuotationsCount = 0;
  int notPlacedCount = 0;

  @override
  void initState() {
    super.initState();
    fetchCounts();
  }

  Future<void> fetchCounts() async {
    final response =
        await http.get(Uri.parse('http://192.168.1.143:3000/getCounts'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        completedOrdersCount = data['completed_orders_count'];
        deliveredOrdersCount = data['delivered_orders_count'];
        sentQuotationsCount = data['sent_quotations_count'];
        notPlacedCount = data['approved_not_placed_count'];
      });
    } else {
      // Handle error
      print('Failed to load counts');
    }
  }

  @override
  Widget build(BuildContext context) {
    Color myColor = Color(0xFF1E2736);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Manager Home',
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
        backgroundColor: myColor,
        /*
        actions: [
          IconButton(
            icon: Icon(Icons.headset_mic),
            color: Colors.white,
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.notifications),
            color: Colors.white,
            onPressed: () {},
          ),
        ],*/
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Container(
                height: 150,
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
                          Row(
                            children: [
                              TextButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          Man_TAB_Procurements(),
                                    ),
                                  );
                                },
                                child: Text('Procurement'),
                                style: TextButton.styleFrom(
                                  foregroundColor: Colors.grey[900],
                                  backgroundColor:
                                      Color.fromRGBO(230, 230, 248, 0.961),
                                  minimumSize: Size(135, 36),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                ),
                              ),
                              Spacer(),
                              Padding(
                                padding: const EdgeInsets.only(right: 30),
                                child: TextButton(
                                  onPressed: () {
                                     Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            View_Stock(),
                                      ),
                                    );
                                  },
                                  child: Text('Stock'),
                                  style: TextButton.styleFrom(
                                    foregroundColor: Colors.grey[900],
                                    backgroundColor:
                                        Color.fromRGBO(235, 235, 250, 0.961),
                                    minimumSize: Size(135, 36),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )
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
                        icon: LineIcons.box,
                        label: 'Stock to be added',
                        count: completedOrdersCount,
                        color: Colors.orange,
                        onPressed: completedOrdersCount > 0
                            ? () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => AddStock(),
                                  ),
                                );
                              }
                            : null,
                      ),
                      SalesActivityItem(
                        icon: Icons.local_shipping,
                        label: 'Delivery to be verified',
                        count: deliveredOrdersCount,
                        color: Colors.blue,
                        onPressed: deliveredOrdersCount > 0
                            ? () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => VerifyOrders(),
                                  ),
                                );
                              }
                            : null,
                      ),
                      SalesActivityItem(
                        icon: Icons.add_shopping_cart,
                        label: 'Orders to be Placed',
                        count: notPlacedCount,
                        color: Colors.yellow.shade600,
                        onPressed: notPlacedCount > 0
                            ? () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => PlaceOrders(),
                                  ),
                                );
                              }
                            : null,
                      ),
                      SalesActivityItem(
                        icon: Icons.receipt_long_outlined,
                        label: 'Quotations to approve',
                        count: sentQuotationsCount,
                        color: Colors.green,
                        onPressed: sentQuotationsCount > 0
                            ? () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => Quotations(),
                                  ),
                                );
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
      drawer: AppDrawerMan(
        drawerColor: myColor,
        onHomeTap: () {
          Navigator.pop(context);
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
        onStockTap: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => Stock()),
          );
        },
        onAddStocktTap: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => AddStock()),
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
              Column(
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
              Spacer(),
              Text(
                '>',
                style: TextStyle(
                  fontSize: 22,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
