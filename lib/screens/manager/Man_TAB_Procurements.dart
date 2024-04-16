import 'package:flutter/material.dart';
import 'package:project3/screens/manager/BlacklistedSuppliers.dart';
import 'package:project3/screens/manager/Man_New_Procurements.dart';
import 'package:project3/screens/manager/Man_OnGoing_Procurements.dart';
import 'package:project3/screens/manager/Tab_Items.dart';


class Man_TAB_Procurements extends StatelessWidget {
  const Man_TAB_Procurements({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            ' Procurements',
            style: TextStyle(fontSize: 16),
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
                      TabItem(title: 'ON-GOING', count: 0),
                      TabItem(title: 'COMPLETED', count: 0),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        body: const TabBarView(
          children: [
            Center(child: Man_New_Procurements()),
            Center(child: Man_OnGoing_Procurements()),
            Center(child: BlacklistedSuppliers()),
          ],
        ),
      ),
    );
  }
}
