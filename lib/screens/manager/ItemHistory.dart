import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class ItemDetailPage extends StatefulWidget {
  final String itemId;

  ItemDetailPage({required this.itemId});

  @override
  _ItemDetailPageState createState() => _ItemDetailPageState();
}

class _ItemDetailPageState extends State<ItemDetailPage> {
  Map<String, String>? itemDetails;
  bool isLoading = true;

  String _selectedDateRange = 'Today';
  late String _dateDisplay;
  late bool _showDateRange = false; // Initialize _showDateRange
  late DateTime _startDate;
  late DateTime _endDate;

  @override
  void initState() {
    super.initState();
    fetchItemDetails();
    _calculateDateDisplay(_selectedDateRange);
    _startDate = DateTime.now();
    _endDate = DateTime.now();
  }

  Future<void> fetchItemDetails() async {
    try {
      final response = await http.get(
        Uri.parse(
            'http://192.168.1.143:3000/stock_item_details?itemId=${widget.itemId}'),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data.isNotEmpty && data[0] is List && data[0].length == 3) {
          setState(() {
            itemDetails = {
              'Name': data[0][0],
              'Color': data[0][1],
              'Dimensions': data[0][2],
            };
            isLoading = false;
          });
        }
      } else {
        print('Failed to load item details: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching item details: $e');
    }
  }

  void _downloadReport() async {
    String url =
        'http://192.168.1.143:3000/api/generate-item-report-pdf?itemId=${widget.itemId}&dateRange=$_selectedDateRange';

    if (_selectedDateRange == 'Custom') {
      url +=
          '&startDate=${DateFormat('yyyy-MM-dd').format(_startDate)}&endDate=${DateFormat('yyyy-MM-dd').format(_endDate)}';
    }

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      // Handle the PDF download or display
    } else {
      print('Failed to generate PDF: ${response.reasonPhrase}');
    }
  }

  void _calculateDateDisplay(String selectedRange) {
    DateTime now = DateTime.now();
    late DateTime startDate;
    late DateTime endDate;

    switch (selectedRange) {
      case 'Today':
        startDate = now;
        endDate = now;
        break;
      case 'Yesterday':
        startDate = now.subtract(Duration(days: 1));
        endDate = now.subtract(Duration(days: 1));
        break;
      case 'This Week':
        startDate = DateTime(now.year, now.month, now.day - now.weekday + 1);
        endDate = DateTime(now.year, now.month, now.day + (7 - now.weekday));
        break;
      case 'Last Week':
        startDate = DateTime(now.year, now.month, now.day - now.weekday - 6);
        endDate = DateTime(now.year, now.month, now.day - now.weekday);
        break;
      case 'This Month':
        startDate = DateTime(now.year, now.month, 1);
        endDate = DateTime(now.year, now.month + 1, 0);
        break;
      case 'Previous Month':
        startDate = DateTime(now.year, now.month - 1, 1);
        endDate = DateTime(now.year, now.month, 0);
        break;
      case 'This Quarter':
        startDate = DateTime(now.year, (now.month ~/ 3) * 3 + 1, 1);
        endDate = DateTime(now.year, (now.month ~/ 3 + 1) * 3, 0);
        break;
      case 'Previous Quarter':
        startDate = DateTime(now.year, (now.month ~/ 3 - 1) * 3 + 1, 1);
        endDate = DateTime(now.year, (now.month ~/ 3) * 3, 0);
        break;
      case 'This Year':
        startDate = DateTime(now.year, 1, 1);
        endDate = DateTime(now.year, 12, 31);
        break;
      case 'Previous Year':
        startDate = DateTime(now.year - 1, 1, 1);
        endDate = DateTime(now.year - 1, 12, 31);
        break;
      default:
        startDate = now;
        endDate = now;
    }

    DateFormat dateFormat = DateFormat('dd-MM-yyyy');
    _dateDisplay =
        '${dateFormat.format(startDate)} to ${dateFormat.format(endDate)}';
  }

  void _selectDate(BuildContext context, bool isStartDate) async {
    final initialDate = isStartDate ? _startDate : _endDate;
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      setState(() {
        if (isStartDate) {
          _startDate = pickedDate;
        } else {
          _endDate = pickedDate;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
            Color download = Color(0xFf1B9AF7);

    return Scaffold(
      appBar: AppBar(
        title: Text('Item Details'),
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : itemDetails == null
              ? Center(
                  child: Text('Failed to load item details'),
                )
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${itemDetails!['Name']}',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Color: ${itemDetails!['Color']}',
                        style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Dimensions: ${itemDetails!['Dimensions']}',
                        style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(height: 15),
                      Padding(
                        padding: EdgeInsets.only(left: 5),
                        child: Divider(height: 0),
                      ),
                      SizedBox(height: 15),
                      Row(
                        children: [
                          Text('Date Range:', style: TextStyle(fontSize: 16)),
                          SizedBox(width: 8),
                          Container(
                            padding: EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: _selectedDateRange != 'Custom'
                                ? Text(_dateDisplay,
                                    style: TextStyle(fontSize: 12))
                                : null,
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 10.0, vertical: 15.0),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                        ),
                        value: _selectedDateRange,
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedDateRange = newValue!;
                            if (_selectedDateRange == 'Custom') {
                              _showDateRange = true;
                            } else {
                              _showDateRange = false;
                              _calculateDateDisplay(_selectedDateRange);
                            }
                          });
                        },
                        items: <String>[
                          'Today',
                          'Yesterday',
                          'This Week',
                          'Last Week',
                          'This Month',
                          'Previous Month',
                          'This Quarter',
                          'Previous Quarter',
                          'This Year',
                          'Previous Year',
                          'Custom',
                        ].map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                      if (_showDateRange)
                        Column(
                          children: [
                            SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ElevatedButton(
                                  onPressed: () => _selectDate(context, true),
                                  child: Text('Start Date'),
                                ),
                                SizedBox(width: 16),
                                ElevatedButton(
                                  onPressed: () => _selectDate(context, false),
                                  child: Text('End Date'),
                                ),
                              ],
                            ),
                            SizedBox(height: 20),
                            Center(
                              child: Text(
                                '${DateFormat('dd-MM-yyyy').format(_startDate)}     to    ${DateFormat('dd-MM-yyyy').format(_endDate)}',
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color:download),
                              ),
                            ),
                          ],
                        ),
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
                              borderRadius: BorderRadius.circular(15.0),
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
