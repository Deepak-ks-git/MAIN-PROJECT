import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:project3/screens/manager/DetailedSupplierInfo.dart';

class SelectSupplierTab extends StatefulWidget {
  final String procId;

  const SelectSupplierTab({Key? key, required this.procId}) : super(key: key);

  @override
  State<SelectSupplierTab> createState() => _SelectSupplierTabState();
}

class _SelectSupplierTabState extends State<SelectSupplierTab> {
  late Future<List<List<String>>> _selectSupplierTab;
  int _selectedIndex = -1;
  bool _isTapped = false; // Flag to track if the container is tapped

  @override
  void initState() {
    super.initState();
    _selectSupplierTab = fetchSelectSupplierTab();
  }

  @override
  void dispose() {
    _isTapped = false; // Reset the flag when disposing the widget
    super.dispose();
  }

  Future<List<List<String>>> fetchSelectSupplierTab() async {
    final response =
        await http.get(Uri.parse('http://192.168.1.143:3000/active_suppliers'));

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return List<List<String>>.from(data.map((e) => List<String>.from(e)));
    } else {
      throw Exception('Failed to load active suppliers');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<List<String>>>(
        future: _selectSupplierTab,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final selectSupplierTab = snapshot.data!;
            return Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 2,
                    blurRadius: 4,
                    offset: Offset(0, 2), // changes position of shadow
                  ),
                ],
              ),
              child: ListView.builder(
                itemCount: selectSupplierTab.length,
                itemBuilder: (context, index) {
                  final supplier = selectSupplierTab[index];
                  return GestureDetector(
                    onTap: () {
                      if (!_isTapped) {
                        setState(() {
                          _selectedIndex = index == _selectedIndex ? -1 : index;
                        });
                        _showOptions(context, supplier[0]);
                        _isTapped = true; // Set the flag to true after showing the option
                        // Reset the flag after a short delay
                        Future.delayed(Duration(milliseconds: 500), () {
                          setState(() {
                            _isTapped = false;
                          });
                        });
                      }
                    },
                    child: Container(
                      margin: EdgeInsets.symmetric(vertical: 5.0, horizontal: 20.0),
                      padding: EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12.0),
                                                  border: Border.all(color: Colors.grey),

                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  supplier[1], // Company Name
                                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14.0), // Reduced font size
                                ),
                                SizedBox(height: 4.0),
                                Text(
                                  "${supplier[2]} ${supplier[3]}", // First Name + Last Name
                                  style: TextStyle(fontSize: 14.0), // Reduced font size
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.ads_click),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => DetailedSupplierInfo(supplierId: supplier[0]),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            );
          }
        },
      ),
    );
  }

  void _showOptions(BuildContext context, String supplierId) async {
    // Check the status of the purchase request associated with procId
    final purchaseRequestStatus = await _getPurchaseRequestStatus(widget.procId);

    // If the status is "READY", display a message and return without allowing selection
    if (purchaseRequestStatus == 'READY') {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Supplier Already Selected'),
            content: Text('You have already selected a supplier for this procurement request.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
      return;
    }

    // If the status is not "READY", proceed with showing the options
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: Text('Select Supplier'),
              onTap: () async {
                // Handle your logic here
                // Call the API endpoint
                try {
                  final response = await http.post(
                    Uri.parse('http://192.168.1.143:3000/Select_supplier'),
                    body: jsonEncode({
                      'procId': widget.procId,
                      'user_id': 'man10', // Replace with your actual user id
                      'supplier_id': supplierId,
                    }),
                    headers: {
                      'Content-Type': 'application/json',
                    },
                  );
                  if (response.statusCode == 200) {
                    // Handle success
                    print('Supplier selected successfully');
                  } else {
                    // Handle failure
                    print('Failed to select supplier: ${response.reasonPhrase}');
                  }
                } catch (error) {
                  // Handle error
                  print('Error selecting supplier: $error');
                }
                Navigator.pop(context);
              },
            ),
            SizedBox(height: 100,)
          ],
        );
      },
    );
  }

  Future<String> _getPurchaseRequestStatus(String procId) async {
  try {
    if (procId.isEmpty) {
      // If procId is empty, return a default status
      return 'NOT_FOUND';
    }

    final response = await http.get(
      Uri.parse('http://192.168.1.143:3000/purchase_request_status?procId=$procId'),
    );
    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      return jsonResponse['status'];
    } else {
      throw Exception('Failed to get purchase request status');
    }
  } catch (error) {
    print('Error getting purchase request status: $error');
    return 'NOT_FOUND'; // Return a default status if an error occurs
  }
}
}