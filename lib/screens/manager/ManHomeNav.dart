import 'package:flutter/material.dart';
import 'package:project3/screens/manager/Man_Supplier.dart';
import 'package:project3/screens/manager/Man_TAB_Procurements.dart';


class ManHomeNav extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  text: 'view Procurement',
                  onPressed: () {
                   /* Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Man_New_Procurements()),
                    );*/
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Man_TAB_Procurements()),
                    );
                    // Handle onPressed event
                  },
                ),
                FeatureTile(
                  icon: Icons.person_4,
                  text: 'Suppliers',
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder:(context) => Man_Supplier()));
                    // Handle onPressed event
                  },
                ),
                FeatureTile(
                  icon: Icons.payment,
                  text: 'Process Payments',
                  onPressed: () {
                    // Handle onPressed event
                  },
                ),
                FeatureTile(
                  icon: Icons.inventory,
                  text: 'Manage Inventory',
                  onPressed: () {
                    // Handle onPressed event
                  },
                ),
                FeatureTile(
                  icon: Icons.analytics,
                  text: 'View Analytics',
                  onPressed: () {
                    // Handle onPressed event
                  },
                ),
                FeatureTile(
                  icon: Icons.report,
                  text: 'Generate Reports',
                  onPressed: () {
                    // Handle onPressed event
                  },
                ),
                FeatureTile(
                  icon: Icons.settings,
                  text: 'Settings',
                  onPressed: () {
                    // Handle onPressed event
                  },
                ),
                FeatureTile(
                  icon: Icons.notifications,
                  text: 'Manage Notifications',
                  onPressed: () {
                    // Handle onPressed event
                  },
                ),
                FeatureTile(
                  icon: Icons.mail,
                  text: 'Send Emails',
                  onPressed: () {
                    // Handle onPressed event
                  },
                ),
                FeatureTile(
                  icon: Icons.help,
                  text: 'Help & Support',
                  onPressed: () {
                    // Handle onPressed event
                  },
                ),
                // Add more FeatureTiles as needed
              ],
            ),
          ],
        ),
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
