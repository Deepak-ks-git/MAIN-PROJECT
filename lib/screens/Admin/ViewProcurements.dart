import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:project3/screens/Admin/ProcurementDetailsPage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ViewProcurements(),
    );
  }
}

class ViewProcurements extends StatefulWidget {
  const ViewProcurements({Key? key}) : super(key: key);

  @override
  State<ViewProcurements> createState() => _ViewProcurementsState();
}

class _ViewProcurementsState extends State<ViewProcurements> {
  List<Procure> procurements = [];

  @override
  void initState() {
    super.initState();
    fetchProcurements();
  }

  Future<void> fetchProcurements() async {
    try {
      final response = await http.get(Uri.parse('http://192.168.1.142:3000/getProcurements'));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          procurements = data.map((procurementData) => Procure.fromJson(procurementData)).toList();
        });
      } else {
        throw Exception('Failed to load procurements');
      }
    } catch (error) {
      print('Error fetching procurements: $error');
      // Handle error as needed
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
    // Assuming date is in the format "YYYY-MM-DDTHH:MM:SS.000Z"
    final parsedDate = DateTime.parse(date);
    final formattedDate = DateFormat.yMMMd().format(parsedDate);
    return formattedDate;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('View Procurements'),
      ),
      body: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: procurements.length,
        itemBuilder: (context, index) {
          final procurement = procurements[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProcurementDetailsPage(procId: procurement.procId),
                ),
              );
            },
            child: Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    procurement.procId,
                    style: TextStyle(
                      fontSize: 14,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    '${procurement.description}',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Date Created: ${formatDate(procurement.dateCreated)}',
                    style: TextStyle(fontSize: 10),
                  ),
                  SizedBox(height: 8),
                  Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: getStatusColor(procurement.status),
                    ),
                    child: Text(
                      procurement.status.toUpperCase(),
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class Procure {
  final String procId;
  final String description;
  final String status;
  final String dateCreated;

  Procure({
    required this.procId,
    required this.description,
    required this.status,
    required this.dateCreated,
  });

  factory Procure.fromJson(List<dynamic> json) {
    return Procure(
      procId: json[0] ?? '',
      description: json[1] ?? '',
      status: json[2] ?? '',
      dateCreated: json[3] ?? '',
    );
  }
}
