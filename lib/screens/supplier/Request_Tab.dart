import 'package:flutter/material.dart';
import 'package:project3/screens/supplier/Accepted_Request.dart';
import 'package:project3/screens/supplier/DeliveryPage.dart';
import 'package:project3/screens/supplier/EditQuotation.dart';
import 'package:project3/screens/supplier/List_of_Accepted.dart';
import 'package:project3/screens/supplier/New_Request.dart';
import 'package:project3/screens/supplier/OrderHistory.dart';
import 'package:project3/screens/supplier/OrdersPage.dart';
import 'package:project3/screens/supplier/Rejected_Request.dart';
import 'package:project3/screens/supplier/SupplierAppDrawer.dart';
import 'package:project3/screens/supplier/SupplierNavHome.dart';
import 'package:project3/screens/supplier/SupplierSettingsPage.dart.dart';
import 'package:project3/screens/supplier/viewAllQuotation.dart';

class Request_Tab extends StatelessWidget {
  final String username;

  const Request_Tab({Key? key, required this.username}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color myColor = Color(0xFF1E2736);

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Purchase Request', style: TextStyle(color: Colors.white,fontSize: 18)),
          backgroundColor: myColor,
          iconTheme: const IconThemeData(color: Colors.white),
          centerTitle: true,
          bottom: TabBar(
            indicatorSize: TabBarIndicatorSize.tab,
            indicator: BoxDecoration(
              color: Color.fromARGB(255, 1, 31, 100),
            ),
            labelColor: Colors.white,
            unselectedLabelColor: Color.fromARGB(137, 194, 192, 192),
            tabs: [
              Tab(text: 'NEW'),
              Tab(text: 'ACCEPTED'),
              Tab(text: 'REJECTED'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            Center(child: New_Request(username: username)),
            Center(child: Accepted_Request(username: username)),
            Center(child: Rejected_Request(username: username)),
          ],
        ),
        drawer: SupplierAppDrawer(
          drawerColor: myColor,
          onHomeTap: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => SupplierNavHome(username: username)),
            );
          },
          onRequestTap: () {
            Navigator.pop(context); // Close drawer
            // Implement any additional logic needed when Settings is tapped
          },
          onSettingsTap: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      SupplierSettingsPage(username: username)),
            );
          },
          onQuotationsTap: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      viewAllQuotation(username: username)),
            );
          },
          onStartQuotTap: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      List_of_Accepted(username: username)),
            );
          },
          onmakeQuotTap: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => EditQuotation(username: username)),
            );
          },
          onOrdersTap: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => OrdersPage(username: username)),
            );
          },
          onUpdateOrderTap: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => DeliveryPage(username: username)),
            );

          },
           onorderHistoryTap :
        () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    OrderHistory(username: username)),
          );
        },
        ),
      ),
    );
  }
}
