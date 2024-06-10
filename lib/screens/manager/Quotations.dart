import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:project3/screens/manager/AddStock.dart';
import 'package:project3/screens/manager/AppDrawerMan.dart';
import 'package:project3/screens/manager/Dash_MANAGER.dart';
import 'package:project3/screens/manager/Man_Supplier.dart';
import 'package:project3/screens/manager/Man_TAB_Procurements.dart';
import 'package:project3/screens/manager/New_Orders.dart';
import 'package:project3/screens/manager/PlaceOrders.dart';
import 'package:project3/screens/manager/ReportPage.dart';
import 'package:project3/screens/manager/SettingsPage.dart';
import 'package:project3/screens/manager/Stock.dart';
import 'package:project3/screens/manager/VerifyOrders.dart';

import 'quot_details.dart'; // Import the Quot_details page

class Quotations extends StatefulWidget {
  const Quotations({Key? key}) : super(key: key);

  @override
  State<Quotations> createState() => _QuotationsState();
}

class _QuotationsState extends State<Quotations> {
  List<dynamic> quotations = []; // List to store fetched quotations

  @override
  void initState() {
    super.initState();
    fetchQuotations(); // Fetch quotations when the widget initializes
  }

  Future<void> fetchQuotations() async {
    try {
      final response =
          await http.get(Uri.parse('http://192.168.1.143:3000/new_quotation'));

      if (response.statusCode == 200) {
        // If the API call is successful, parse the JSON response
        setState(() {
          quotations = jsonDecode(response.body);
        });
      } else {
        // Handle error response
        print('Failed to load quotations: ${response.statusCode}');
      }
    } catch (e) {
      // Handle network or parsing errors
      print('Error fetching quotations: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
      Color myColor = Color(0xFF1E2736);

    return Scaffold(
      appBar: AppBar(
        title: Text('Quotations', style: TextStyle(color: Colors.white)),
        backgroundColor: myColor,
        iconTheme: IconThemeData(color: Colors.white), // Set the icon theme to white
      ),
      body: Center(
        child: quotations.isEmpty
            ? CircularProgressIndicator() // Show loading indicator if quotations are being fetched
            : ListView.builder(
                itemCount: quotations.length,
                itemBuilder: (context, index) {
                  final quotation = quotations[index];
                  // Build styled container for each quotation
                  return GestureDetector(
                    onTap: () {
                      // Navigate to Quot_details page with parameters
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Quot_details(
                            procId: quotation[0], // Extract procId from quotation
                            purchaseReqId: quotation[3], // Extract purchaseReqId from quotation
                          ),
                        ),
                      );
                    },
                    child: Container(
                      margin: EdgeInsets.all(8.0),
                      padding: EdgeInsets.all(12.0),
                      decoration: BoxDecoration(
                        color: Colors.blue[100], // Subtle blue color for the container
                        borderRadius: BorderRadius.circular(12.0), // Rounded corners
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.3),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: Offset(0, 2), // Shadow offset
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          Text('${quotation[1]}',style: TextStyle(fontWeight: FontWeight.bold),),
                          /*Text(
                            'PROC_ID: ${quotation[0]}',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 8.0),
                          Text('DESCRIPTION: ${quotation[1]}'),
                          SizedBox(height: 8.0),
                          Text('QUOT_ID: ${quotation[2]}'),
                          SizedBox(height: 8.0),
                          Text('PURCHASE_REQ_ID: ${quotation[3]}'),*/
                        ],
                      ),
                    ),
                  );
                },
              ),
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
        onQuotationsTap: () {
          Navigator.pop(context); // Close drawer if already on Report page
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
