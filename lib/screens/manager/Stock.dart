
import 'package:flutter/material.dart';
import 'package:project3/screens/manager/AddStock.dart';
import 'package:project3/screens/manager/View_Stock.dart';


class Stock extends StatelessWidget {
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
                  icon: Icons.add_task,
                  text: 'Add Stock',
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder:(context) => AddStock()));
                    // Handle onPressed event
                  },
                ),
                   FeatureTile(
                  icon: Icons.filter_list,
                  text: 'View Stock',
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder:(context) => View_Stock()));
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
