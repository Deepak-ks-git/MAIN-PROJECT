import 'package:flutter/material.dart';
import 'package:project3/screens/Admin/ALL_proc.dart';
import 'package:project3/screens/Admin/AddItemScreen.dart';
import 'package:project3/screens/Admin/AddProcurement.dart';
import 'package:project3/screens/Admin/ReportPage.dart';
import 'package:project3/screens/Admin/ViewItems.dart';
import 'package:project3/screens/Admin/ViewProcurements.dart';
import 'package:project3/screens/Admin/app_drawer.dart';
import 'package:project3/screens/Admin/settings_page.dart';
import 'package:project3/screens/manager/View_Stock.dart';



class NavHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Color myColor = Color(0xFF1E2736);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Admin Home',
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
        backgroundColor: myColor,
       /* actions: [
          IconButton(
            icon: Icon(Icons.headset_mic),
            color: Colors.white,
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.notifications),
            color: Colors.white,
            onPressed: () {},
          ),
        ],
        */
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Container(
                height: 150,
                color: myColor,
              ),
              Expanded(
                child: Container(
                  color: Color.fromARGB(244, 234, 233, 233),
                ),
              ),
            ],
          ),
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Card(
                    color: Color.fromRGBO(255, 255, 255, 1),
                    elevation: 1,
                    margin: EdgeInsets.symmetric(vertical: 10),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.auto_awesome),
                              SizedBox(width: 8.0),
                              Text(
                                'Get Started',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 8),
                          Padding(
                            padding: const EdgeInsets.only(right: 20),
                            child: Text(
                              'Welcome to the Smart-Way! We\'re excited to help you get started with your procurement.',
                              style: TextStyle(fontSize: 14),
                            ),
                          ),
                          SizedBox(height: 16),
                          Row(
                            children: [
                              TextButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          ALL_proc(),
                                    ),
                                  );
                                },
                                child: Text('Procurement'),
                                style: TextButton.styleFrom(
                                  foregroundColor: Colors.grey[900],
                                  backgroundColor:
                                      Color.fromRGBO(230, 230, 248, 0.961),
                                  minimumSize: Size(135, 36),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                ),
                              ),
                              Spacer(),
                              Padding(
                                padding: const EdgeInsets.only(right: 30),
                                child: TextButton(
                                  onPressed: () {
                                     Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            View_Stock(),
                                      ),
                                    );
                                  },
                                  child: Text('Stock'),
                                  style: TextButton.styleFrom(
                                    foregroundColor: Colors.grey[900],
                                    backgroundColor:
                                        Color.fromRGBO(235, 235, 250, 0.961),
                                    minimumSize: Size(135, 36),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )
             ],
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  
                ],
              ),
            ),
          ),
        ],
      ),
      drawer: AppDrawer(
        drawerColor: myColor,
        onHomeTap: () {
          Navigator.pop(context); // Close drawer
          // Implement any additional logic needed when Home is tapped
        },
        onSettingsTap: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => SettingsPage()),
          );
        },
        onReportTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ReportPage()),
          );
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
