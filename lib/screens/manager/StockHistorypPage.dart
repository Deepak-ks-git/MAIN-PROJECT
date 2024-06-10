import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:project3/screens/manager/ItemHistory.dart';

class StockHistoryPage extends StatefulWidget {
  const StockHistoryPage({Key? key}) : super(key: key);

  @override
  State<StockHistoryPage> createState() => _StockHistoryPageState();
}

class _StockHistoryPageState extends State<StockHistoryPage> {
  List<dynamic> itemStockList = [];
  List<dynamic> filteredItemList = [];
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
          filteredItemList = List.from(itemStockList);
        });
      } else {
        print('Failed to load item stock list: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching item stock list: $e');
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
        actions: [
          IconButton(
            onPressed: () {
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
                    'InStock',
                    style: TextStyle(color: Color.fromARGB(255, 116, 160, 192), fontWeight: FontWeight.bold),
                  ),
                  trailing: Text(
                    '${item[2]}', // Display stock level
                    style: TextStyle(color: Color.fromARGB(255, 11, 214, 68), fontWeight: FontWeight.bold,fontSize: 16),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ItemDetailPage(itemId: item[1]),
                      ),
                    );
                  },
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
    return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final List<dynamic> suggestionList = query.isEmpty
        ? itemStockList
        : itemStockList.where((item) {
            final itemName = item[0].toLowerCase();
            return itemName.contains(query.toLowerCase());
          }).toList();

    return ListView.builder(
      itemCount: suggestionList.length,
      itemBuilder: (context, index) {
        final item = suggestionList[index];

        return ListTile(
          title: Text(item[0]),
          onTap: () {
            close(context, item[0]);
          },
        );
      },
    );
  }
}
