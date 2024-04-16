import 'package:flutter/material.dart';
import 'package:project3/screens/manager/Tab_Items.dart';
import 'package:project3/screens/supplier/Accepted_Request.dart';
import 'package:project3/screens/supplier/New_Request.dart';
import 'package:project3/screens/supplier/Rejected_Request.dart';

class Request_Tab extends StatelessWidget {
  final String username;

  const Request_Tab({Key? key, required this.username}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Purchase Requests',
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
          centerTitle: true,
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(40),
            child: Padding(
              padding: const EdgeInsets.only(bottom: 8.0), // Add padding here
              child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                child: Container(
                  height: 40,
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    color: Color.fromARGB(255, 233, 233, 240),
                  ),
                  child: const TabBar(
                    indicatorSize: TabBarIndicatorSize.tab,
                    dividerColor: Colors.transparent,
                    indicator: BoxDecoration(
                      color: Color.fromARGB(255, 1, 31, 100),
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    labelColor: Colors.white,
                    unselectedLabelColor: Colors.black54,
                    tabs: [
                      TabItem(title: 'NEW', count: 0,),
                      TabItem(title: 'ACCEPTED', count: 0),
                      TabItem(title: 'REJECTED', count: 0),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        body: TabBarView(
          children: [
            Center(child: New_Request(username: username)),
            Center(child: Accepted_Request(username: username)),
            Center(child: Rejected_Request(username: username)),
          ],
        ),
      ),
    );
  }
}
