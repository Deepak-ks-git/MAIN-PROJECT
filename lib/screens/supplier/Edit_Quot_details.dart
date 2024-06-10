import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Edit_Quot_details extends StatefulWidget {
  final String procId;
  final String purchaseReqId; // Add purchaseReqId parameter

  const Edit_Quot_details({Key? key, required this.procId, required this.purchaseReqId}) : super(key: key);

  @override
  _EditQuotDetailsState createState() => _EditQuotDetailsState();
}

class _EditQuotDetailsState extends State<Edit_Quot_details> {
  List<dynamic> items = [];
  List<TextEditingController> unitPriceControllers = [];
  List<double> netUnitPrices = [];
  double totalNetUnitPrice = 0.0;
  TextEditingController discountController = TextEditingController();
  double discountAmount = 0.0;
  double discountedPrice = 0.0;
  String quotId = '';

  @override
  void initState() {
    super.initState();
    fetchQuotationId(); // Fetch quotation ID when the widget is initialized
    fetchEditQuotDetails();
  }

Future<void> fetchQuotationId() async {
  try {
    final response = await http.get(Uri.parse(
        'http://192.168.1.143:3000/get_Quot_id?procId=${widget.procId}'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      setState(() {
        quotId = data.isNotEmpty ? data[0][0] : '';
        print('Quotation ID retrieved successfully: $quotId'); // Print the retrieved quotation ID
      });
    } else {
      throw Exception('Failed to load quotation ID');
    }
  } catch (error) {
    print('Error fetching quotation ID: $error');
  }
}


  Future<void> fetchEditQuotDetails() async {
    try {
      final response = await http.get(Uri.parse(
          'http://192.168.1.143:3000/Item_Reqeust_details?procId=${widget.procId}'));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          items = data;
          unitPriceControllers = List.generate(
            items.length,
            (index) => TextEditingController(),
          );
          netUnitPrices = List.generate(items.length, (index) => 0.0);
        });
      } else {
        throw Exception('Failed to load purchase items');
      }
    } catch (error) {
      print('Error fetching purchase items: $error');
    }
  }

  double calculateNetUnitPrice(int index) {
    double unitPrice = double.tryParse(unitPriceControllers[index].text) ?? 0.0;
    int quantity = items[index][4] as int;
    return unitPrice * quantity;
  }

  void updateTotalNetUnitPrice() {
    double total = 0.0;
    for (int i = 0; i < items.length; i++) {
      total += netUnitPrices[i];
    }
    setState(() {
      totalNetUnitPrice = total;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'ITEMS',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            Divider(thickness: 1),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: _buildGridRows(),
              ),
            ),
            Divider(thickness: 1),
            ElevatedButton(
              onPressed: () {
                // Add functionality for downloading PDF
              },
              child: Text('Download PDF', style: TextStyle(fontSize: 14)),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            SizedBox(height: 10),
            Divider(thickness: 1),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Text(
                  'QUOTATION',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DataTable(
                    columnSpacing: 20,
                    columns: [
                      DataColumn(label: Text('Item')),
                      DataColumn(label: Text('Qty')),
                      DataColumn(label: Text('Unit Price')),
                      DataColumn(label: Text('Net Unit Price')),
                    ],
                    rows: List<DataRow>.generate(
                      items.length,
                      (index) => DataRow(
                        cells: [
                          DataCell(Text('${items[index][1]}')),
                          DataCell(Text('${items[index][4]}')),
                          DataCell(
                            SizedBox(
                              width: 80,
                              child: TextFormField(
                                controller: unitPriceControllers[index],
                                keyboardType: TextInputType.number,
                              ),
                            ),
                          ),
                          DataCell(
                            Text(
                              '${netUnitPrices[index].toStringAsFixed(2)}',
                              style: TextStyle(fontSize: 12),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Divider(thickness: 3),
                  Row(
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Future.delayed(Duration.zero, () {
                            setState(() {
                              for (int i = 0; i < items.length; i++) {
                                netUnitPrices[i] = calculateNetUnitPrice(i);
                              }
                              updateTotalNetUnitPrice();
                            });
                          });
                        },
                        child: Text('Calculate'),
                      ),
                      SizedBox(width: 80),
                      Text(
                        'Total Price:    ${totalNetUnitPrice.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                  Divider(thickness: 1),
                  SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      children: [
                        Text(
                          'Discount',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        SizedBox(
                          height: 40,
                          width: 60,
                          child: TextFormField(
                            controller: discountController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              labelText: '%',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                        SizedBox(width: 10),
                        ElevatedButton(
                          onPressed: () {
                            calculateDiscount();
                          },
                          child: Text('Calculate Discount'),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16.0, 0, 16.0, 0),
                    child: Row(
                      children: [
                        Text(
                          'Discount Amount: ',
                          style: TextStyle(fontSize: 16),
                        ),
                        SizedBox(width: 10),
                        Text(
                          '${discountAmount.toStringAsFixed(2)}',
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16.0, 0, 16.0, 8.0),
                    child: Row(
                      children: [
                        Text(
                          'Discounted Price: ',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(width: 10),
                        Text(
                          '${discountedPrice.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Divider(thickness: 1),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          updateQuotationDetail();
        },
        child: Icon(Icons.update),
      ),
    );
  }

  List<Widget> _buildGridRows() {
    List<Widget> rows = [];
    for (var item in items) {
      rows.add(_buildGridRow(item));
    }
    return rows;
  }

  Widget _buildGridRow(item) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 5),
      child: Card(
        shape: RoundedRectangleBorder(
          side: BorderSide(color: Colors.grey),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('${item[1]}',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
              Text('Color: ${item[2]}'),
              Text('Dimensions: ${item[3]}'),
              const SizedBox(
                height: 10,
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  padding: EdgeInsets.all(5),
                  color: const Color.fromARGB(255, 4, 5, 6),
                  child: Text(
                    'Quantity: ${item[4]}',
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.white),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void calculateDiscount() {
    double discountPercentage = double.tryParse(discountController.text) ?? 0.0;
    discountAmount = totalNetUnitPrice * (discountPercentage / 100);
    discountedPrice = totalNetUnitPrice - discountAmount;
    setState(() {});
  }

  void updateQuotationDetail() async {
    List<Map<String, dynamic>> requestBody = [];
  
    // Calculate discount amount
    double discountPercentage = double.tryParse(discountController.text) ?? 0.0;
    discountAmount = totalNetUnitPrice * (discountPercentage / 100);

    // Calculate discounted price
    discountedPrice = totalNetUnitPrice - discountAmount;

    for (int i = 0; i < items.length; i++) {
      double unitPrice = double.tryParse(unitPriceControllers[i].text) ?? 0.0;
      double netUnitPrice = unitPrice * items[i][4]; // Calculate net unit price

      requestBody.add({
        'item_id': items[i][0],
        'qty': items[i][4],
        'unit_price': unitPrice,
        'discount_percentage': discountPercentage,
        'discount_price': discountAmount,
        'net_unit_price': netUnitPrice,
        'net_price': discountedPrice, // Use the discounted price for net price
        'quot_id': quotId // Use quotId fetched earlier
      });
    }

    // Print the request payload
    print('Request Payload: $requestBody');

    try {
      final response = await http.post(
        Uri.parse('http://192.168.1.143:3000/update_quotation_detail'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Quotation details updated successfully')),
        );
        await Future.delayed(Duration(seconds: 2));

        Navigator.of(context).pop();
        

      } else {
        throw Exception('Failed to update quotation details');
      }
    } catch (error) {
      print('Error updating quotation details: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update quotation details')),
      );
    }
  }
}
