import 'package:flutter/material.dart';
import 'package:project3/screens/manager/Tab_Items.dart';
import 'package:project3/screens/supplier/Approved_Quot.dart';
import 'package:project3/screens/supplier/Sended_quot.dart';
import 'package:project3/screens/supplier/Unsended_quot.dart';

class viewAllQuotation extends StatelessWidget {
  final String username;

  const viewAllQuotation({Key? key, required this.username}) : super(key: key);

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
                'Quotations',
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
                      TabItem(title: 'NOT SEND', count: 0,),
                      TabItem(title: 'SEND', count: 0),
                      TabItem(title: 'APPROVED', count: 0),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        body: TabBarView(
          children: [
            Center(child: Unsended_quot(username: username)),
            Center(child: Sended_quot(username: username)),
            Center(child: Approved_Quot(username: username)),
          ],
        ),
      ),
    );
  }
}
