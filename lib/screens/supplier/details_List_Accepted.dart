import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class DetailsListAccepted extends StatefulWidget {
  final String procId;

  const DetailsListAccepted({Key? key, required this.procId}) : super(key: key);

  @override
  _DetailsListAcceptedState createState() => _DetailsListAcceptedState();
}

class _DetailsListAcceptedState extends State<DetailsListAccepted> {
  List<dynamic> items = [];
  String purchaseReqId = '';

  @override
  void initState() {
    super.initState();
    fetchPurchaseRequestId();
    fetchdetailsListAccepted();
  }

  Future<void> fetchPurchaseRequestId() async {
    try {
      final response = await http.get(Uri.parse(
          'http://192.168.1.142:3000/get_purchase_reqid?procId=${widget.procId}'));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          purchaseReqId = data[0][0];
        });
      } else {
        throw Exception('Failed to load purchase request ID');
      }
    } catch (error) {
      print('Error fetching purchase request ID: $error');
    }
  }

  Future<void> fetchdetailsListAccepted() async {
    try {
      final response = await http.get(Uri.parse(
          'http://192.168.1.142:3000/Item_Reqeust_details?procId=${widget.procId}'));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          items = data;
        });
      } else {
        throw Exception('Failed to load purchase items');
      }
    } catch (error) {
      print('Error fetching purchase items: $error');
    }
  }

  Future<void> createQuotation() async {
    try {
      final response = await http.post(
        Uri.parse('http://192.168.1.142:3000/create_quotation'),
        body: json.encode({
          'PURCHASE_REQ_ID': purchaseReqId,
          'ITEM_DETAILS': items.map((item) => {'ITEM_ID': item[0]}).toList(),
        }),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        print('Quotation created');
      } else {
        throw Exception('Failed to create quotation');
      }
    } catch (error) {
      print('Error creating quotation: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
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
          SizedBox(
            height: 150, // Adjust height as needed
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: _buildGridRows(),
              ),
            ),
          ),
          SizedBox(height: 20),
          Container(
            alignment: Alignment.center,
            child: ElevatedButton(
              onPressed: createQuotation,
              child: Text('Create Quotation'),
            ),
          ),
        ],
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
              const SizedBox(height: 10,),
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
}
