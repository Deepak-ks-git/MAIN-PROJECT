import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class StockLevelReport extends StatefulWidget {
  @override
  _StockLevelReportState createState() => _StockLevelReportState();
}

class _StockLevelReportState extends State<StockLevelReport> {
  String _selectedStockLevel = 'No criteria';
  String _selectedItemOption = 'All'; // Default selected option
  late TextEditingController _minStockController = TextEditingController();
  late TextEditingController _maxStockController = TextEditingController();
  List<String> _selectedItems = ['ALL'];
  List<Map<String, String>> _itemList = [];

  @override
  void initState() {
    super.initState();
    _fetchItems();
    _minStockController = TextEditingController();
    _maxStockController = TextEditingController();
  }

  @override
  void dispose() {
    _minStockController.dispose();
    _maxStockController.dispose();
    super.dispose();
  }

  Future<void> _fetchItems() async {
    final response =
        await http.get(Uri.parse('http://192.168.1.143:3000/ITEM_STOCK'));
    if (response.statusCode == 200) {
      final List<dynamic> responseData = json.decode(response.body);
      setState(() {
        _itemList = responseData.map((item) {
          return {
            'id': item[0] as String,
            'name': item[1] as String,
          };
        }).toList();
      });
    } else {
      print('Failed to fetch items: ${response.reasonPhrase}');
    }
  }
void _downloadReport() async {
  // Print selected items for debugging
  print('Selected items: $_selectedItems');

  // Extract selected custom item IDs
  List<String> selectedIds = _itemList
    .where((item) => _selectedItems.contains(item['name']))
    .map((item) => item['id'])
    .whereType<String>() // Filter out null values
    .toList(); // Convert to list of strings

  // Print selected IDs for debugging
  print('Selected IDs: $selectedIds');

  // Convert selected IDs to comma-separated string
  String selectedItems = selectedIds.join(',');

  String url = 'http://192.168.1.143:3000/api/ITEM_STOCK-report-pdf?selectedItems=$selectedItems';

  final response = await http.get(Uri.parse(url));
  if (response.statusCode == 200) {
    final responseData = response.body;
    print('PDF generated successfully: $responseData');
  } else {
    print('Failed to generate PDF: ${response.reasonPhrase}');
  }
}

  @override
  Widget build(BuildContext context) {
    Color myColor = Color(0xFF1E2736);
    Color download = Color(0xFf1B9AF7);

    OutlineInputBorder border = OutlineInputBorder(
      borderSide: BorderSide(color: Colors.grey.shade400),
      borderRadius: BorderRadius.circular(5.0),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text('Stock Level Report',
            style: TextStyle(color: Colors.white, fontSize: 18)),
        backgroundColor: myColor,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Item', style: TextStyle(fontSize: 16)),
            SizedBox(height: 8),
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 10.0, vertical: 15.0),
                border: border,
                enabledBorder: border,
                focusedBorder: border,
              ),
              value: _selectedItemOption,
              onChanged: (String? newValue) {
                setState(() {
                  _selectedItemOption = newValue!;
                  _selectedItems.clear();
                  if (_selectedItemOption == 'All') {
                    _selectedItems.add('ALL');
                  }
                });
              },
              items: <String>['All', 'Custom']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            if (_selectedItemOption == 'Custom') ...[
              SizedBox(height: 8),
              Expanded(
                child: SingleChildScrollView(
                  child: Container(
                    height: 200, // Fixed height for the ListView
                    child: ListView(
                      physics: AlwaysScrollableScrollPhysics(),
                      children: _itemList.map((item) {
                        return CheckboxListTile(
                          title: Text(item['name']!),
                          value: _selectedItems.contains(item['name']),
                          onChanged: (bool? value) {
                            setState(() {
                              if (value == true) {
                                _selectedItems.add(item['name']!);
                              } else {
                                _selectedItems.remove(item['name']);
                              }
                              if (_selectedItems.isEmpty) {
                                _selectedItems.add('ALL');
                              } else {
                                _selectedItems.remove('ALL');
                              }
                            });
                          },
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Selected Items:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 4),
              Wrap(
                spacing: 8,
                children: _selectedItems.map((item) {
                  return Chip(
                    label: Text(item),
                    onDeleted: () {
                      setState(() {
                        _selectedItems.remove(item);
                      });
                    },
                  );
                }).toList(),
              ),
            ],
            SizedBox(height: 30),
            Divider(height: 0, thickness: 2,),
            SizedBox(height: 30),
            Text('Stock Level', style: TextStyle(fontSize: 16)),
            SizedBox(height: 8),
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 10.0, vertical: 15.0),
                border: border,
                enabledBorder: border,
                focusedBorder: border,
              ),
              value: _selectedStockLevel,
              onChanged: (String? newValue) {
                setState(() {
                  _selectedStockLevel = newValue!;
                });
              },
              items: <String>['No criteria', 'Zero', 'Range']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            if (_selectedStockLevel == 'Range') ...[
              SizedBox(height: 16),
              Text('Minimum Stock', style: TextStyle(fontSize: 16)),
              SizedBox(height: 8),
              TextField(
                controller: _minStockController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 10.0, vertical: 15.0),
                  border: border,
                  enabledBorder: border,
                  focusedBorder: border,
                ),
              ),
              SizedBox(height: 16),
              Text('Maximum Stock', style: TextStyle(fontSize: 16)),
              SizedBox(height: 8),
              TextField(
                controller: _maxStockController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 10.0, vertical: 15.0),
                  border: border,
                  enabledBorder: border,
                  focusedBorder: border,
                ),
              ),
            ],
            Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: Icon(Icons.download, color: Colors.white),
                label: Text('Download'),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor:download,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                onPressed: _downloadReport,
              ),
            ),
          ],
        ),
      ),
    );
  }
}