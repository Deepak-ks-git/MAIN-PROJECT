import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:project3/screens/Admin/CreateProcurement.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

class ProcurementDetailsPage extends StatefulWidget {
  final String procId;

  ProcurementDetailsPage({required this.procId});

  @override
  _ProcurementDetailsPageState createState() => _ProcurementDetailsPageState();
}

class _ProcurementDetailsPageState extends State<ProcurementDetailsPage> {
  List<Map<String, dynamic>> procurementDetails = [];
  List<Map<String, dynamic>> procureItemDetails = [];
  List<Map<String, dynamic>> activeItems = [];
  String selectedItem = '';
  int quantity = 0;

  @override
  void initState() {
    super.initState();
    fetchProcurements();
    fetchActiveItems();
  }

  Future<void> fetchProcurements() async {
    final response = await http.get(Uri.parse('http://192.168.1.142:3000/getProc?procId=${widget.procId}'));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      setState(() {
        procurementDetails = data.map((dynamic item) => {
          'procId': item[0],
          'description': item[1],
          'status': item[2],
          'dateCreated': item[3],
        }).toList();
      });
      fetchProcurementDetails(widget.procId);
    }
  }

  Future<void> fetchActiveItems() async {
    final response = await http.get(Uri.parse('http://192.168.1.142:3000/getActiveItems'));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      setState(() {
        activeItems = data.map((dynamic item) => {
          'itemId': item[0],
          'itemName': item[1],
        }).toList();
      });
    }
  }

  Future<void> fetchProcurementDetails(String procId) async {
    final response = await http.get(Uri.parse('http://192.168.1.142:3000/ProcureItemDetails?procId=$procId'));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      setState(() {
        procureItemDetails = data.map<Map<String, dynamic>>((dynamic item) => {
          'itemId': item[0].toString(),
          'quantity': item[1] as int,
          'itemName': item[2].toString(),
        }).toList();
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

  void addItemToProcurement() async {
    if (selectedItem.isNotEmpty && quantity > 0) {
      final url = Uri.parse('http://192.168.1.142:3000/addItemToProcurement');
      final response = await http.post(url, body: {
        'procId': widget.procId,
        'itemId': activeItems.firstWhere((item) => item['itemName'] == selectedItem)['itemId'],
        'qty': quantity.toString(),
        'user_id': 'admin',
      });

      if (response.statusCode == 200) {
        print('Item added to procurement successfully');
        // Reload the page
        Navigator.of(context).pop();
        Navigator.of(context).pop();

        Navigator.of(context).push(MaterialPageRoute(builder: (context) => ProcurementDetailsPage(procId: widget.procId)));
      } else {
        print('Failed to add item to procurement');
      }
    } else {
      print('Please select an item and enter quantity');
    }
  }

  void deleteItemFromProcurement(String itemId) async {
    final url = Uri.parse('http://192.168.1.142:3000/deleteItemFromProcurement');
    final response = await http.post(url, body: {
      'procId': widget.procId,
      'itemId': itemId,
    });

    if (response.statusCode == 200) {
      print('Item deleted from procurement successfully');
      // Reload the page
      
      Navigator.of(context).pop();

      Navigator.of(context).push(MaterialPageRoute(builder: (context) => ProcurementDetailsPage(procId: widget.procId)));
    } else {
      print('Failed to delete item from procurement');
    }
  }

  void startProcurement() async {
    if (procureItemDetails.isNotEmpty) {
      // Call the API to start procurement
      final url = Uri.parse('http://192.168.1.142:3000/startProc');
      final response = await http.post(url, body: {'procId': widget.procId});
      
      if (response.statusCode == 200) {
        print('Procurement started successfully');
        // Reload the page
        showQuickAlert(context, 'Procurement Started');
        await Future.delayed(Duration(seconds: 2));
        Navigator.of(context).pop();
        
        //Navigator.of(context).pushR(MaterialPageRoute(builder: (context) => CreateProcurement()));
      } else {
        print('Failed to start procurement');
      }
    } else {
      // Show a snackbar indicating no items are available
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Please add at least one item to start procurement')));
    }
  }
 void showQuickAlert(BuildContext context, String message) {
    QuickAlert.show(
      context: context,
      type: QuickAlertType.success,
      text: message,
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Procurement Details')),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          Container(
            margin: EdgeInsets.only(bottom: 16),
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
              boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.5), spreadRadius: 2, blurRadius: 5, offset: Offset(0, 3))],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Procurement Details', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                SizedBox(height: 8),
                Text('${procurementDetails.isNotEmpty ? procurementDetails[0]['description'] : ''}', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                SizedBox(height: 8),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(color: getStatusColor(procurementDetails.isNotEmpty ? procurementDetails[0]['status'] : ''), borderRadius: BorderRadius.circular(5)),
                  child: Text('Status: ${procurementDetails.isNotEmpty ? procurementDetails[0]['status'] : ''}', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
                SizedBox(height: 8),
                Text('Date Created: ${formatDate(procurementDetails.isNotEmpty ? procurementDetails[0]['dateCreated'] : '')}', style: TextStyle(fontSize: 14)),
              ],
            ),
          ),
          SizedBox(height: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Item Details', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ...procureItemDetails.map((detail) => SizedBox(
                width: MediaQuery.of(context).size.width / 2,
                child: Container(
                  margin: EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                    boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.5), spreadRadius: 2, blurRadius: 5, offset: Offset(0, 3))],
                  ),
                  child: ListTile(
                    title: Text('${detail['itemName']}', style: TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text('Item ID: ${detail['itemId']}\nQuantity: ${detail['quantity']}'),
                    trailing: IconButton(
                      icon: Icon(Icons.cancel),
                      onPressed: () => deleteItemFromProcurement(detail['itemId']),
                    ),
                  ),
                ),
              )),
            ],
          ),
          SizedBox(height: 20),
          Container(
            alignment: Alignment.center,
            child: ElevatedButton(
              onPressed: startProcurement,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 16),
              ),
              child: Text(
                'Start Procurement',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ),
          SizedBox(height: 20),
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
              boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.5), spreadRadius: 2, blurRadius: 5, offset: Offset(0, 3))],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Select Item', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  value: selectedItem.isNotEmpty ? selectedItem : null,
                  onChanged: (value) {
                    setState(() {
                      selectedItem = value!;
                    });
                  },
                  items: activeItems
                      .where((item) => !procureItemDetails.any((detail) => detail['itemId'] == item['itemId']))
                      .map((item) => DropdownMenuItem<String>(
                            value: item['itemName'], // Use unique value here
                            child: Text(item['itemName']),
                          ))
                      .toList(),
                  hint: Text('Select Item'),
                ),
                SizedBox(height: 16),
                Text('Quantity', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                SizedBox(height: 8),
                TextFormField(
                  keyboardType: TextInputType.number,
                  onChanged: (value) => setState(() => quantity = int.tryParse(value) ?? 0),
                  decoration: InputDecoration(
                    hintText: 'Enter Quantity',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: addItemToProcurement,
                  child: Text('Add Item'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: ProcurementDetailsPage(procId: 'YourProcurementId'),
  ));
}
