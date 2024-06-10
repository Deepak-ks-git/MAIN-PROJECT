import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:project3/screens/manager/New_Procuremnt_Nav.dart';

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
  bool isAscending = true;

  @override
  void initState() {
    super.initState();
    fetchProcurements();
  }

  Future<void> fetchProcurements() async {
    try {
      final response = await http.get(Uri.parse('http://192.168.1.143:3000/Man_new_proc'));
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

  void sortProcurements() {
    setState(() {
      procurements.sort((a, b) {
        final dateA = DateTime.parse(a.dateCreated);
        final dateB = DateTime.parse(b.dateCreated);
        return isAscending ? dateA.compareTo(dateB) : dateB.compareTo(dateA);
      });
      isAscending = !isAscending;
    });
  }

  String getSortingState() {
    return isAscending ? 'Old to New' : 'New to Old';
  }

  Icon getSortingIcon() {
    return isAscending ? Icon(Icons.arrow_upward) : Icon(Icons.arrow_downward);
  }

  @override
  Widget build(BuildContext context) {
    Color myColor = const Color(0xFF1E2736);

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255).withOpacity(0.5),
      body: ListView.separated(
        padding: const EdgeInsets.all(10.0),
        itemCount: procurements.length,
        separatorBuilder: (context, index) => Divider(
          thickness: 2,
        ),
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
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    procurement.description,
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 4),
                  Text(
                    procurement.procId,
                    style: TextStyle(
                      fontSize: 12, // Reduced font size
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Date Created: ${formatDate(procurement.dateCreated)}',
                    style: TextStyle(fontSize: 10),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: myColor, // Replace with your color
        child: Icon(Icons.sort, color: Colors.white,),
        onPressed: () {
          showModalBottomSheet(
            context: context,
            builder: (context) {
              return Container(
                padding: EdgeInsets.all(10.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ListTile(
                      title: Row(
                        children: [
                          Text('Date Created', style: TextStyle(fontSize: 16)),
                          Spacer(),
                          Text(getSortingState(), style: TextStyle(fontSize: 16)),
                          SizedBox(width: 4),
                          getSortingIcon(),
                        ],
                      ),
                      onTap: () {
                        sortProcurements();
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
              );
            },
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
