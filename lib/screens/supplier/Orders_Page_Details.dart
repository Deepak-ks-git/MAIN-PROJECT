import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Orders_Page_Details extends StatefulWidget {
  final String procId;
  final String purchaseReqId;

  const Orders_Page_Details({Key? key, required this.procId, required this.purchaseReqId})
      : super(key: key);

  @override
  _Orders_Page_DetailsState createState() => _Orders_Page_DetailsState();
}

class _Orders_Page_DetailsState extends State<Orders_Page_Details> {
  List<dynamic> items = [];
  double discountPercentage = 0.0;
  double discountAmount = 0.0;
  double totalNetPrice = 0.0;
  String quotId = '';
  String deliveryDate = ''; // Delivery date fetched from orders table

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      final response = await http.get(
        Uri.parse('http://192.168.1.143:3000/get_Quot_id?procId=${widget.procId}'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          quotId = data.isNotEmpty ? data[0][0] : '';
        });

        if (quotId.isNotEmpty) {
          await fetchQuotationDetails(quotId);
          await fetchDeliveryDate(quotId);
        }
      } else {
        throw Exception('Failed to load quotation ID. Status Code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error fetching quotation ID: $error');
    }
  }

  Future<void> fetchQuotationDetails(String quotId) async {
    try {
      final response = await http.get(
        Uri.parse('http://192.168.1.143:3000/QUOTATION_TABLE?quotId=$quotId'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          items = data;
          if (items.isNotEmpty) {
            calculateDiscount((items[0][5] as num).toDouble(), (items[0][7] as num).toDouble());
            calculateTotalNetPrice();
          }
        });
      } else {
        throw Exception('Failed to load quotation details. Status Code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error fetching quotation details: $error');
    }
  }

  Future<void> fetchDeliveryDate(String quotId) async {
    try {
      final response = await http.get(
        Uri.parse('http://192.168.1.143:3000/getDeliveryDate?quotId=$quotId'), // API endpoint for fetching delivery date
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        setState(() {
          deliveryDate = data['deliveryDate'] ?? ''; // Extract deliveryDate from API response
        });
      } else {
        throw Exception('Failed to load delivery date. Status Code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error fetching delivery date: $error');
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
      total += (item[6] as num).toDouble(); // Index 6 corresponds to the net unit price
    }
    return total;
  }

  void calculateTotalNetPrice() {
    double totalUnitPrice = calculateTotalNetUnitPrice();
    setState(() {
      totalNetPrice = totalUnitPrice - discountAmount;
    });
  }

  String _formatDeliveryDate(String date) {
    DateTime parsedDate = DateTime.parse(date);
    String formattedDay = '${parsedDate.day}${_getOrdinalSuffix(parsedDate.day)}';
    String formattedMonth = _getMonthName(parsedDate.month);
    String formattedYear = parsedDate.year.toString();
    String formattedDate = '$formattedDay $formattedMonth $formattedYear (${parsedDate.day}/${parsedDate.month}/${parsedDate.year})';
    return formattedDate;
  }

  String _getOrdinalSuffix(int day) {
    if (day % 100 >= 11 && day % 100 <= 13) {
      return 'th';
    }
    switch (day % 10) {
      case 1:
        return 'st';
      case 2:
        return 'nd';
      case 3:
        return 'rd';
      default:
        return 'th';
    }
  }

  String _getMonthName(int month) {
    switch (month) {
      case 1:
        return 'January';
      case 2:
        return 'February';
      case 3:
        return 'March';
      case 4:
        return 'April';
      case 5:
        return 'May';
      case 6:
        return 'June';
      case 7:
        return 'July';
      case 8:
        return 'August';
      case 9:
        return 'September';
      case 10:
        return 'October';
      case 11:
        return 'November';
      case 12:
        return 'December';
      default:
        return '';
    }
  }

  void startDelivery(String quotId) async {
    // Call your API here passing the quotId
    try {
      final response = await http.post(
        Uri.parse('http://192.168.1.143:3000/startDelivery'),
        body: {'quot_id': quotId},
      );

      if (response.statusCode == 200) {
        // Handle success
        print('Quotation processed successfully');
        // Optionally show a message or navigate to a new screen
      } else {
        // Handle error
        print('Failed to process quotation');
      }
    } catch (error) {
      print('Error processing quotation: $error');
      // Handle error
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Order Details'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            Center(
              child: Text(
                'QUOTATION',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
                            label: Text('Item Name', style: TextStyle(fontSize: 14)),
                          ),
                          DataColumn(
                            label: Text('Quantity', style: TextStyle(fontSize: 14)),
                          ),
                          DataColumn(
                            label: Text('Unit Price', style: TextStyle(fontSize: 14)),
                          ),
                          DataColumn(
                            label: Text('Net Unit Price', style: TextStyle(fontSize: 14)),
                          ),
                        ],
                        rows: items.map<DataRow>((item) {
                          return DataRow(
                            cells: [
                              DataCell(Text('${item[1]}', style: TextStyle(fontSize: 14))),
                              DataCell(Text('${item[2]}', style: TextStyle(fontSize: 14))),
                              DataCell(Text('${item[3]}', style: TextStyle(fontSize: 14))),
                              DataCell(Text('${item[6]}', style: TextStyle(fontSize: 14))),
                            ],
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                  Divider(thickness: 1),
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
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ),
                  SizedBox(height: 30),
                  Divider(thickness: 6),
                  SizedBox(height: 30),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Delivery Date: ${deliveryDate.isNotEmpty ? _formatDeliveryDate(deliveryDate) : "Date to be selected by supplier"}',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),
                        SizedBox(height: 20),
                        Center(
                          child: ElevatedButton(
                            onPressed: () {
                              startDelivery(quotId);
                            },
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white, backgroundColor: Colors.black,
                              minimumSize: Size(150, 40),
                            ),
                            child: Text('START DELIVERY'),
                          ),
                        ),
                      ],
                    ),
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
