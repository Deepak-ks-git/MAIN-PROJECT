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
  List<dynamic> filteredItemList = []; // List for storing filtered items
  TextEditingController _stockLevelController = TextEditingController(); // Controller for the text field
  bool sortAscending = true;
  bool sortByStockLevel = false;

  @override
  void initState() {
    super.initState();
    fetchItemStockList();
  }

  Future<void> fetchItemStockList() async {
    try {
      final response =
          await http.get(Uri.parse('http://192.168.1.143:3000/getStockLIST'));

      if (response.statusCode == 200) {
        setState(() {
          itemStockList = jsonDecode(response.body);
          filteredItemList = List.from(itemStockList); // Initialize filteredItemList with itemStockList
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

  Future<void> updateStock(String itemId, int newStockLevel) async {
    try {
      final response = await http.post(
        Uri.parse('http://192.168.1.143:3000/updateStock'),
        body: jsonEncode({'itemId': itemId, 'newStockLevel': newStockLevel}),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        print('Stock updated successfully');
        // Optionally, you can update the itemStockList to reflect the new stock level
        fetchItemStockList(); // Refresh the list
      } else {
        // Handle error response
        print('Failed to update stock: ${response.statusCode}');
      }
    } catch (e) {
      // Handle network or parsing errors
      print('Error updating stock: $e');
    }
  }

  void filterItems(String query) {
    setState(() {
      filteredItemList = itemStockList.where((item) {
        final itemName = item[0].toLowerCase();
        return itemName.contains(query.toLowerCase());
      }).toList();
    });
  }

  void sortItemsByName() {
    setState(() {
      sortAscending = !sortAscending;
      filteredItemList.sort((a, b) => sortAscending
          ? a[0].toLowerCase().compareTo(b[0].toLowerCase())
          : b[0].toLowerCase().compareTo(a[0].toLowerCase()));
    });
  }

  void sortItemsByStockLevel() {
    setState(() {
      sortByStockLevel = !sortByStockLevel;
      filteredItemList.sort((a, b) => sortByStockLevel
          ? a[2].compareTo(b[2])
          : b[2].compareTo(a[2]));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('View Stock'),
        actions: [
          IconButton(
            onPressed: () {
              // Show search dialog
              showSearch(
                context: context,
                delegate: _ItemSearchDelegate(filteredItemList),
              );
            },
            icon: Icon(Icons.search),
          ),
          PopupMenuButton(
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem(
                  child: Text('Sort by Name'),
                  onTap: sortItemsByName,
                ),
                PopupMenuItem(
                  child: Text('Sort by Stock Level'),
                  onTap: sortItemsByStockLevel,
                ),
              ];
            },
          ),
        ],
      ),
      body: filteredItemList.isEmpty
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: filteredItemList.length,
              itemBuilder: (context, index) {
                final item = filteredItemList[index];

                return ListTile(
                  title: Text(
                    item[0], // Item name
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    'InStock: ${item[2]}',
                    style: TextStyle(color: Colors.greenAccent[700], fontWeight: FontWeight.bold),
                  ),
                  trailing: ElevatedButton(
                    onPressed: () {
                      // Show dialog or prompt for entering new stock level
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text('Update Stock'),
                          content: TextField(
                            controller: _stockLevelController, // Assign the controller to the TextField
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(labelText: 'New Stock Level'),
                            onChanged: (value) {
                              // Handle onChanged event if needed
                            },
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop(); // Close the dialog
                              },
                              child: Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () {
                                // Perform stock update operation
                                final newStockLevel = int.parse(_stockLevelController.text); // Access text entered in the TextField
                                updateStock(item[1], newStockLevel);
                                Navigator.of(context).pop(); // Close the dialog
                              },
                              child: Text('Update'),
                            ),
                          ],
                        ),
                      );
                    },
                    child: Text('Update Stock'),
                  ),
                );
              },
            ),
    );
  }
}

class _ItemSearchDelegate extends SearchDelegate<String> {
  final List<dynamic> itemStockList;

  _ItemSearchDelegate(this.itemStockList);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = ''; // Clear the search query
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, ''); // Close the search and return an empty string
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // Not used
    return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final List<dynamic> suggestionList = query.isEmpty
        ? itemStockList // Show full list if query is empty
        : itemStockList.where((item) {
            final itemName = item[0].toLowerCase();
            return itemName.contains(query.toLowerCase());
          }).toList();

    return ListView.builder(
      itemCount: suggestionList.length,
      itemBuilder: (context, index) {
        final item = suggestionList[index];

        return ListTile(
          title: Text(item[0]), // Item name
          onTap: () {
            // Close the search and return selected item
            close(context, item[0]);
          },
        );
      },
    );
  }
}
