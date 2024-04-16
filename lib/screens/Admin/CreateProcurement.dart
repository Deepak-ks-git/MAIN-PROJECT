import 'package:flutter/material.dart';
import 'package:project3/screens/Admin/AddItemScreen.dart';
import 'package:project3/screens/Admin/AddProcurement.dart';
import 'package:project3/screens/Admin/ViewItems.dart';
import 'package:project3/screens/Admin/ViewProcurements.dart';

class CreateProcurement extends StatefulWidget {
  const CreateProcurement({super.key});

  @override
  State<CreateProcurement> createState() => _CreateProcurementState();
}

class _CreateProcurementState extends State<CreateProcurement> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add new Procurement'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            GridView.count(
              crossAxisCount: 2, // Number of columns in the grid
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(), // Disable GridView scrolling
              children: [
                FeatureTile(
                  icon: Icons.add_shopping_cart_outlined,
                  text: 'Add New Procurement',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AddProcurement()),
                    );
                    //Handle onPressed event
                  },
                ),
                FeatureTile(
                  icon: Icons.view_agenda,
                  text: 'Procurements',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ViewProcurements()),
                    );
                    //Handle onPressed event
                  },
                ),
                FeatureTile(
                  icon: Icons.add_circle_outline,
                  text: 'Add New Item',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AddItemScreen()),
                    );
                    //Handle onPressed event
                  },
                ),
                FeatureTile(
                  icon: Icons.edit,
                  text: 'Manage Items',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ViewItems()),
                    );
                    //Handle onPressed event
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
