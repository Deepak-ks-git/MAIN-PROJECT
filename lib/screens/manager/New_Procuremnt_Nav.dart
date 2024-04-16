import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:line_icons/line_icons.dart';
import 'package:project3/screens/manager/Details_New_Proc.dart';
import 'package:project3/screens/manager/RequestTab.dart';
import 'package:project3/screens/manager/Select_supplier_tab.dart';

class New_Procuremnt_Nav extends StatefulWidget {
  final String procId;

  New_Procuremnt_Nav({required this.procId});

  @override
  State<New_Procuremnt_Nav> createState() => _New_Procuremnt_NavState();
}

class _New_Procuremnt_NavState extends State<New_Procuremnt_Nav> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      
      body: Center(
        child: _getSelectedTabWidget(_selectedIndex),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              blurRadius: 20,
              color: Colors.black.withOpacity(.1),
            )
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
            child: GNav(
              rippleColor: Colors.grey[300]!,
              hoverColor: Color.fromARGB(255, 8, 12, 118),
              gap: 8,
              activeColor: Colors.black,
              iconSize: 24,
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              duration: Duration(milliseconds: 400),
              tabBackgroundColor: Color.fromARGB(255, 210, 208, 238),
              color: Colors.black,
              tabs: [
                GButton(
                  icon: LineIcons.stream,
                  text: 'Details',
                ),
                GButton(
                  icon: LineIcons.userFriends,
                  text: 'Supplier',
                ),
                GButton(
                  icon: LineIcons.paperPlaneAlt,
                  text: 'Requests',
                ),
               
              
              ],
              selectedIndex: _selectedIndex,
              onTabChange: (index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _getSelectedTabWidget(int index) {
    switch (index) {
      case 0:
        return Details_New_Procurment(procId: widget.procId); // Pass procId here
      case 1:
        return SelectSupplierTab(procId: widget.procId);
      case 2:
        return RequestTab(procId: widget.procId);
      default:
        return Details_New_Procurment(procId: widget.procId); // Pass procId here as default
    }
  }
}
