import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class RequestTab extends StatefulWidget {
  final String procId;

  const RequestTab({Key? key, required this.procId}) : super(key: key);

  @override
  State<RequestTab> createState() => _RequestTabState();
}

class _RequestTabState extends State<RequestTab> {
  late Future<List<dynamic>> _purchaseRequestDetails;
  late Future<List<dynamic>> _supplierDetails;
  _MyInheritedWidgetState? _ancestorWidgetState;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _ancestorWidgetState = _MyInheritedWidget.of(context);
  }

  @override
  void initState() {
    super.initState();
    _purchaseRequestDetails = fetchPurchaseRequestDetails();
  }

  Future<List<dynamic>> fetchPurchaseRequestDetails() async {
    try {
      final response = await http.get(Uri.parse(
          'http://192.168.1.142:3000/reqdetails_for_sending?procId=${widget.procId}'));

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to load purchase request details');
      }
    } catch (error) {
      throw Exception('Error fetching purchase request details: $error');
    }
  }

  Future<List<dynamic>> fetchSupplierDetails(String supplierId) async {
    try {
      final response = await http.get(Uri.parse(
          'http://192.168.1.142:3000/supplier_details_for_sending?supplierId=$supplierId'));

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to load supplier details');
      }
    } catch (error) {
      throw Exception('Error fetching supplier details: $error');
    }
  }

  Future<void> removeSupplier(String procId) async {
    try {
      final response = await http.post(
        Uri.parse('http://192.168.1.142:3000/drop_selected_supplier'),
        body: jsonEncode({'procId': procId}),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      if (response.statusCode == 200) {
        _ancestorWidgetState?.reloadPage();
      } else {
        throw Exception('Failed to remove supplier');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Request"),
      ),
      body: Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              flex: 1,
              child: Container(
                padding: EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  boxShadow: [
                    BoxShadow(
                      color: const Color.fromARGB(255, 158, 158, 158).withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: FutureBuilder<List<dynamic>>(
                  future: _purchaseRequestDetails,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else {
                      final details = snapshot.data!;
                      if (details.isEmpty) {
                        return Center(
                            child: Text('No purchase request details found'));
                      } else {
                        final purchaseReqId = details[0][0];
                        final supplierId = details[0][1];
                        _supplierDetails = fetchSupplierDetails(supplierId);
                        return FutureBuilder<List<dynamic>>(
                          future: _supplierDetails,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Center(child: CircularProgressIndicator());
                            } else if (snapshot.hasError) {
                              return Center(
                                  child: Text('Error: ${snapshot.error}'));
                            } else {
                              final supplierDetails = snapshot.data!;
                              if (supplierDetails.isEmpty) {
                                return Center(
                                    child: Text('No supplier details found'));
                              } else {
                                final supplierDetail = supplierDetails[0];
                                final firstName = supplierDetail[0];
                                final lastName = supplierDetail[1];
                                final companyName = supplierDetail[2];
                                final email = supplierDetail[3];
                                final phone = supplierDetail[4];
                                final alternateNumber = supplierDetail[5];
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Purchase Request ID: $purchaseReqId'),
                                    Text('Supplier ID: $supplierId'),
                                    SizedBox(height: 10),
                                    Divider(),
                                    SizedBox(height: 10),
                                    Center(
                                        child: Text('Supplier Details:',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16))),
                                    SizedBox(height: 10),
                                    Center(
                                      child: Container(
                                        padding: EdgeInsets.all(40.0),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                          color: Colors.white,
                                          boxShadow: [
                                            BoxShadow(
                                              color:
                                                  Color.fromARGB(255, 10, 3, 104).withOpacity(0.5),
                                              spreadRadius: 2,
                                              blurRadius: 4,
                                              offset: Offset(0, 2),
                                            ),
                                          ],
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text('$firstName $lastName'),
                                            const SizedBox(
                                              height: 3,
                                            ),
                                            Text('$companyName'),
                                            const SizedBox(
                                              height: 3,
                                            ),
                                            Text('Email: $email'),
                                            const SizedBox(
                                              height: 3,
                                            ),
                                            Text('Phone: $phone'),
                                            const SizedBox(
                                              height: 3,
                                            ),
                                            Text(
                                                'Alternate Number: $alternateNumber'),
                                          ],
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 30),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Column(
                                          children: [
                                            ElevatedButton(
                                              onPressed: () {
                                                showDialog(
                                                  context: context,
                                                  builder: (BuildContext context) {
                                                    return AlertDialog(
                                                      title: Text('Send Confirmation'),
                                                      content: Text('Are you sure you want to send?'),
                                                      actions: [
                                                        TextButton(
                                                          onPressed: () async {
                                                            Navigator.of(context).pop();
                                                            try {
                                                              final response = await http.post(
                                                                Uri.parse('http://192.168.1.142:3000/insert_and_update_purchase_request_detail'),
                                                                body: jsonEncode({
                                                                  'PURCH_REQ_ID': purchaseReqId,
                                                                  'procId': widget.procId,
                                                                }),
                                                                headers: <String, String>{
                                                                  'Content-Type': 'application/json; charset=UTF-8',
                                                                },
                                                              );
                                                              if (response.statusCode == 200) {
                                                                ScaffoldMessenger.of(context).showSnackBar(
                                                                  SnackBar(
                                                                    content: Text('Successfully sent.'),
                                                                  ),
                                                                );
                                                              } else {
                                                                ScaffoldMessenger.of(context).showSnackBar(
                                                                  SnackBar(
                                                                    content: Text('Failed to send. Please try again later.'),
                                                                  ),
                                                                );
                                                              }
                                                            } catch (error) {
                                                              print('Error: $error');
                                                              ScaffoldMessenger.of(context).showSnackBar(
                                                                SnackBar(
                                                                  content: Text('An error occurred. Please try again later.'),
                                                                ),
                                                              );
                                                            }
                                                          },
                                                          child: Text('OK'),
                                                        ),
                                                        TextButton(
                                                          onPressed: () {
                                                            Navigator.of(context).pop();
                                                          },
                                                          child: Text('CANCEL'),
                                                        ),
                                                      ],
                                                    );
                                                  },
                                                );
                                              },
                                              child: Image.asset(
                                                  'assets/send.png',
                                                  width: 40,
                                                  height: 40),
                                              style: ElevatedButton.styleFrom(
                                                shape: CircleBorder(),
                                                backgroundColor:
                                                    const Color.fromARGB(
                                                        255, 249, 251, 252),
                                                padding: EdgeInsets.all(16.0),
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            Text('Send'),
                                          ],
                                        ),
                                        Column(
                                          children: [
                                            ElevatedButton(
                                              onPressed: () {
                                                showDialog(
                                                  context: context,
                                                  builder: (BuildContext context) {
                                                    return AlertDialog(
                                                      title: Text('Remove Confirmation'),
                                                      content: Text('Are you sure you want to remove?'),
                                                      actions: [
                                                        TextButton(
                                                          onPressed: () {
                                                            Navigator.of(context).pop();
                                                            removeSupplier(widget.procId);
                                                          },
                                                          child: Text('OK'),
                                                        ),
                                                        TextButton(
                                                          onPressed: () {
                                                            Navigator.of(context).pop();
                                                          },
                                                          child: Text('CANCEL'),
                                                        ),
                                                      ],
                                                    );
                                                  },
                                                );
                                              },
                                              child: Image.asset(
                                                  'assets/cancel.png',
                                                  width: 40,
                                                  height: 40),
                                              style: ElevatedButton.styleFrom(
                                                shape: CircleBorder(),
                                                backgroundColor:
                                                    const Color.fromARGB(
                                                        255, 244, 244, 244),
                                                padding: EdgeInsets.all(16.0),
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            Text('Remove'),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                );
                              }
                            }
                          },
                        );
                      }
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MyInheritedWidget extends InheritedWidget {
  final _MyInheritedWidgetState data;

  _MyInheritedWidget({
    required this.data,
    required Widget child,
    Key? key,
  }) : super(key: key, child: child);

  static _MyInheritedWidgetState? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<_MyInheritedWidget>()?.data;
  }

  @override
  bool updateShouldNotify(_MyInheritedWidget oldWidget) {
    return true;
  }
}

class _MyInheritedWidgetState extends State<RequestTab> {
  void reloadPage() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
