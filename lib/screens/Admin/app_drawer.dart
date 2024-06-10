import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:line_icons/line_icons.dart';

class AppDrawer extends StatefulWidget {
  final Color drawerColor;
  final VoidCallback onHomeTap;
  final VoidCallback onSettingsTap;
  final VoidCallback onReportTap;
  final VoidCallback onItemTap;
  final VoidCallback onAddItemTap;
  final VoidCallback onProcurementsTap;
  final VoidCallback onAddProcurementTap;
  final VoidCallback onStartProcTap;

  



  const AppDrawer({
    Key? key,
    required this.drawerColor,
    required this.onHomeTap,
    required this.onSettingsTap,
    required this.onReportTap,
    required this.onItemTap,
    required this.onAddItemTap,
    required this.onProcurementsTap,
    required this.onAddProcurementTap,
    required this.onStartProcTap




  }) : super(key: key);

  @override
  State<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
      Uint8List? _imageBytes;
  String _companyName = "";
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    final logoUrl = 'http://192.168.1.143:3000/LOGO_COMPANY';
    final detailsUrl = 'http://192.168.1.143:3000/companyDetails'; // Update with your API URL

    try {
      // Fetch logo
      final logoResponse = await http.get(Uri.parse(logoUrl));
      if (logoResponse.statusCode == 200) {
        _imageBytes = logoResponse.bodyBytes;
      } else {
        print('Failed to load company logo');
      }

      // Fetch company details
      final detailsResponse = await http.get(Uri.parse(detailsUrl));
      if (detailsResponse.statusCode == 200) {
        final jsonData = jsonDecode(detailsResponse.body);
        setState(() {
          _companyName = jsonData[0][1]; // Assuming company name is the second detail
          _isLoading = false;
        });
      } else {
        print('Failed to load company details');
      }
    } catch (e) {
      print('Error fetching data: $e');
    }
  }


  @override
  Widget build(BuildContext context) {
return Drawer(
      child: Column(
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.20,
            color: widget.drawerColor,
            child: Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: _isLoading
                    ? CircularProgressIndicator(color: Colors.white)
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 35),
                          Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                            ),
                            child: _imageBytes != null
                                ? ClipOval(
                                    child: Image.memory(
                                      _imageBytes!,
                                      fit: BoxFit.cover,
                                    ),
                                  )
                                : Center(
                                    child: Text(
                                      'A',
                                      style: TextStyle(
                                        fontSize: 20,
                                        color: widget.drawerColor,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            _companyName.isNotEmpty ? _companyName : 'Company Name',
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                        ],
                      ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              color:  Color.fromARGB(255, 255, 255, 255),
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  ListTile(
                    leading: Icon(LineIcons.home, color: Colors.grey[600]),
                    title: Text(
                      'Dashboard',
                      style: TextStyle(fontSize: 15, color: Colors.grey[900], fontWeight: FontWeight.w600),
                    ),
                    onTap: widget.onHomeTap,
                  ),
                  ListTile(
                    leading: Icon(Icons.inventory_2_outlined, color: Colors.grey[600]),
                    title: Text(
                      'Item',
                      style: TextStyle(fontSize: 15, color: Colors.grey[900], fontWeight: FontWeight.w600),
                    ),
                    onTap: widget.onItemTap,
                  ),
                  ListTile(
                    leading: Icon(Icons.add_box_outlined, color: Colors.grey[600]),
                    title: Text(
                      'Add Item',
                      style: TextStyle(fontSize: 15, color: Colors.grey[900], fontWeight: FontWeight.w600),
                    ),
                    onTap: widget.onAddItemTap,
                  ),
                     ListTile(
                    leading: Icon(Icons.shopping_basket_outlined, color: Colors.grey[600]),
                    title: Text(
                      'Procurements',
                      style: TextStyle(fontSize: 15, color: Colors.grey[900], fontWeight: FontWeight.w600),
                    ),
                    onTap: widget.onProcurementsTap,
                  ),
                     ListTile(
                    leading: Icon(Icons.add_shopping_cart, color: Colors.grey[600]),
                    title: Text(
                      'Add Procurement',
                      style: TextStyle(fontSize: 15, color: Colors.grey[900], fontWeight: FontWeight.w600),
                    ),
                    onTap: widget.onAddProcurementTap,
                  ),
                   ListTile(
                    leading: Icon(Icons.shopping_cart_checkout_outlined, color: Colors.grey[600]),
                    title: Text(
                      'Start Procurement',
                      style: TextStyle(fontSize: 15, color: Colors.grey[900], fontWeight: FontWeight.w600),
                    ),
                    onTap: widget.onStartProcTap,
                  ),
                  ListTile(
                    leading: Icon(Icons.settings_outlined, color: Colors.grey[600]),
                    title: Text(
                      'Settings',
                      style: TextStyle(fontSize: 15, color: Colors.grey[900], fontWeight: FontWeight.w600),
                    ),
                    onTap: widget.onSettingsTap,
                  ),
                  ListTile(
                    leading: Icon(Icons.insights, color: Colors.grey[600]),
                    title: Text(
                      'Reports',
                      style: TextStyle(fontSize: 15, color: Colors.grey[900], fontWeight: FontWeight.w600),
                    ),
                    onTap: widget.onReportTap,
                  ),
                   
                  // Add more ListTiles for additional drawer items
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
