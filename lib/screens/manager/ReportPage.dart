import 'package:flutter/material.dart';
import 'package:project3/screens/Admin/ProcurementReportPage.dart';
import 'package:project3/screens/Admin/SupplierReport.dart';
import 'package:project3/screens/manager/AddStock.dart';
import 'package:project3/screens/manager/AppDrawerMan.dart';
import 'package:project3/screens/manager/Dash_MANAGER.dart';
import 'package:project3/screens/manager/Man_Supplier.dart';
import 'package:project3/screens/manager/Man_TAB_Procurements.dart';
import 'package:project3/screens/manager/New_Orders.dart';
import 'package:project3/screens/manager/OrdersReport.dart';
import 'package:project3/screens/manager/PlaceOrders.dart';
import 'package:project3/screens/manager/PurchaseRequestReport.dart';
import 'package:project3/screens/manager/QuotationReport.dart';
import 'package:project3/screens/manager/Quotations.dart';
import 'package:project3/screens/manager/SettingsPage.dart';
import 'package:project3/screens/manager/Stock.dart';
import 'package:project3/screens/manager/StockHistorypPage.dart';
import 'package:project3/screens/manager/StockLevelReport.dart';
import 'package:project3/screens/manager/StockTimePeriod.dart';
import 'package:project3/screens/manager/VerifyOrders.dart';

class ReportPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Color myColor = Color(0xFF1E2736);

    return Scaffold(
      appBar: AppBar(
        title: Text('Report', style: TextStyle(color: Colors.white,fontSize: 20)),
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
          // Add more ListTiles for other reports if needed
           ListTile(
            title: Text('Supplier',style: TextStyle(fontSize: 14,color:Colors.blue),),
            onTap: () {
             Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SupplierReport()),
              );
            },
          ),
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
