import 'package:flutter/material.dart';
import 'package:project3/screens/supplier/EditQuotation.dart';
import 'package:project3/screens/supplier/List_of_Accepted.dart';
import 'package:project3/screens/supplier/viewAllQuotation.dart';

class QuotationPage extends StatefulWidget {
  final String username; // Accept username as a parameter
  

  const QuotationPage({Key? key, required this.username}) : super(key: key);

  @override
  State<QuotationPage> createState() => _QuotationPageState();
}

class _QuotationPageState extends State<QuotationPage> {
  List<Map<String, dynamic>> actions = [
    {'title': 'Make Quotation', 'icon': Icons.add},
    {'title': 'View Quotations', 'icon': Icons.view_list},
    {'title': 'Edit Quotations', 'icon': Icons.edit}
   
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quotations'),
      ),
      body: GridView.builder(
        padding: EdgeInsets.all(10),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemCount: actions.length,
        itemBuilder: (BuildContext context, int index) {
          return InkWell(
            onTap: () {
              // Perform action based on tile clicked
              switch (index) {
                case 0:
                Navigator.push(context, MaterialPageRoute(builder:(context) => List_of_Accepted(username:widget.username)));
                  break;
                case 1:
                Navigator.push(context, MaterialPageRoute(builder:(context) => viewAllQuotation(username:widget.username)));
                  break;
                case 2:
                Navigator.push(context, MaterialPageRoute(builder:(context) => EditQuotation(username:widget.username)));
                  break;
                case 3:
                  // Send Quotations
                  break;
              }
            },
            child: Card(
              elevation: 3,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(actions[index]['icon'] as IconData),
                    SizedBox(height: 10),
                    Text(actions[index]['title'] as String),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
