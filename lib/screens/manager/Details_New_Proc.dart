import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';

class Details_New_Procurment extends StatefulWidget {
  final String procId;

  Details_New_Procurment({required this.procId});

  @override
  _ProcurementDetailsPageState createState() => _ProcurementDetailsPageState();
}

class _ProcurementDetailsPageState extends State<Details_New_Procurment> {
  List<Map<String, dynamic>> procurementDetails = [];
  List<Map<String, dynamic>> procureItemDetails = [];

  @override
  void initState() {
    super.initState();
    fetchProcurements();
  }

  Future<void> fetchProcurements() async {
    final response = await http.get(
        Uri.parse('http://192.168.1.143:3000/getProc?procId=${widget.procId}'));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      setState(() {
        procurementDetails = data
            .map((dynamic item) => {
          'procId': item[0],
          'description': item[1],
          'status': item[2],
          'dateCreated': item[3],
        })
            .toList();
      });
      fetchProcurementDetails(widget.procId);
    }
  }

  Future<void> fetchProcurementDetails(String procId) async {
    final response = await http.get(Uri.parse(
        'http://192.168.1.143:3000/ProcureItemDetails?procId=$procId'));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      setState(() {
        procureItemDetails = data
            .map<Map<String, dynamic>>((dynamic item) => {
          'itemId': item[0].toString(),
          'quantity': item[1] as int,
          'itemName': item[2].toString(),
        })
            .toList();
      });
    }
  }

  Color getStatusColor(String status) {
    switch (status.toUpperCase()) {
      case 'CREATED':
        return Color.fromARGB(255, 59, 65, 255);
      case 'STARTED':
        return Colors.orange;
      case 'COMPLETED':
        return Colors.green;
      case 'PENDING':
        return Colors.red;
      case 'CANCELLED':
        return Colors.black;
      default:
        return Colors.grey;
    }
  }

  String formatDate(String date) {
    try {
      return DateFormat.yMMMMd().format(DateTime.parse(date));
    } catch (e) {
      return 'Invalid Date';
    }
  }

  Future<void> downloadPDF(String procId) async {
    // Make API call to download PDF
    final response = await http.get(Uri.parse(
        'http://192.168.1.143:3000/api/generate-procurement-pdf/$procId'));

    // Check if the response is successful
    if (response.statusCode == 200) {
      // Get the directory for storing files
      final directory = await getExternalStorageDirectory();
      final filePath = '${directory!.path}/procurement_$procId.pdf';

      // Write the PDF bytes to file
      File(filePath).writeAsBytesSync(response.bodyBytes);

      // Open the downloaded PDF file
      OpenFile.open(filePath);
    } else {
      // Handle error
      print('Failed to download PDF: ${response.statusCode}');
    }
  }

@override
Widget build(BuildContext context) {
          Color myColor = Color(0xFF1E2736);

  return Scaffold(
    body: Stack(
      children: [
        Container(
          color: Colors.grey[100],
          child: ListView(
            padding: EdgeInsets.all(10),
            children: [
              const SizedBox(height: 30),
              Container(
                margin: EdgeInsets.only(bottom: 10),
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                            '${procurementDetails.isNotEmpty ? procurementDetails[0]['description'] : ''}',
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.w600)),
                        Spacer(),
                        Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                          decoration: BoxDecoration(
                              color: getStatusColor(procurementDetails.isNotEmpty
                                  ? procurementDetails[0]['status']
                                  : ''),
                              borderRadius: BorderRadius.circular(5)),
                          child: Text(
                              ' ${procurementDetails.isNotEmpty ? procurementDetails[0]['status'] : ''}',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12)),
                        ),
                      ],
                    ),
                    SizedBox(height: 4),
                    Text(
                        'Proc ID : ${procurementDetails.isNotEmpty ? procurementDetails[0]['procId'] : ''}',
                        style: TextStyle(fontSize: 12)),
                    Text(
                        'Date Created: ${formatDate(procurementDetails.isNotEmpty ? procurementDetails[0]['dateCreated'] : '')}',
                        style: TextStyle(fontSize: 12)),
                  ],
                ),
              ),
              SizedBox(height: 5),
              Divider(
                thickness: 1,
              ),
              SizedBox(
                height: 5,
              ),
              Column(
                children: [
                  Row(
                    children: [
                      Icon(Icons.shopping_cart_outlined),
                      SizedBox(
                        width: 5,
                      ),
                      Text('Item Details',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: procureItemDetails.length,
                    itemBuilder: (context, index) {
                      final detail = procureItemDetails[index];
                      return Container(
                        margin: EdgeInsets.symmetric(horizontal: 5, vertical: 3),
                        padding: EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.white,
                          border: Border.all(color: Colors.grey),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text('${detail['itemName']}',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold, fontSize: 14)),
                                Spacer(),
                                Text('QTY : '),
                                Text('${detail['quantity']}',
                                    style: TextStyle(fontSize: 14,color: Color.fromARGB(255, 2, 40, 82),fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
        Positioned(
          bottom: 20,
          right: 20,
          child: FloatingActionButton(
            onPressed: () => downloadPDF(widget.procId),
            backgroundColor:myColor, // Set your desired color here
            child: Icon(Icons.picture_as_pdf_outlined, color: Colors.white), // Set icon color to white
          ),
        ),
      ],
    ),
  );
}
void main() {
  runApp(MaterialApp(
    home: Details_New_Procurment(procId: 'YourProcurementId'),
  ));
}}
