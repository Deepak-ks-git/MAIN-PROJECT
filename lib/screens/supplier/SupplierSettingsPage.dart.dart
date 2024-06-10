import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:project3/screens/supplier/DeliveryPage.dart';
import 'package:project3/screens/supplier/EditQuotation.dart';
import 'package:project3/screens/supplier/List_of_Accepted.dart';
import 'package:project3/screens/supplier/OrderHistory.dart';
import 'package:project3/screens/supplier/OrdersPage.dart';
import 'package:project3/screens/supplier/Request_Tab.dart';
import 'package:project3/screens/supplier/SupplierAppDrawer.dart';
import 'package:project3/screens/supplier/SupplierNavHome.dart';
import 'package:project3/screens/supplier/SupplierProfile.dart';
import 'package:project3/screens/supplier/viewAllQuotation.dart';

class SupplierSettingsPage extends StatefulWidget {
  final String username;

  const SupplierSettingsPage({Key? key, required this.username})
      : super(key: key);

  @override
  State<SupplierSettingsPage> createState() => _SupplierSettingsPageState();
}

class _SupplierSettingsPageState extends State<SupplierSettingsPage> {
  Color myColor = Color(0xFF1E2736);

  void logoutUser(BuildContext context) async {
    try {
      final response =
          await http.post(Uri.parse('http://192.168.1.143:3000/logout'));

      if (response.statusCode == 200) {
        // Logout was successful, navigate to the home screen
        Navigator.pushNamedAndRemoveUntil(context, '/splash', (route) => false);
      } else {
        // Handle API call failure or error response
        print('Logout failed: ${response.reasonPhrase}');
        // Optionally show a message to the user
      }
    } catch (e) {
      // Handle any exception that might occur during API call
      print('Error occurred during logout: $e');
      // Optionally show a message to the user
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: myColor,
        title: Text(
          'Settings',
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.power_settings_new, color: Colors.white),
            onPressed: () {
              // Show dialog for logout confirmation
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text(
                      'Do you wish to log out?',
                      style: TextStyle(fontSize: 18),
                    ),
                    content: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context); // Close dialog
                          },
                          child: Text(
                            'CANCEL',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.green[900],
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            // Call the logout function
                            logoutUser(context); // Pass context to logoutUser
                            Navigator.pop(context); // Close dialog
                          },
                          child: Text(
                            'LOG OUT',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.green[900],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          ),
        ],
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
      ),
      body: ListView(
        padding: EdgeInsets.all(5.0),
        children: [
          ListTile(
            leading: Icon(Icons.business, color: Colors.grey[700]),
            title: Text('Supplier Profile'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        SupplierProfile(username: widget.username)),
              );
            },
          ),
    
        ],
      ),
      drawer: SupplierAppDrawer(
        drawerColor: myColor,
        onHomeTap: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => SupplierNavHome(username: widget.username)),
          );
        },
        onSettingsTap: () {
          Navigator.pop(context); // Close drawer
          // Implement any additional logic needed when Settings is tapped
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
                    EditQuotation(username:widget.username)),
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
