import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class View_Stock extends StatefulWidget {
  const View_Stock({Key? key}) : super(key: key);

  @override
  State<View_Stock> createState() => _View_StockState();
}

class _View_StockState extends State<View_Stock> {
  List<dynamic> itemStockList = [];

  @override
  void initState() {
    super.initState();
    fetchItemStockList();
  }

  Future<void> fetchItemStockList() async {
    try {
      final response = await http.get(Uri.parse('http://192.168.1.142:3000/getStockLIST'));

      if (response.statusCode == 200) {
        setState(() {
          itemStockList = jsonDecode(response.body);
        });
      } else {
        // Handle error response
        print('Failed to load item stock list: ${response.statusCode}');
      }
    } catch (e) {
      // Handle network or parsing errors
      print('Error fetching item stock list: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('View Stock'),
      ),
      body: itemStockList.isEmpty
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: itemStockList.length,
              itemBuilder: (context, index) {
                final item = itemStockList[index];

                return ListTile(
                  title: Text(
                    item[0], // Item name
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text('InStock: ${item[2]}'),
                  // You can customize ListTile appearance and add more details as needed
                  // Example: trailing: Icon(Icons.arrow_forward),
                );
              },
            ),
    );
  }
}
