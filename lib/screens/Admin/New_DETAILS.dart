import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';

class New_DETAILS extends StatefulWidget {
  final String procId;

  New_DETAILS({required this.procId});

  @override
  _ProcurementDetailsPageState createState() => _ProcurementDetailsPageState();
}

class _ProcurementDetailsPageState extends State<New_DETAILS> {
  List<Map<String, dynamic>> procurementDetails = [];
  List<Map<String, dynamic>> procureItemDetails = [];
  List<Map<String, dynamic>> purchaseRequestDetails = [];
  Map<String, dynamic> supplierDetails = {};
  String purchaseRequestStatus = '';

  @override
  void initState() {
    super.initState();
    fetchProcurements();
    fetchPurchaseRequestStatus();
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
      fetchPurchaseRequestDetails(widget.procId);
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

  Future<void> fetchPurchaseRequestDetails(String procId) async {
    final response = await http.get(Uri.parse(
        'http://192.168.1.143:3000/reqdetails_for_sending?procId=$procId'));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      setState(() {
        purchaseRequestDetails = data
            .map<Map<String, dynamic>>((dynamic item) => {
                  'purchaseReqId': item[0],
                  'supplierId': item[1],
                })
            .toList();
      });
      if (purchaseRequestDetails.isNotEmpty) {
        fetchAndDisplaySupplierDetails(purchaseRequestDetails[0]['supplierId']);
      }
    }
  }

  Future<void> fetchAndDisplaySupplierDetails(String supplierId) async {
    final response = await http.get(
      Uri.parse(
          'http://192.168.1.143:3000/supplier_details_for_sending?supplierId=$supplierId'),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      if (data.isNotEmpty && data[0].length >= 6) {
        setState(() {
          supplierDetails = {
            'firstName': data[0][0],
            'lastName': data[0][1],
            'companyName': data[0][2],
            'email': data[0][3],
            'phone': data[0][4].toString(),
            'alternateNumber': data[0][5].toString(),
          };
        });
      } else {
        // Handle empty or incomplete data
        print('Supplier details not found or incomplete');
      }
    } else {
      // Handle HTTP error
      print('Failed to fetch supplier details: ${response.statusCode}');
    }
  }

  Future<void> fetchPurchaseRequestStatus() async {
    final response = await http.get(
        Uri.parse('http://192.168.1.143:3000/purchase_request_status?procId=${widget.procId}'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      setState(() {
        purchaseRequestStatus = data['status'];
      });
    } else {
      // Handle error
      print('Failed to fetch purchase request status: ${response.statusCode}');
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

  Future<void> cancelPurchaseRequest() async {
    try {
      final response = await http.post(
        Uri.parse('http://192.168.1.143:3000/cancel_request'),
        body: {'procId': widget.procId},
      );
      if (response.statusCode == 200) {
        // Handle success
        final Map<String, dynamic> responseData = json.decode(response.body);
        print(responseData['message']);
        // Refresh data after cancellation if needed
        fetchProcurements();
      } else {
        // Handle error
        print('Failed to cancel request: ${response.statusCode}');
      }
    } catch (error) {
      // Handle error
      print('Error while canceling request: $error');
    }
  }

  Future<void> showConfirmationDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Cancellation'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Are you sure you want to cancel this purchase request?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Confirm'),
              onPressed: () {
                // Call API to cancel purchase request
                cancelPurchaseRequest();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> downloadPDF(String procId) async {
  // Make API call to download PDF
  final response = await http.get(Uri.parse('http://192.168.1.143:3000/api/generate-procurement-pdf/$procId'));

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
    return Scaffold(
      body: ListView(
        padding: EdgeInsets.all(15),
        children: [
          const SizedBox(height: 10),
          Container(
            margin: EdgeInsets.only(bottom: 10),
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: Offset(0, 3),
                )
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${procurementDetails.isNotEmpty ? procurementDetails[0]['description'] : ''}',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                ),
                SizedBox(height: 5),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                  decoration: BoxDecoration(
                    color: getStatusColor(procurementDetails.isNotEmpty
                        ? procurementDetails[0]['status']
                        : ''),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Text(
                    'Status: ${procurementDetails.isNotEmpty ? procurementDetails[0]['status'] : ''}',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  'Date Created: ${formatDate(procurementDetails.isNotEmpty ? procurementDetails[0]['dateCreated'] : '')}',
                  style: TextStyle(fontSize: 12),
                ),
              ],
            ),
          ),
          SizedBox(height: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Item Details',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 5),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: List.generate(procureItemDetails.length, (index) {
                    final detail = procureItemDetails[index];
                    return SizedBox(
                      width: MediaQuery.of(context).size.width / 4,
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 5),
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white,
                          border: Border.all(color: Colors.grey),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${detail['itemName']}',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 14),
                            ),
                            SizedBox(height: 3),
                            Text(
                              'Quantity: ${detail['quantity']}',
                              style: TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                ),
              ),
             ElevatedButton(
                onPressed: () => downloadPDF(widget.procId),
                child: Text('Download pdf'),
              )
            ],
          ),
          SizedBox(height: 20),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.blue.shade900, Colors.blue.shade600],
              ),
            ),
            child: Column(
              children: [
                SizedBox(height: 20),
                if (supplierDetails.isNotEmpty) ...[
                  Container(
                    padding: EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Supplier Details',
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 2),
                        ListTile(
                          title: Text(
                            '${supplierDetails['firstName']} ${supplierDetails['lastName']}',
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.w600),
                          ),
                          subtitle: Text('${supplierDetails['companyName']}'),
                        ),
                        Text(
                          '${supplierDetails['email']}',
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w500),
                        ),
                        Text(
                            'Phone: ${supplierDetails['phone']} , ${supplierDetails['alternateNumber']}',
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w500)),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  // Display custom message for STARTED status
                ],
              ],
            ),
          ),
          if (purchaseRequestStatus.isNotEmpty) ...[
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Text(
                purchaseRequestStatus == 'STARTED'
                    ? 'Request Sent to Supplier. Waiting for response.'
                    : purchaseRequestStatus == 'ACCEPTED'
                        ? 'Request Accepted by the supplier. Waiting for quotation.'
                        : 'Order rejected by the supplier',
                style: TextStyle(
                  fontSize: 12,
                  color: purchaseRequestStatus == 'STARTED'
                      ? Colors.orange
                      : purchaseRequestStatus == 'ACCEPTED'
                          ? Colors.green
                          : Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ],
      ),
      /*floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          showConfirmationDialog();
        },
        label: Text('Cancel', style: TextStyle(color: Colors.white)),
        icon: Icon(Icons.cancel, color: Colors.white),
        backgroundColor: Color.fromARGB(255, 219, 50, 38),
      ),*/
    );
    
  }
}

void main() {
  runApp(MaterialApp(
    home: New_DETAILS(procId: 'YourProcurementId'),
  ));
}
