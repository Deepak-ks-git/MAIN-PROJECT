import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';

class SupplierAppDrawer extends StatelessWidget {
  final Color drawerColor;
  final VoidCallback onHomeTap;
  final VoidCallback onSettingsTap;
  final VoidCallback onRequestTap;
  final VoidCallback onQuotationsTap;
  final VoidCallback onStartQuotTap;
  final VoidCallback onmakeQuotTap;
  final VoidCallback onOrdersTap;
  final VoidCallback onUpdateOrderTap;
  final VoidCallback onorderHistoryTap;


  const SupplierAppDrawer({
    Key? key,
    required this.drawerColor,
    required this.onHomeTap,
    required this.onSettingsTap,
    required this.onRequestTap,
    required this.onQuotationsTap,
    required this.onStartQuotTap,
    required this.onmakeQuotTap,
    required this.onOrdersTap,
    required this.onUpdateOrderTap,
        required this.onorderHistoryTap,

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
                'Supplier',
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
          ),
          Expanded(
            child: Container(
              color: const Color.fromARGB(255, 255, 255, 255),
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  ListTile(
                    leading: Icon(LineIcons.home, color: Colors.grey[600]),
                    title: Text(
                      'Dashboard',
                      style: TextStyle(fontSize: 15, color: Colors.grey[900], fontWeight: FontWeight.w600),
                    ),
                    onTap: onHomeTap,
                  ),
                  ListTile(
                    leading: Icon(Icons.shopping_cart_checkout, color: Colors.grey[600]),
                    title: Text(
                      'Purchase Requests',
                      style: TextStyle(fontSize: 15, color: Colors.grey[900], fontWeight: FontWeight.w600),
                    ),
                    onTap: onRequestTap,
                  ),
                  ListTile(
                    leading: Icon(Icons.receipt_long, color: Colors.grey[600]),
                    title: Text(
                      'Quotations',
                      style: TextStyle(fontSize: 15, color: Colors.grey[900], fontWeight: FontWeight.w600),
                    ),
                    onTap: onQuotationsTap,
                  ),
                  ListTile(
                    leading: Icon(Icons.assignment_turned_in, color: Colors.grey[600]),
                    title: Text(
                      'Accepted Quotations',
                      style: TextStyle(fontSize: 15, color: Colors.grey[900], fontWeight: FontWeight.w600),
                    ),
                    onTap: onStartQuotTap,
                  ),
                  ListTile(
                    leading: Icon(Icons.edit, color: Colors.grey[600]),
                    title: Text(
                      'Edit Quotation',
                      style: TextStyle(fontSize: 15, color: Colors.grey[900], fontWeight: FontWeight.w600),
                    ),
                    onTap: onmakeQuotTap,
                  ),
                  ListTile(
                    leading: Icon(Icons.shopping_bag_outlined, color: Colors.grey[600]),
                    title: Text(
                      'Orders',
                      style: TextStyle(fontSize: 15, color: Colors.grey[900], fontWeight: FontWeight.w600),
                    ),
                    onTap: onOrdersTap,
                  ),
                   ListTile(
                    leading: Icon(Icons.shopping_bag_outlined, color: Colors.grey[600]),
                    title: Text(
                      'Order History',
                      style: TextStyle(fontSize: 15, color: Colors.grey[900], fontWeight: FontWeight.w600),
                    ),
                    onTap: onorderHistoryTap,
                  ),
                  ListTile(
                    leading: Icon(Icons.delivery_dining, color: Colors.grey[600]),
                    title: Text(
                      'Update Order',
                      style: TextStyle(fontSize: 15, color: Colors.grey[900], fontWeight: FontWeight.w600),
                    ),
                    onTap: onUpdateOrderTap,
                  ),
                  ListTile(
                    leading: Icon(Icons.settings_outlined, color: Colors.grey[600]),
                    title: Text(
                      'Settings',
                      style: TextStyle(fontSize: 15, color: Colors.grey[900], fontWeight: FontWeight.w600),
                    ),
                    onTap: onSettingsTap,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
