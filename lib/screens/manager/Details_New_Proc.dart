import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

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
        Uri.parse('http://192.168.0.102:3000/getProc?procId=${widget.procId}'));
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
        'http://192.168.0.102:3000/ProcureItemDetails?procId=$procId'));
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
                    offset: Offset(0, 3))
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                    '${procurementDetails.isNotEmpty ? procurementDetails[0]['description'] : ''}',
                    style:
                        TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                SizedBox(height: 5),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                  decoration: BoxDecoration(
                      color: getStatusColor(procurementDetails.isNotEmpty
                          ? procurementDetails[0]['status']
                          : ''),
                      borderRadius: BorderRadius.circular(5)),
                  child: Text(
                      'Status: ${procurementDetails.isNotEmpty ? procurementDetails[0]['status'] : ''}',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12)),
                ),
                SizedBox(height: 5),
                Text(
                    'Date Created: ${formatDate(procurementDetails.isNotEmpty ? procurementDetails[0]['dateCreated'] : '')}',
                    style: TextStyle(fontSize: 12)),
              ],
            ),
          ),
          SizedBox(height: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Item Details',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(
                height: 5,
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: List.generate(procureItemDetails.length, (index) {
                    final detail = procureItemDetails[index];
                    return SizedBox(
                      width: MediaQuery.of(context).size.width /
                          4, // Adjust width to fit four items in one row
                      child: Container(
                        margin: EdgeInsets.symmetric(
                            horizontal: 5), // Add margin between tiles
                        padding: EdgeInsets.all(
                            5), // Adjust padding to make items smaller
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white,
                          border: Border.all(color: Colors.grey), // Add border
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('${detail['itemName']}',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14)), // Reduce font size
                            SizedBox(height: 3), // Adjust spacing between items
                            Text('Quantity: ${detail['quantity']}',
                                style: TextStyle(
                                    fontSize: 12)), // Reduce font size
                          ],
                        ),
                      ),
                    );
                  }),
                ),
              ),
              ElevatedButton(onPressed: (){}, child: Text('Download pdf'))
            ],
          ),
        ],
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: Details_New_Procurment(procId: 'YourProcurementId'),
  ));
}

