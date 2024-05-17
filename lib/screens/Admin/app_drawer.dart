import 'package:flutter/material.dart';

class AppDrawer extends StatelessWidget {
  final Color drawerColor;
  final VoidCallback onHomeTap;
  final VoidCallback onSettingsTap;

  const AppDrawer({
    Key? key,
    required this.drawerColor,
    required this.onHomeTap,
    required this.onSettingsTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.15,
            color: drawerColor,
            child: Center(
              child: Text(
                'Drawer Header',
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                ListTile(
                  leading: Icon(Icons.home, color: Colors.grey),
                  title: Text(
                    'Home',
                    style: TextStyle(fontSize: 15,color: Colors.grey[900],fontWeight: FontWeight.w600),
                  ),
                  onTap: onHomeTap,
                ),
                ListTile(
                  leading: Icon(Icons.settings, color: Colors.grey),
                  title: Text(
                    'Settings',
                    style: TextStyle(fontSize: 15,color: Colors.grey[900],fontWeight: FontWeight.w600),
                  ),
                  onTap: onSettingsTap,
                ),
                // Add more ListTiles for additional drawer items
              ],
            ),
          ),
        ],
      ),
    );
  }
}
