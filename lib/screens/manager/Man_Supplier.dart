import 'package:flutter/material.dart';
import 'package:project3/screens/manager/ActiveSuppliers.dart';
import 'package:project3/screens/manager/AppDrawerMan.dart';
import 'package:project3/screens/manager/BlacklistedSuppliers.dart';
import 'package:project3/screens/manager/Dash_MANAGER.dart';
import 'package:project3/screens/manager/InActiveSuppliers.dart';
import 'package:project3/screens/manager/Man_TAB_Procurements.dart';
import 'package:project3/screens/manager/New_Orders.dart';
import 'package:project3/screens/manager/PlaceOrders.dart';
import 'package:project3/screens/manager/Quotations.dart';
import 'package:project3/screens/manager/ReportPage.dart';
import 'package:project3/screens/manager/SettingsPage.dart';
import 'package:project3/screens/manager/Stock.dart';
import 'package:project3/screens/manager/Tab_Items.dart';
import 'package:project3/screens/manager/VerifyOrders.dart';

class Man_Supplier extends StatelessWidget {
  const Man_Supplier({super.key});

  @override
  Widget build(BuildContext context) {
        Color myColor = Color(0xFF1E2736);

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            ' Suppliers',
            style: TextStyle(fontSize: 16),
          ),
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
                      TabItem(title: 'Active', count: 0,),
                      TabItem(title: 'Inactive', count: 0),
                      TabItem(title: 'BlackListed', count: 0),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        body: const TabBarView(
          children: [
            Center(child: ActiveSuppliers()),
            Center(child: InActiveSuppliers()),
            Center(child: BlacklistedSuppliers()),
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
          );; // Close drawer if already on Report page
        },
        onSupplierstTap: () {
          Navigator.pop(context); // Close drawer if already on Report page
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
      
    
      ),
    );
  }
}
