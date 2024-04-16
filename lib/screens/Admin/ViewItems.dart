import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:project3/screens/Admin/EditItemPage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ViewItems(),
    );
  }
}

class ViewItems extends StatefulWidget {
  const ViewItems({Key? key}) : super(key: key);

  @override
  State<ViewItems> createState() => _ViewItemsState();
}

class _ViewItemsState extends State<ViewItems> {
  List<Item> items = [];

  @override
  void initState() {
    super.initState();
    fetchItems();
  }

  Future<void> fetchItems() async {
    try {
      final response = await http.get(Uri.parse('http://192.168.0.102:3000/getItems'));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          items = data.map((itemData) => Item.fromJson(itemData)).toList();
        });
      } else {
        throw Exception('Failed to load items');
      }
    } catch (error) {
      print('Error fetching items: $error');
      // Handle error as needed
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('View Items'),
      ),
      body: ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          return Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: Container(
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
              child: Slidable(
                actionPane: SlidableDrawerActionPane(),
                actionExtentRatio: 0.25,
                child: ListTile(
                  title: Text(item.name),
                  subtitle: Text('Color: ${item.color} | Dimension: ${item.dimension}'),
                  trailing: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: item.status == 'Active' ? Colors.green : Colors.red,
                    ),
                    child: Text(
                      item.status,
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                secondaryActions: [
                  IconSlideAction(
                    caption: 'Edit',
                    color: Colors.blue,
                    icon: Icons.edit,
                    onTap: () {
                      // Navigate to EditItemPage with item details
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditItemPage(item: item),
                        ),
                      );
                    },
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

class Item {
  final String itemId;
  final String name;
  final String color;
  final String dimension;
  final String status;

  Item({
    required this.itemId,
    required this.name,
    required this.color,
    required this.dimension,
    required this.status,
  });

  factory Item.fromJson(List<dynamic> json) {
    return Item(
      itemId: json[0] ?? '',
      name: json[1] ?? '',
      color: json[2] ?? '',
      dimension: json[3] ?? '',
      status: json[4] ?? '',
    );
  }
}