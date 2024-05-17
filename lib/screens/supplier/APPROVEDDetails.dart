import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class APPROVEDDetails extends StatefulWidget {
  final String procId;
  final String purchaseReqId;

  const APPROVEDDetails({Key? key, required this.procId, required this.purchaseReqId}) : super(key: key);

  @override
  _SendedDetailsState createState() => _SendedDetailsState();
}

class _SendedDetailsState extends State<APPROVEDDetails> {
  List<dynamic> items = [];
  double discountPercentage = 0.0;
  double discountAmount = 0.0;
  double totalNetPrice = 0.0;
  String quotId = '';
  late DateTime selectedDeliveryDate;

  @override
  void initState() {
    super.initState();
    selectedDeliveryDate = DateTime.now();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      final response = await http.get(
        Uri.parse('http://192.168.1.142:3000/get_Quot_id?procId=${widget.procId}'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          quotId = data.isNotEmpty ? data[0][0] : '';
        });

        if (quotId.isNotEmpty) {
          await fetchQuotationDetails(quotId);
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
        Uri.parse('http://192.168.1.142:3000/QUOTATION_TABLE?quotId=$quotId'),
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

  Future<void> _selectDeliveryDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDeliveryDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 1),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: Colors.blue,
            buttonTheme: ButtonThemeData(
              textTheme: ButtonTextTheme.primary,
            ),
          ),
          child: child!,
        );
      },
    );
    if (pickedDate != null && pickedDate != selectedDeliveryDate) {
      setState(() {
        selectedDeliveryDate = pickedDate;
      });
    }
  }

  Future<void> _confirmDeliveryDate() async {
    if (selectedDeliveryDate != DateTime.now()) {
      try {
        final formattedDate = DateFormat('yyyy-MM-dd').format(selectedDeliveryDate);

        final response = await http.post(
          Uri.parse('http://192.168.1.142:3000/insertOrUpdateOrder'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode({
            'quot_id': quotId,
            'exp_delivery_date': formattedDate,
          }),
        );

        if (response.statusCode == 200) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Order updated successfully'),
              duration: Duration(seconds: 2),
            ),
          );
        } else {
          throw Exception('Failed to update order. Status Code: ${response.statusCode}');
        }
      } catch (error) {
        print('Error updating order: $error');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error updating order'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    } else {
      print('Selected delivery date is the current date');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
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
            Divider(thickness: 7),
            Container(
              padding: EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 200,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DataTable(
                        columnSpacing: 20,
                        dataRowHeight: 30,
                        columns: [
                          DataColumn(label: Text('Item Name', style: TextStyle(fontSize: 14))),
                          DataColumn(label: Text('Quantity', style: TextStyle(fontSize: 14))),
                          DataColumn(label: Text('Unit Price', style: TextStyle(fontSize: 14))),
                          DataColumn(label: Text('Net Unit Price', style: TextStyle(fontSize: 14))),
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
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ),
                  SizedBox(height: 20),
                  Divider(thickness: 7),
                  SizedBox(height: 40),
                  Text(
                    'Select Delivery Date',
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                  GestureDetector(
                    onTap: () => _selectDeliveryDate(context),
                    child: InputDecorator(
                      decoration: InputDecoration(
                        labelText: 'Expected Delivery Date',
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${selectedDeliveryDate.day} ${_getMonthName(selectedDeliveryDate.month)} ${selectedDeliveryDate.year}, ${_getDayOfWeek(selectedDeliveryDate.weekday)} (${selectedDeliveryDate.day}/${selectedDeliveryDate.month}/${selectedDeliveryDate.year})',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Center(
                    child: ElevatedButton(
                      onPressed: _confirmDeliveryDate,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        textStyle: TextStyle(fontSize: 18),
                        padding: EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                      ),
                      child: Text(
                        'Confirm Delivery Date',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
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

  String _getDayOfWeek(int day) {
    switch (day) {
      case 1:
        return 'Sunday';
      case 2:
        return 'Monday';
      case 3:
        return 'Tuesday';
      case 4:
        return 'Wednesday';
      case 5:
        return 'Thursday';
      case 6:
        return 'Friday';
      case 7:
        return 'Saturday';
      default:
        return '';
    }
  }
}
