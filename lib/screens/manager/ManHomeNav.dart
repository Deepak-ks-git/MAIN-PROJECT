import 'package:flutter/material.dart';
import 'package:project3/screens/manager/AddStock.dart';
import 'package:project3/screens/manager/AppDrawerMan.dart';
import 'package:project3/screens/manager/Dash_MANAGER.dart';
import 'package:project3/screens/manager/Man_Supplier.dart';
import 'package:project3/screens/manager/Man_TAB_Procurements.dart';
import 'package:project3/screens/manager/New_Orders.dart';
import 'package:project3/screens/manager/OrdersHome.dart';
import 'package:project3/screens/manager/PlaceOrders.dart';
import 'package:project3/screens/manager/Quotations.dart';
import 'package:project3/screens/manager/ReportPage.dart';
import 'package:project3/screens/manager/SettingsPage.dart';
import 'package:project3/screens/manager/Stock.dart';
import 'package:project3/screens/manager/VerifyOrders.dart';

class ManHomeNav extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Color myColor = Color(0xFF1E2736);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Manager Home',
          style: TextStyle(color: Colors.white,fontSize: 20),
        ),
        backgroundColor: myColor,
        iconTheme: IconThemeData(color: Colors.white), // Set the icon theme to white
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            GridView.count(
              crossAxisCount: 2, // Number of columns in the grid
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(), // Disable GridView scrolling
              children: [
                FeatureTile(
                  icon: Icons.shopping_cart,
                  text: 'View Procurement',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Man_TAB_Procurements()),
                    );
                  },
                ),
                FeatureTile(
                  icon: Icons.person,
                  text: 'Suppliers',
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => Man_Supplier()));
                  },
                ),
                FeatureTile(
                  icon: Icons.list,
                  text: 'Quotations',
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => Quotations()));
                  },
                ),
                FeatureTile(
                  icon: Icons.shopping_bag,
                  text: 'Orders',
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => OrdersHome()));
                  },
                ),
                FeatureTile(
                  icon: Icons.stacked_bar_chart,
                  text: 'Stock',
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => Stock()));
                  },
                ),
                FeatureTile(
                  icon: Icons.home,
                  text: 'MAN',
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => Dash_MANAGER()));
                  },
                ),
              ],
            ),
          ],
        ),
      ),
        
      drawer: AppDrawerMan(
        drawerColor: myColor,
        onStockTap: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => Stock()),
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
       onHomeTap: () {
          Navigator.pop(context); // Close drawer if already on Report page
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

class FeatureTile extends StatelessWidget {
  final IconData icon;
  final String text;
  final VoidCallback onPressed;

  const FeatureTile({
    required this.icon,
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Card(
        elevation: 2,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 48),
            SizedBox(height: 8),
            Text(text, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}
