import 'package:flutter/material.dart';
import 'package:project3/screens/Admin/COMPLETED_PROC.dart';
import 'package:project3/screens/manager/AddStock.dart';
import 'package:project3/screens/manager/AppDrawerMan.dart';
import 'package:project3/screens/manager/Dash_MANAGER.dart';
import 'package:project3/screens/manager/Man_New_Procurements.dart';
import 'package:project3/screens/manager/Man_OnGoing_Procurements.dart';
import 'package:project3/screens/manager/Man_Supplier.dart';
import 'package:project3/screens/manager/New_Orders.dart';
import 'package:project3/screens/manager/PlaceOrders.dart';
import 'package:project3/screens/manager/Quotations.dart';
import 'package:project3/screens/manager/ReportPage.dart';
import 'package:project3/screens/manager/SettingsPage.dart';
import 'package:project3/screens/manager/Stock.dart';
import 'package:project3/screens/manager/Tab_Items.dart';
import 'package:project3/screens/manager/VerifyOrders.dart';

class Man_TAB_Procurements extends StatelessWidget {
  const Man_TAB_Procurements({super.key});

  @override
  Widget build(BuildContext context) {
    Color myColor = const Color(0xFF1E2736);

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Procurement', style: TextStyle(color: Colors.white)),
          backgroundColor: myColor,
          iconTheme: const IconThemeData(color: Colors.white),
          centerTitle: true,
          bottom: const TabBar(
            indicatorSize: TabBarIndicatorSize.tab,
            dividerColor: Colors.transparent,
            indicator: BoxDecoration(
              color: Color.fromARGB(255, 1, 31, 100),
            ),
            labelColor: Colors.white,
            unselectedLabelColor: Color.fromARGB(137, 194, 192, 192),
            tabs: [
              TabItem(title: 'NEW', count: 0),
              TabItem(title: 'ON-GOING', count: 0),
              TabItem(title: 'COMPLETED', count: 0),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            Center(child: Man_New_Procurements()),
            Center(child: Man_OnGoing_Procurements()),
            Center(child: COMPLETED_PROC()),
          ],
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
          onProcurementTap: () {
            Navigator.pop(context); // Close drawer if already on Procurement page
          },
          onQuotationsTap: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => Quotations()),
            );
          },
          onVerifyOrdersTap: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => VerifyOrders()),
            );
          },
          onOrdersTap: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => New_Orders()),
            );
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
        ),
      ),
    );
  }
}
