import 'package:flutter/material.dart';
import 'package:project3/screens/Admin/ALL_proc.dart';
import 'package:project3/screens/Admin/CreateProcurement.dart';
import 'package:project3/screens/Admin/add_managers_screen.dart';
import 'package:project3/screens/Admin/app_drawer.dart';
import 'package:project3/screens/Admin/settings_page.dart';

class NavHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Color myColor = Color(0xFF1C2951);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: myColor,
        title: Text(
          'Home',
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
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
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    children: [
                      FeatureTile(
                        icon: Icons.people,
                        text: 'Add Managers',
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => AddManagersScreen()),
                          );
                        },
                      ),
                      FeatureTile(
                        icon: Icons.shopping_cart,
                        text: 'Create Procurement',
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => CreateProcurement()),
                          );
                        },
                      ),
                      FeatureTile(
                        icon: Icons.shopping_cart,
                        text: 'Procurements',
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => ALL_proc()),
                          );
                        },
                      ),
                    ],
                  ),
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
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => SettingsPage()),
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
