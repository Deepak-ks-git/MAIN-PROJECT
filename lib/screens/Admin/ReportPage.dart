// report_page.dart
import 'package:flutter/material.dart';
import 'package:project3/screens/Admin/ALL_proc.dart';
import 'package:project3/screens/Admin/AddItemScreen.dart';
import 'package:project3/screens/Admin/AddProcurement.dart';
import 'package:project3/screens/Admin/Admin_Homepage.dart';
import 'package:project3/screens/Admin/ProcurementReportPage.dart';
import 'package:project3/screens/Admin/SupplierReport.dart';
import 'package:project3/screens/Admin/ViewItems.dart';
import 'package:project3/screens/Admin/ViewProcurements.dart';
import 'package:project3/screens/Admin/app_drawer.dart'; // Import the AppDrawer
import 'package:project3/screens/Admin/settings_page.dart';
import 'package:project3/screens/manager/OrdersReport.dart';
import 'package:project3/screens/manager/PurchaseRequestReport.dart';
import 'package:project3/screens/manager/QuotationReport.dart';
import 'package:project3/screens/manager/StockHistorypPage.dart';
import 'package:project3/screens/manager/StockLevelReport.dart';
import 'package:project3/screens/manager/StockTimePeriod.dart'; // Import SettingsPage

class ReportPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Color myColor = Color(0xFF1E2736);

    return Scaffold(
      appBar: AppBar(
        title: Text('Reports', style: TextStyle(color: Colors.white,fontSize: 16)),
        backgroundColor: myColor,
        iconTheme: IconThemeData(color: Colors.white), // Set the icon theme to white
      ),
      body: ListView(
        children: [
                    ListTile(
            title: Text('Procurement',style: TextStyle(fontSize: 14,color:Colors.blue),),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProcurementReportPage()),
              );
            },
          ),
          ListTile(
            title: Text('Purchase Request',style: TextStyle(fontSize: 14,color:Colors.blue),),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PurchaseRequestReport()),
              );
            },
          ),
          ListTile(
            title: Text('Quotation',style: TextStyle(fontSize: 14,color:Colors.blue),),
            onTap: () {
             Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => QuotationReport()),
              );
            },
          ),
           ListTile(
            title: Text('Orders',style: TextStyle(fontSize: 14,color:Colors.blue),),
            onTap: () {
             Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => OrdersReport()),
              );
            },
          ),
          ListTile(
            title: Text('Stock',style: TextStyle(fontSize: 14,color:Colors.blue),),
            onTap: () {
              // Do nothing on main tap, but the children will have their own onTap
            },
          ),
            ListTile(
            title: Text('By Stock Level',style: TextStyle(fontSize: 16),),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => StockLevelReport()),
              );}
          ),
          

            
          Padding(
            padding: EdgeInsets.only(left: 15),
            child: Divider(height: 0),
          ),
          ListTile(
            title: Text('By Individual Item',style: TextStyle(fontSize: 16),),
           onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => StockHistoryPage()),
              );}
          ),
             Padding(
            padding: EdgeInsets.only(left: 15),
            child: Divider(height: 0),
          ),
          ListTile(
            title: Text('By Time Period',style: TextStyle(fontSize: 16),),
           onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => StockTimePeriod()),
              );}
          ),
          
          Padding(
            padding: EdgeInsets.only(left: 15),
            child: Divider(height: 0),
          ),
          ListTile(
            title: Text('Supplier',style: TextStyle(fontSize: 14,color:Colors.blue),),
            onTap: () {
             Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SupplierReport()),
              );
            },
          ),
          // Add more ListTiles for other reports if needed
        ],
      ),
      drawer: AppDrawer(
        drawerColor: myColor,
        onHomeTap: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => NavHomePage()),
          );
        },
        onSettingsTap: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => SettingsPage()),
          );
        },
        onReportTap: () {
          Navigator.pop(context); // Close drawer if already on Report page
        },
        onItemTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ViewItems()),
          );
        },
         onAddItemTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddItemScreen()),
          );
        },
         onProcurementsTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ALL_proc()),
          );
        },
         onAddProcurementTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddProcurement()),
          );
        },
         onStartProcTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ViewProcurements()),
          );
        },
   
      ),
    );
  }
}
