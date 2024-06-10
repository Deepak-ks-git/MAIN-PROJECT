import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class QuotationReport extends StatefulWidget {
  @override
  _QuotationReportState createState() => _QuotationReportState();
}

class _QuotationReportState extends State<QuotationReport> {
  String _selectedStatus = 'ALL'; // Default to show all statuses
  String _selectedDateRange = 'Today';
  late String _dateDisplay; // To display the selected date range
  bool _showCustomOptions = false;
  bool _showDateRange = false;
  late DateTime _selectedDate;
  late DateTime _startDate;
  late DateTime _endDate;

  void _downloadReport() async {
    String url = 'http://192.168.1.143:3000/api/Quotation-Report-PDF?status=$_selectedStatus&dateRange=$_selectedDateRange';

    if (_selectedDateRange == 'Custom') {
      url += '&startDate=${DateFormat('yyyy-MM-dd').format(_startDate)}&endDate=${DateFormat('yyyy-MM-dd').format(_endDate)}';
    }

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final responseData = response.body;
      // Handle the response, e.g., show a dialog with the download link
      print('PDF generated successfully: $responseData');
      // You can use a package like `url_launcher` to open the PDF file
    } else {
      print('Failed to generate PDF: ${response.reasonPhrase}');
    }
  }

  // Function to calculate date range display
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
      case 'Previous Week':
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
      // Add cases for other date ranges
      default:
        startDate = now;
        endDate = now;
    }

    DateFormat dateFormat = DateFormat('dd-MM-yyyy');
    _dateDisplay = '${dateFormat.format(startDate)} to ${dateFormat.format(endDate)}';
  }

  @override
  void initState() {
    super.initState();
    _calculateDateDisplay(_selectedDateRange); // Calculate initial date display
    _selectedDate = DateTime.now(); // Initialize _selectedDate
    _startDate = DateTime.now(); // Initialize _startDate
    _endDate = DateTime.now(); // Initialize _endDate
  }

  @override
  Widget build(BuildContext context) {
    Color myColor = Color(0xFF1E2736);
        Color download = Color(0xFf1B9AF7);

    OutlineInputBorder border = OutlineInputBorder(
      borderSide: BorderSide(color: Colors.grey.shade400),
      borderRadius: BorderRadius.circular(5.0),
    );

    DateFormat dateFormat = DateFormat('dd-MM-yyyy');

    return Scaffold(
      appBar: AppBar(
        title: Text('Quotation Report', style: TextStyle(color: Colors.white,fontSize: 18)),
        backgroundColor: myColor,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Status', style: TextStyle(fontSize: 16)),
            SizedBox(height: 8),
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 15.0),
                border: border,
                enabledBorder: border,
                focusedBorder: border,
              ),
              value: _selectedStatus,
              onChanged: (String? newValue) {
                setState(() {
                  _selectedStatus = newValue!;
                });
              },
              items: <String>['ALL','CREATED','SENDED','APPROVED','PLACED','REJECTED'] // Added 'ALL' option
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            SizedBox(height: 16),
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
                  child: _selectedDateRange != 'Custom' ? Text(_dateDisplay, style: TextStyle(fontSize: 12)) : null,
                ),
              ],
            ),
            SizedBox(height: 8),
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 15.0),
                border: border,
                enabledBorder: border,
                focusedBorder: border,
              ),
              value: _selectedDateRange,
              onChanged: (String? newValue) {
                setState(() {
                  _selectedDateRange = newValue!;
                  if (_selectedDateRange == 'Custom') {
                    _showCustomOptions = true;
                    _showDateRange = false;
                  } else {
                    _showCustomOptions = false;
                    _showDateRange = false;
                    _calculateDateDisplay(_selectedDateRange);
                  }
                });
              },
              items: <String>[
                'Today', 
                'Yesterday', // Added 'Yesterday' option
                'This Week', 
                'Previous Week', // Added 'Previous Week' option
                'This Month', 
                'Previous Month', // Added 'Previous Month' option
                'This Quarter', 
                'Previous Quarter', // Added 'Previous Quarter' option
                'This Year', 
                'Previous Year', // Added 'Previous Year' option
                'Custom'
              ]
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            if (_showCustomOptions)
              Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Radio(
                          value: true,
                          groupValue: _showDateRange,
                          onChanged: (value) {
                            setState(() {
                              _showDateRange = value as bool;
                            });
                          },
                        ),
                        Text('Day'),
                        SizedBox(width: 8),
                        Radio(
                          value: false,
                          groupValue: _showDateRange,
                          onChanged: (value) {
                            setState(() {
                              _showDateRange = value as bool;
                            });
                          },
                        ),
                        Text('Range'),
                      ],
                    ),
                    if (_showDateRange)
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            side: BorderSide(color: Colors.grey),
                          ),
                          onPressed: () {
                            showDatePicker(
                              context: context,
                              initialDate: _selectedDate,
                              firstDate: DateTime(2000),
                              lastDate: DateTime(2100),
                            ).then((value) {
                              setState(() {
                                if (value != null) {
                                  _selectedDate = value;
                                  _startDate = value;
                                  _endDate = value;
                                }
                              });
                            });
                          },
                          child: Text('Select Date', style: TextStyle(color: Colors.black)),
                        ),
                      ),
                    if (!_showDateRange)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 150,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                side: BorderSide(color: Colors.grey),
                              ),
                              onPressed: () {
                                showDatePicker(
                                  context: context,
                                  initialDate: _startDate,
                                  firstDate: DateTime(2000),
                                  lastDate: DateTime(2100),
                                ).then((value) {
                                  setState(() {
                                    if (value != null) {
                                      _startDate = value;
                                    }
                                  });
                                });
                              },
                              child: Text('Start Date', style: TextStyle(color: Colors.black)),
                            ),
                          ),
                          SizedBox(width: 16),
                          SizedBox(
                            width: 150,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                side: BorderSide(color: Colors.grey),
                              ),
                              onPressed: () {
                                showDatePicker(
                                  context: context,
                                  initialDate: _endDate,
                                  firstDate: DateTime(2000),
                                  lastDate: DateTime(2100),
                                ).then((value) {
                                  setState(() {
                                    if (value != null) {
                                      _endDate = value;
                                    }
                                  });
                                });
                              },
                              child: Text('End Date', style: TextStyle(color: Colors.black)),
                            ),
                          ),
                        ],
                      ),
                    SizedBox(height: 20),
                    if (_selectedDateRange == 'Custom' && !_showDateRange)
                      Center(
                        child: Text(
                          '${dateFormat.format(_startDate)}   to    ${dateFormat.format(_endDate)}',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blue[900]),
                        ),
                      ),
                    if (_selectedDateRange == 'Custom' && _showDateRange)
                      Center(
                        child: Text(
                          dateFormat.format(_selectedDate),
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blue[900]),
                        ),
                      ),
                  ],
                ),
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
