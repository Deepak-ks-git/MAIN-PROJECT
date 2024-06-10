import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';

class PurchaseItems extends StatefulWidget {
  final String procId;

  PurchaseItems({required this.procId});

  @override
  _PurchaseItemsState createState() => _PurchaseItemsState();
}

class _PurchaseItemsState extends State<PurchaseItems> {
  List<Map<String, dynamic>> procurementDetails = [];
  List<Map<String, dynamic>> procureItemDetails = [];
  Map<String, dynamic> companyDetails = {};

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
      fetchCompanyDetails(widget.procId);
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

  Future<void> fetchCompanyDetails(String procId) async {
    final response = await http.get(Uri.parse(
        'http://192.168.1.143:3000/COMP_DETAILS_FOR_REQUEST_DETAIL?procId=$procId'));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      if (data.isNotEmpty) {
        setState(() {
          companyDetails = {
            'companyId': data[0][0],
            'companyName': data[0][1],
            'mailId': data[0][2],
            'phNo': data[0][3],
          };
        });
      }
    }
  }

  Future<void> acceptRequest() async {
    try {
      final response = await http.post(
        Uri.parse('http://192.168.1.143:3000/ACCEPT_REQUEST'),
        body: json.encode({'procId': widget.procId}),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        print('Purchase request accepted');
        // Update UI if needed
      } else {
        throw Exception('Failed to accept purchase request');
      }
    } catch (error) {
      print('Error accepting purchase request: $error');
    }
  }

  Future<void> rejectRequest() async {
    try {
      final response = await http.post(
        Uri.parse('http://192.168.1.143:3000/REJECT_REQUEST'),
        body: json.encode({'procId': widget.procId}),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        print('Purchase request rejected');
        // Update UI if needed
      } else {
        throw Exception('Failed to reject purchase request');
      }
    } catch (error) {
      print('Error rejecting purchase request: $error');
    }
  }

  Future<void> showConfirmationDialog(String action) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm $action'),
          content: Text('Are you sure you want to $action this request?'),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Yes'),
              onPressed: () {
                Navigator.of(context).pop();
                if (action == 'accept') {
                  acceptRequest();
                } else {
                  rejectRequest();
                }
              },
            ),
          ],
        );
      },
    );
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
    final response = await http.get(Uri.parse(
        'http://192.168.1.143:3000/api/generate-procurement-pdf/$procId'));
    if (response.statusCode == 200) {
      final directory = await getExternalStorageDirectory();
      final filePath = '${directory!.path}/procurement_$procId.pdf';
      File(filePath).writeAsBytesSync(response.bodyBytes);
      OpenFile.open(filePath);
    } else {
      print('Failed to download PDF: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
       Color myColor = Color(0xFF1E2736);

    return Scaffold(
      appBar: AppBar(
        title: Text('Purchase Items',
            style: TextStyle(color: Colors.white, fontSize: 18)),
        backgroundColor: myColor,
        iconTheme: IconThemeData(color: Colors.white),
      ),
   
      body: Stack(
        children: [
          Container(
            color: Colors.grey[100],
            child: ListView(
              padding: EdgeInsets.all(10),
              children: [
                Container(
                  margin: EdgeInsets.only(bottom: 10),
                  padding: EdgeInsets.all(10),
                  
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(10),
                    color: const Color.fromARGB(255, 255, 255, 255),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            '${procurementDetails.isNotEmpty ? procurementDetails[0]['description'] : ''}',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                         
                        ],
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Proc ID: ${procurementDetails.isNotEmpty ? procurementDetails[0]['procId'] : ''}',
                        style: TextStyle(fontSize: 12),
                      ),
                      Text(
                        'Date Created: ${formatDate(procurementDetails.isNotEmpty ? procurementDetails[0]['dateCreated'] : '')}',
                        style: TextStyle(fontSize: 12),
                      ),
                      // Company Details
                      SizedBox(height: 15),
                      if (companyDetails.isNotEmpty) ...[
                        Row(
                          children: [
                            Text( '${companyDetails['companyName']}',style: TextStyle(fontSize: 16,fontWeight: FontWeight.w600),),
                          ],
                        ),
                        SizedBox(height: 5,),
                       
                        Row(
                          children: [
                            Icon(Icons.mail_outlined,size: 16,),
                            Text(
                              '   ${companyDetails['mailId']}',
                              style: TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Icon(Icons.call,size: 16,),
                            Text(
                              '   ${companyDetails['phNo']}',
                              style: TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                      ],
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.shopping_cart_outlined),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          'Item Details',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10,),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: procureItemDetails.map((detail) {
                        return Container(
                          margin: EdgeInsets.symmetric(
                            vertical: 5,
                          ),
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.white,
                            border: Border.all(color: Colors.grey),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  '${detail['itemName']}',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                              SizedBox(width: 10),
                              Text(
                                'QTY: ${detail['quantity']}',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Color.fromARGB(255, 2, 40, 82),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
                SizedBox(height: 20,),
                // Accept and Reject Buttons
                     Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                    onTap: () => showConfirmationDialog('accept'),
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      decoration: BoxDecoration(
                        color: Colors.green.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.green),
                      ),
                      child: Column(
                        children: [
                          Icon(Icons.check, color: Colors.green, size: 30),
                          SizedBox(height: 5),
                          Text(
                            'Accept',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => showConfirmationDialog('reject'),
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      decoration: BoxDecoration(
                        color: Colors.red.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.red),
                      ),
                      child: Column(
                        children: [
                          Icon(Icons.close, color: Colors.red, size: 30),
                          SizedBox(height: 5),
                          Text(
                            'Reject',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.red,
                            ),
                          ),
                        ],
                      ),
                    ),
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
              backgroundColor: Color(0xFF1E2736),
              child: Icon(Icons.picture_as_pdf_outlined, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: PurchaseItems(procId: 'YourProcurementId'),
  ));
}
