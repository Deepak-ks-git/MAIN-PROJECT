import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class UnsendedDetails extends StatefulWidget {
  final String procId;
  final String purchaseReqId;

  const UnsendedDetails(
      {Key? key, required this.procId, required this.purchaseReqId})
      : super(key: key);

  @override
  _UnsendedDetailsState createState() => _UnsendedDetailsState();
}

class _UnsendedDetailsState extends State<UnsendedDetails> {
  List<dynamic> items = [];
  TextEditingController discountController = TextEditingController();
  double discountPercentage = 0.0;
  double discountAmount = 0.0;
  double totalNetPrice = 0.0;
  String quotId = '';

  @override
  void initState() {
    super.initState();
    fetchQuotationId();
  }

  Future<void> fetchQuotationId() async {
    try {
      final response = await http.get(Uri.parse(
          'http://192.168.0.102:3000/get_Quot_id?procId=${widget.procId}'));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          quotId = data.isNotEmpty ? data[0][0] : '';
          print('Quotation ID retrieved successfully: $quotId');
          if (quotId.isNotEmpty) {
            fetchEditQuotDetails(quotId);
          }
        });
      } else {
        throw Exception('Failed to load quotation ID');
      }
    } catch (error) {
      print('Error fetching quotation ID: $error');
    }
  }

  Future<void> fetchEditQuotDetails(String quotId) async {
    try {
      final response = await http.get(Uri.parse(
          'http://192.168.0.102:3000/QUOTATION_TABLE?quotId=$quotId'));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          items = data;
          if (items.isNotEmpty) {
            calculateDiscount(items[0][5], items[0][7]);
            calculateTotalNetPrice();
          }
        });
      } else {
        throw Exception('Failed to load quotation details');
      }
    } catch (error) {
      print('Error fetching quotation details: $error');
    }
  }

  void calculateDiscount(double discountAmount, double totalNetPrice) {
    setState(() {
      discountPercentage = discountAmount / totalNetPrice * 100;
      this.discountAmount = discountAmount;
      this.totalNetPrice = totalNetPrice;
    });
  }

  double calculateTotalNetUnitPrice() {
    double total = 0.0;
    for (var item in items) {
      total += item[6]; // Index 6 corresponds to the net unit price
    }
    return total;
  }

void calculateTotalNetPrice() {
  double totalUnitPrice = calculateTotalNetUnitPrice();
  setState(() {
    totalNetPrice = totalUnitPrice - discountAmount;
  });
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
                                  style: TextStyle(fontSize: 14))),
                          DataColumn(
                              label: Text('Quantity',
                                  style: TextStyle(fontSize: 14))),
                          DataColumn(
                              label: Text('Unit Price',
                                  style: TextStyle(fontSize: 14))),
                          DataColumn(
                              label: Text('Net Unit Price',
                                  style: TextStyle(fontSize: 14))),
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
                        SizedBox(width: 150,),
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
                            style: TextStyle(fontSize: 16,fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ),
                  SizedBox(height: 10),
                  
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

