import 'package:flutter/material.dart';
import 'package:project3/screens/supplier/Approved_Quot.dart';
import 'package:project3/screens/supplier/DeliveryPage.dart';
import 'package:project3/screens/supplier/EditQuotation.dart';
import 'package:project3/screens/supplier/List_of_Accepted.dart';
import 'package:project3/screens/supplier/OrderHistory.dart';
import 'package:project3/screens/supplier/OrdersPage.dart';
import 'package:project3/screens/supplier/Request_Tab.dart';
import 'package:project3/screens/supplier/Sended_quot.dart';
import 'package:project3/screens/supplier/SupplierAppDrawer.dart';
import 'package:project3/screens/supplier/SupplierNavHome.dart';
import 'package:project3/screens/supplier/SupplierSettingsPage.dart.dart';
import 'package:project3/screens/supplier/Unsended_quot.dart';

class viewAllQuotation extends StatelessWidget {
  final String username;

  const viewAllQuotation({Key? key, required this.username}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color myColor = Color(0xFF1E2736);

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Quotations',
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
          iconTheme: IconThemeData(color: Colors.white), // Set the icon theme to white
          backgroundColor: myColor,
          centerTitle: true,
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(40),
            child: Padding(
              padding: const EdgeInsets.only(bottom: 8.0), // Add padding here
              child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                child: Container(
                  height: 40,
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    color: Color.fromARGB(255, 233, 233, 240),
                  ),
                  child: const TabBar(
                    indicatorSize: TabBarIndicatorSize.tab,
                    dividerColor: Colors.transparent,
                    indicator: BoxDecoration(
                      color: Color.fromARGB(255, 1, 31, 100),
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    labelColor: Colors.white,
                    unselectedLabelColor: Colors.black54,
                    tabs: [
                      Tab(text: 'NOT SEND'),
                      Tab(text: 'SEND'),
                      Tab(text: 'APPROVED'),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        body: TabBarView(
          children: [
            Center(child: Unsended_quot(username: username)),
            Center(child: Sended_quot(username: username)),
            Center(child: Approved_Quot(username: username)),
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
          onQuotationsTap: () {
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
          onRequestTap:
              () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      Request_Tab(username: username)),
            );
          },
          onStartQuotTap:
              () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      List_of_Accepted(username: username)),
            );
          },
          onmakeQuotTap:
              () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      EditQuotation(username: username)),
            );
          },
          onOrdersTap:
              () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      OrdersPage(username: username)),
            );
          },
          onUpdateOrderTap:
              () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      DeliveryPage(username: username)),
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
