import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:project3/screens/supplier/SupplierNavHome.dart';
import 'package:project3/screens/supplier/SupplierProfile.dart';

class SupplierHome extends StatefulWidget {
  final String username;

  const SupplierHome({Key? key, required this.username}) : super(key: key);

  @override
  State<SupplierHome> createState() => _SupplierHomeState();
}

class _SupplierHomeState extends State<SupplierHome> {
  int _selectedIndex = 0;
  late List<Widget> _widgetOptions;
  String supplierName = '';

  @override
  void initState() {
    super.initState();
    _widgetOptions = <Widget>[
      SupplierNavHome(username: widget.username),
      SupplierProfile(username: widget.username),
    ];
    fetchSupplierName(widget.username);
  }

  Future<void> fetchSupplierName(String username) async {
    try {
      final response = await http.get(Uri.parse('http://192.168.1.142:3000/user_name_get?userId=$username'));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          supplierName = '${data[0][0]} ${data[0][1]}';
        });
      } else {
        throw Exception('Failed to fetch supplier name');
      }
    } catch (error) {
      print('Error fetching supplier name: $error');
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome, $supplierName'), // Display supplier name in the app bar
      ),
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
      ),
    );
  }
}
