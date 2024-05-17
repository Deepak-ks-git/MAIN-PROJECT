import 'package:flutter/material.dart';
import 'package:project3/screens/manager/Man_Supplier.dart';
import 'package:project3/screens/manager/Man_TAB_Procurements.dart';
import 'package:project3/screens/manager/OrdersHome.dart';
import 'package:project3/screens/manager/Quotations.dart';
import 'package:project3/screens/manager/Stock.dart';


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
                  icon: Icons.list_outlined,
                  text: 'Quotations',
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder:(context) => Quotations()));
                    // Handle onPressed event
                  },
                ),
                 FeatureTile(
                  icon: Icons.shopping_bag,
                  text: 'Orders',
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder:(context) => OrdersHome()));
                    // Handle onPressed event
                  },
                ),
              
               FeatureTile(
                  icon: Icons.stacked_bar_chart,
                  text: 'Stock',
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder:(context) => Stock()));
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
