import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:project3/screens/Admin/Admin_Homepage.dart';
import 'package:project3/screens/Admin/Company_Profile.dart';
import 'package:project3/screens/Admin/app_drawer.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Color myColor = Color(0xFF1C2951);
    void logoutUser(BuildContext context) async {
      try {
        // Call your API to logout
        final response =
            await http.post(Uri.parse('http://192.168.1.142:3000/logout'));

        if (response.statusCode == 200) {
          // Logout was successful, navigate to the HomeScreen
          Navigator.pushNamedAndRemoveUntil(
            context,
            '/home',
            (route) => false, // Remove all routes
          );
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
            title: Text('Company Profile'),
            onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context)=>CompanyProfile()));
            },
          ),
          ListTile(
            leading: Icon(Icons.people, color: Colors.grey[700]),
            title: Text('Users'),
            onTap: () {
              // Navigate to users page
              // Implement navigation logic here
            },
          ),
          // Add more ListTiles for additional options
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
          Navigator.pop(context); // Close drawer
          // Implement any additional logic needed when Settings is tapped
        },
      ),
    );
  }
}
