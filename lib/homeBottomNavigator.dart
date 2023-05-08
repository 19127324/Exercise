import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:exercise_1/screen/homeScreen.dart';
import 'package:exercise_1/screen/addProductScreen.dart';
import 'package:exercise_1/screen/analysisScreen.dart';
import 'package:exercise_1/screen/history.dart';
import 'package:exercise_1/screen/settingScreen.dart';
import 'package:provider/provider.dart';
import 'dart:ui';
import 'class/bill.dart';
import 'class/history.dart';
import 'context/myProvider.dart';
import 'package:intl/intl.dart';

class homeBottomNavigator extends StatefulWidget {
  const homeBottomNavigator({super.key});

  @override
  _homeBottomNavigatorState createState() => _homeBottomNavigatorState();
}

class _homeBottomNavigatorState extends State<homeBottomNavigator>
    with TickerProviderStateMixin {
  late TabController _tabController;
  List<Bill> _bills = <Bill>[];
  List<HistoryClass> _history = <HistoryClass>[];
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
    getData();
  }

  Future<void> getData() async {
    await getDatafromFireBase();
    await getHistoryDatafromFireBase();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  String convertDate(String dateStr) {
    // return DateFormat("yyyy-MM-dd").format(DateTime.parse(dateStr));
    List<String> dateParts = dateStr.split('/');

    DateTime date = DateTime(int.parse(dateParts[2]), int.parse(dateParts[1]),
        int.parse(dateParts[0]));

    return "${date.year.toString()}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
  }

  Future<void> getDatafromFireBase() async {
    final docAccount = FirebaseFirestore.instance.collection('bills');
    final querySnapshot = await docAccount
        .where('accountID',
            isEqualTo:
                Provider.of<MyProvider>(context, listen: false).accountID)
        .get();
    if (querySnapshot.docs.isNotEmpty) {
      List<Bill> _preBill = _bills;
      _bills.clear();
      final docSnapshot = querySnapshot.docs.first;
      final data = docSnapshot.data();
      if (data.containsKey('items')) {
        final items = data['items'];
        items.forEach((key, value) {
          if (key == 'item_1') return;

          var id = key.toString();

          DateTime now = DateTime.now();

          value.forEach((key, value) {
            if (convertDate(value['date']) == now.toString().substring(0, 10)) {
              final newBill = Bill(
                value['type'],
                value['money'],
                value['content'],
                value['date'],
                id,
              );
              _bills.add(newBill);
            }
          });
        });
      }
    } else {
      final newItem = {
        'type': '',
        'money': 0,
        'content': '',
        'date': '',
      };
      final newDocRef = await docAccount.add({
        'accountID': Provider.of<MyProvider>(context, listen: false).accountID,
        'items': {'item_1': newItem},
      });
      Provider.of<MyProvider>(context, listen: false).setBillID(newDocRef.id);
    }
    _bills.sort((a, b) => a.date.compareTo(b.date));
    // Provider.of<MyProvider>(context, listen: false).setBills(_bills);
    // print(Provider.of<MyProvider>(context, listen: false).bills.length);
    setState(() {});
  }

  Future<void> getHistoryDatafromFireBase() async {
    List<Bill> tmp = <Bill>[];
    final docAccount = FirebaseFirestore.instance.collection('bills');
    final querySnapshot = await docAccount
        .where('accountID',
            isEqualTo:
                Provider.of<MyProvider>(context, listen: false).accountID)
        .get();
    if (querySnapshot.docs.isNotEmpty) {
      tmp.clear();
      final docSnapshot = querySnapshot.docs.first;
      final data = docSnapshot.data();
      if (data.containsKey('items')) {
        final items = data['items'];
        items.forEach((key, value) {
          if (key == 'item_1') return;

          var id = key.toString();

          DateTime now = DateTime.now();

          value.forEach((key, value) {
            if (convertDate(value['date']) != now.toString().substring(0, 10)) {
              final newBill = Bill(
                value['type'],
                value['money'],
                value['content'],
                value['date'],
                id,
              );
              tmp.add(newBill);
            }
          });
        });
      }
    } else {
      final newItem = {
        'type': '',
        'money': 0,
        'content': '',
        'date': '',
      };
      final newDocRef = await docAccount.add({
        'accountID': Provider.of<MyProvider>(context, listen: false).accountID,
        'items': {'item_1': newItem},
      });
      Provider.of<MyProvider>(context, listen: false).setBillID(newDocRef.id);
    }
    tmp.sort((a, b) => a.date.compareTo(b.date));
    _history.clear();
    for (var element in tmp) {
      if (_history.length == 0) {
        _history.add(HistoryClass(element.date, [element]));
      } else {
        bool check = false;
        _history.forEach((element1) {
          if (element1.ngay == element.date) {
            element1.bill.add(element);
            check = true;
          }
        });
        if (check == false) {
          _history.add(HistoryClass(element.date, [element]));
        }
      }
    }
    // Provider.of<MyProvider>(context, listen: false).setBills(_bills);
    // print(Provider.of<MyProvider>(context, listen: false).bills.length);
    print("goi");
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: TabBarView(
        controller: _tabController,
        children: [
          Center(
              child: Home(
            bills: _bills,
            callback: getDatafromFireBase(),
          )),
          Center(
              child: History(
            histories: _history,
            callback: getHistoryDatafromFireBase(),
          )),
          Center(),
          Center(child: Analysis()),
          Center(child: Setting()),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        shape: const CircularNotchedRectangle(),
        notchMargin: 6,
        child: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(icon: Icon(Icons.home)),
            Tab(
                icon: Icon(
              Icons.history,
            )),
            SizedBox.shrink(),
            Tab(
                icon: Icon(
              Icons.bar_chart_outlined,
            )),
            Tab(
              icon: Icon(
                Icons.settings,
              ),
            )
          ],
          indicator: const BoxDecoration(color: Colors.transparent),
          unselectedLabelColor: Colors.grey,
          labelColor: const Color(0xFF00aaf7),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          print("vô");
          addProductScreen.navigate(context).then(
              (value) => {getDatafromFireBase(), getHistoryDatafromFireBase()});
          ;
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
