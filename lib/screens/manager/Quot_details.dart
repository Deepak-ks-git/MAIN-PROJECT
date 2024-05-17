import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Quot_details extends StatefulWidget {
  final String procId;
  final String purchaseReqId;

  const Quot_details(
      {Key? key, required this.procId, required this.purchaseReqId})
      : super(key: key);

  @override
  _UnQuot_detailsState createState() => _UnQuot_detailsState();
}

class _UnQuot_detailsState extends State<Quot_details> {
  List<dynamic> items = [];
  double discountPercentage = 0.0;
  double discountAmount = 0.0;
  double totalNetPrice = 0.0;
  String quotId = '';

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      final response = await http.get(
        Uri.parse(
            'http://192.168.1.142:3000/get_Quot_id?procId=${widget.procId}'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          quotId = data.isNotEmpty ? data[0][0] : '';
          print('Quotation ID retrieved successfully: $quotId');
        });

        if (quotId.isNotEmpty) {
          await fetchQuotationDetails(quotId);
        }
      } else {
        throw Exception(
            'Failed to load quotation ID. Status Code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error fetching quotation ID: $error');
    }
  }

  Future<void> fetchQuotationDetails(String quotId) async {
    try {
      final response = await http.get(
        Uri.parse('http://192.168.1.142:3000/QUOTATION_TABLE?quotId=$quotId'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          items = data;
          if (items.isNotEmpty) {
            calculateDiscount((items[0][5] as num).toDouble(),
                (items[0][7] as num).toDouble());
            calculateTotalNetPrice();
          }
        });
      } else {
        throw Exception(
            'Failed to load quotation details. Status Code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error fetching quotation details: $error');
    }
  }

  void calculateDiscount(double discountAmount, double totalNetPrice) {
    setState(() {
      discountPercentage = (discountAmount / totalNetPrice) * 100;
      this.discountAmount = discountAmount;
      this.totalNetPrice = totalNetPrice;
    });
  }

  double calculateTotalNetUnitPrice() {
    double total = 0.0;
    for (var item in items) {
      total += (item[6] as num)
          .toDouble(); // Index 6 corresponds to the net unit price
    }
    return total;
  }

  void calculateTotalNetPrice() {
    double totalUnitPrice = calculateTotalNetUnitPrice();
    setState(() {
      totalNetPrice = totalUnitPrice - discountAmount;
    });
  }

Future<void> acceptquotation() async {
  try {
    final response = await http.post(
      Uri.parse('http://192.168.1.142:3000/Approve_Quot'),
      body: json.encode({'quotId': quotId}),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      // Quotation status updated successfully
      print('Quotation status updated successfully');
      // You can update UI accordingly if needed
    } else {
      throw Exception('Failed to update quotation status');
    }
  } catch (error) {
    print('Error updating quotation status: $error');
  }
}


Future<void> rejectquotation() async {
  try {
    final response = await http.post(
      Uri.parse('http://192.168.1.142:3000/Reject_Quot'),
      body: json.encode({'quotId': quotId}),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      // Quotation rejection successful
      print('Quotation rejected successfully');
      // You can update UI accordingly if needed
    } else {
      throw Exception('Failed to reject quotation');
    }
  } catch (error) {
    print('Error rejecting quotation: $error');
  }
}

  Future<void> showConfirmationDialog(String action) async {
    bool? result = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmation'),
          content: Text('Are you sure you want to $action this quotation?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true); // User confirmed
              },
              child: Text('Yes'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false); // User cancelled
              },
              child: Text('No'),
            ),
          ],
        );
      },
    );

    if (result != null && result) {
      if (action == 'accept') {
        acceptquotation();
      } else if (action == 'reject') {
        rejectquotation();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
    
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 40),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Text(
                  'QUOTATION',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            SizedBox(height: 10),
            Divider(thickness: 6),
            Container(
              padding: EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 200, // Set a fixed height for the DataTable
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DataTable(
                        columnSpacing: 20,
                        dataRowHeight: 30, // Set the height of each DataRow
                        columns: [
                          DataColumn(
                            label: Text('Item Name',
                                style: TextStyle(fontSize: 14)),
                          ),
                          DataColumn(
                            label: Text('Quantity',
                                style: TextStyle(fontSize: 14)),
                          ),
                          DataColumn(
                            label: Text('Unit Price',
                                style: TextStyle(fontSize: 14)),
                          ),
                          DataColumn(
                            label: Text('Net Unit Price',
                                style: TextStyle(fontSize: 14)),
                          ),
                        ],
                        rows: items.map<DataRow>((item) {
                          return DataRow(
                            cells: [
                              DataCell(Text('${item[1]}',
                                  style: TextStyle(fontSize: 14))),
                              DataCell(Text('${item[2]}',
                                  style: TextStyle(fontSize: 14))),
                              DataCell(Text('${item[3]}',
                                  style: TextStyle(fontSize: 14))),
                              DataCell(Text('${item[6]}',
                                  style: TextStyle(fontSize: 14))),
                            ],
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                  Divider(thickness: 1),
                  if (items.isNotEmpty)
                    Row(
                      children: [
                        SizedBox(width: 150),
                        Text(
                          'Total Net Unit Price: ${calculateTotalNetUnitPrice().toStringAsFixed(2)}',
                          style: TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                  Divider(thickness: 1),
                  SizedBox(height: 20),
                  if (items.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Discount Percentage: ${discountPercentage.toStringAsFixed(2)}%',
                            style: TextStyle(fontSize: 16),
                          ),
                          SizedBox(height: 10),
                          Text(
                            'Discount Amount: ${discountAmount.toStringAsFixed(2)}',
                            style: TextStyle(fontSize: 16),
                          ),
                          SizedBox(height: 10),
                          Text(
                            'Total Net Price: ${totalNetPrice.toStringAsFixed(2)}',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ),
                  SizedBox(height: 30),
                  Divider(thickness: 6),
                  SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        children: [
                          IconButton(
                            onPressed: () {
                              showConfirmationDialog('accept');
                            },
                            icon: Image.asset('assets/accept.gif'),
                            tooltip: 'Accept',
                          ),
                          Text('Accept quotation'),
                        ],
                      ),
                      Column(
                        children: [
                          IconButton(
                            onPressed: () {
                              showConfirmationDialog('reject');
                            },
                            icon: Image.asset(
                              'assets/reject.png',
                              height: 65,
                              width: 65,
                            ),
                            tooltip: 'Reject',
                          ),
                          Text('Reject quotation'),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
