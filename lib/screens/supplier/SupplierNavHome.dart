import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:project3/screens/supplier/QuotationPage.dart';
import 'package:project3/screens/supplier/Request_Tab.dart';

class SupplierNavHome extends StatelessWidget {
  final String username; // Accept username as a parameter

  const SupplierNavHome({Key? key, required this.username}) : super(key: key);
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
                  text: 'View Orders',
                  onPressed: () {
                    // Handle onPressed event
                  },
                ),
                FeatureTile(
                  icon: Icons.account_circle,
                  text: 'Profile',
                  onPressed: () {
                    // Handle onPressed event
                  },
                ),
                FeatureTile(
                  icon: Icons.list_outlined,
                  text: 'Quotations',
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder:(context) => QuotationPage(username: username,)));
                  },
                  
                ),
                FeatureTile(
                  icon: LineIcons.inbox,
                  text: 'Requests',
                  onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder:(context) => Request_Tab(username: username)));

                    // Handle onPressed event
                  },
                  
                ),
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
