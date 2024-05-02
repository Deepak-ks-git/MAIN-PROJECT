import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:project3/screens/manager/New_Procuremnt_Nav.dart';

// Importing ProcurementDetailsPage.dart

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Man_New_Procurements(),
    );
  }
}

class Man_New_Procurements extends StatefulWidget {
  const Man_New_Procurements({Key? key}) : super(key: key);

  @override
  State<Man_New_Procurements> createState() => _ViewProcurementsState();
}

class _ViewProcurementsState extends State<Man_New_Procurements> {
  List<Procure> procurements = [];

  @override
  void initState() {
    super.initState();
    fetchProcurements();
  }

  Future<void> fetchProcurements() async {
    try {
      final response = await http.get(Uri.parse('http://192.168.1.142:3000/Man_new_proc'));
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

  String formatDate(String date) {
    final parsedDate = DateTime.parse(date);
    final formattedDate = DateFormat.yMMMd().format(parsedDate);
    return formattedDate;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     
      backgroundColor: Colors.grey.withOpacity(0.5), // Background color with shading
      body: Padding(
        padding: const EdgeInsets.all(8.0), // Padding around the GridView
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3, // Displaying 3 tiles in one row
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
                    builder: (context) => New_Procuremnt_Nav(procId: procurement.procId),
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
                        fontSize: 12, // Reduced font size
                      ),
                    ),
                    SizedBox(height: 8),
                    Flexible( // Use Flexible widget to allow wrapping
                      child: Text(
                        '${procurement.description}',
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Date Created: ${formatDate(procurement.dateCreated)}',
                      style: TextStyle(fontSize: 10),
                    ),
                    // Status part wrapped with Visibility widget set to false
                    Visibility(
                      visible: false,
                      child: SizedBox(height: 8),
                    ),
                    // Visibility widget ends here
                  ],
                ),
              ),
            );
          },
        ),
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
