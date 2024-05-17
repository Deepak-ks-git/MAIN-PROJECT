import 'package:flutter/material.dart';
import 'package:project3/screens/manager/New_Orders.dart';
import 'package:project3/screens/manager/PlaceOrders.dart';
import 'package:project3/screens/manager/VerifyOrders.dart';


class OrdersHome extends StatelessWidget {
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
                  icon: Icons.add_circle_outline,
                  text: 'Place Orders',
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder:(context) => PlaceOrders()));
                    // Handle onPressed event
                  },
                ),
                   FeatureTile(
                  icon: Icons.view_list,
                  text: 'New Orders',
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder:(context) => New_Orders()));
                    // Handle onPressed event
                  },
                ),
               
                FeatureTile(
                  icon: Icons.verified,
                  text: 'Verify Orders',
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder:(context) => VerifyOrders()));
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
