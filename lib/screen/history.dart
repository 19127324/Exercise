import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:exercise_1/class/history.dart';
import 'package:flutter/material.dart';
import 'package:exercise_1/class/bill.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:exercise_1/screen/userInfoScreen.dart';
import 'package:exercise_1/screen/editProductScreen.dart';
import 'package:provider/provider.dart';

import '../context/myProvider.dart';

class History extends StatefulWidget {
  const History({super.key, required this.histories, required this.callback});
  final List<HistoryClass> histories;
  final Future<void> callback;
  @override
  State<History> createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  List<HistoryClass> _history = <HistoryClass>[];
  final TextEditingController _searchQueryController = TextEditingController();
  @override
  void initState() {
    super.initState();
  }

  void search(String tmp) {
    if (tmp == "") {
      setState(() {
        _history.clear();
      });
      return;
    } else {
      setState(() {
        _history = widget.histories.fold<List<HistoryClass>>(<HistoryClass>[],
            (previousValue, history) {
          final bills = history.bill
              .where((bill) =>
                  bill.noi_dung.toLowerCase().contains(tmp.toLowerCase()) ||
                  bill.ghi_chu.toLowerCase().contains(tmp.toLowerCase()))
              .toList();
          if (bills.isNotEmpty) {
            previousValue.add(HistoryClass(
              history.ngay,
              bills,
            ));
          }
          return previousValue;
        });
      });
    }
  }

  bool hideMoney = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(children: [
                Container(
                  margin: EdgeInsets.only(bottom: 20),
                  width: MediaQuery.of(context).size.width,
                  height: 110,
                  decoration: const BoxDecoration(
                    color: Color(0xFF00aaf7),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(
                          20.0), // thiết lập bán kính cho góc dưới trái
                      bottomRight: Radius.circular(
                          20.0), // thiết lập bán kính cho góc dưới phải
                    ),
                    // các thuộc tính khác của BoxDecoration
                  ),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: EdgeInsets.only(left: 15, top: 10),
                          child: const Text(
                            'Lịch sử giao dịch',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: TextField(
                            controller: _searchQueryController,
                            decoration: InputDecoration(
                              hintText: 'Tìm kiếm',
                              border: InputBorder.none,
                              prefixIcon: Icon(Icons.search),
                            ),
                            onChanged: (tmp) {
                              search(tmp);
                            },
                          ),
                        )
                      ]),
                )
              ]),
              Flexible(
                  fit: FlexFit.loose,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(8.0),
                    reverse: false,
                    itemBuilder: (_, int index) => _buildHistory(
                        _history.isEmpty
                            ? widget.histories[index]
                            : _history[index],
                        context,
                        widget.callback),
                    itemCount: _history.isEmpty
                        ? widget.histories.length
                        : _history.length,
                  )),
            ],
          ),
        ));
  }
}

Widget _buildHistory(
    HistoryClass history, BuildContext context, Future<void> callback) {
  return Container(
    margin: EdgeInsets.only(left: 15, bottom: 10),
    padding: EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 10),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: Colors.black, width: 1),
    ),
    child: Column(
      children: [
        Container(
          margin: EdgeInsets.only(bottom: 10),
          child: Text(
            history.ngay,
            style: TextStyle(
                color: Colors.orange,
                fontSize: 12,
                fontStyle: FontStyle.italic),
          ),
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: ClampingScrollPhysics(),
          itemCount: history.bill.length,
          itemBuilder: (context, index) {
            return _buildBill(history.bill[index], context, callback);
          },
        ),
      ],
    ),
  );
}

Widget _buildBill(Bill bill, BuildContext context, Future<void> callback) {
  return Stack(children: [
    Container(
      height: 80,
      margin: const EdgeInsets.only(left: 15, right: 15, bottom: 10),
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.black, width: 1),
      ),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Container(
                margin: const EdgeInsets.only(top: 5, left: 45),
                child: Text(
                  bill.noi_dung,
                  style: TextStyle(fontSize: 20),
                )),
            Container(
                margin: const EdgeInsets.only(top: 5, left: 45),
                child: Text(
                  bill.tien.toString() + ' VND',
                  style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
                )),
            Container(
                margin: const EdgeInsets.only(top: 5, left: 45),
                child: Text(
                  bill.ghi_chu,
                  style: TextStyle(fontSize: 10),
                )),
          ],
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.only(top: 5),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => {
                      print("click"),
                      handlEditBill(bill.id, context, callback),
                    },
                    child: Icon(
                      Icons.edit_outlined,
                      color: Color(0xFF00aaf7),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => {
                      handleDeleteBill(bill.id, context),
                      callback,
                    },
                    child: Icon(
                      Icons.delete_outline,
                      color: Colors.red,
                    ),
                  ),
                ],
              ),
            ),
            Container(
                margin: const EdgeInsets.only(top: 5, right: 15, bottom: 3),
                child: Text(
                  bill.ngay,
                  style: TextStyle(fontSize: 10),
                )),
          ],
        )
      ]),
    ),
    Container(
      margin: EdgeInsets.only(top: 18),
      child: Stack(children: [
        Container(
          height: 50,
          width: 50,
          decoration: BoxDecoration(
            color: Color(0xFF00aaf7),
            borderRadius: BorderRadius.circular(25),
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: 10, left: 10),
          child: Image.asset('lib/assets/home.png',
              fit: BoxFit.cover, width: 28, height: 28),
        ),
      ]),
    )
  ]);
}

void handlEditBill(String id, BuildContext context, Future<void> callback) {
  editProductScreen.navigate(context, id).then((value) => {callback});
}

void handleDeleteBill(String id, BuildContext context) async {
  final docAccount = FirebaseFirestore.instance.collection('bills');
  final querySnapshot = await docAccount
      .where('accountID',
          isEqualTo: Provider.of<MyProvider>(context, listen: false).accountID)
      .get();
  if (querySnapshot.docs.isNotEmpty) {
    final docSnapshot = querySnapshot.docs.first;
    final data = docSnapshot.data();
    if (data.containsKey('items')) {
      final items = data['items'];
      List<dynamic> itemsToRemove = [];
      items.forEach((key, value) {
        if (key == id) {
          itemsToRemove.add(key);
        }
      });
      itemsToRemove.forEach((item) {
        items.remove(item);
      });
      await docSnapshot.reference.update({'items': items});
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Bill deleted')),
      );
    }
  }
}
