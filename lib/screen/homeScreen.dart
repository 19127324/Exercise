import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:exercise_1/class/bill.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:exercise_1/screen/userInfoScreen.dart';
import 'package:exercise_1/context/myProvider.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:exercise_1/homeBottomNavigator.dart';
import 'package:exercise_1/screen/editProductScreen.dart';
import 'package:intl/intl.dart';

class Home extends StatefulWidget {
  const Home({super.key, required this.bills, required this.callback});
  final List<Bill> bills;
  final Future<void> callback;
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  //List<Bill> _bills = <Bill>[];
  double tong = 0;

  @override
  void initState() {
    super.initState();
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
                  height: 150,
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
                  child: Row(children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const UserInformation()));
                      },
                      child: Container(
                        margin: EdgeInsets.only(left: 15),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: Image.asset('lib/assets/profile.png',
                            fit: BoxFit.contain, width: 40, height: 40),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 15),
                      child: const Text(
                        'Xin chào bạn',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ]),
                ),
                Container(
                    margin:
                        const EdgeInsets.only(top: 100, bottom: 20, left: 55),
                    width: MediaQuery.of(context).size.width / 2 + 90,
                    height: 100,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Container(
                      margin: const EdgeInsets.only(top: 10, bottom: 10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Row(
                            children: [
                              Container(
                                margin: const EdgeInsets.only(left: 15),
                                child: Image.asset('lib/assets/calendar.png',
                                    fit: BoxFit.contain, width: 20, height: 20),
                              ),
                              Container(
                                margin: const EdgeInsets.only(left: 15),
                                child: Text(
                                  widget.bills.isNotEmpty
                                      ? widget.bills[0].date.toString()
                                      : "",
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(left: 110),
                                child: Icon(
                                  hideMoney
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                ),
                              ),
                            ],
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Container(
                              margin: const EdgeInsets.only(left: 15),
                              child: Text(
                                widget.bills.isNotEmpty
                                    ? "Tổng: ${NumberFormat("#,##0 VND", "vi_VN").format(widget.bills.fold(0, (previous, current) => previous + current.tien))}"
                                    : "",
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text(
                                'Thu nhập: 3.935.000 VND',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 10,
                                ),
                              ),
                              Text(
                                'Chi tiêu: 3.935.000 VND',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 10,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    )),
              ]),
              Container(
                margin: EdgeInsets.only(left: 15, bottom: 10),
                child: const Text(
                  'Hôm nay',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 12,
                      fontStyle: FontStyle.italic),
                ),
              ),
              Flexible(
                child: ListView.builder(
                  padding: const EdgeInsets.all(8.0),
                  itemCount: widget.bills.length,
                  itemBuilder: (_, int index) =>
                      _buildBill(widget.bills[index], context, widget.callback),
                ),
              )
            ],
          ),
        ));
  }
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
                  getType(bill.loai) == true
                      ? '+' + bill.tien.toString() + ' VND'
                      : '-' + bill.tien.toString() + ' VND',
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
                    onTap: () => {handlEditBill(bill.id, context, callback)},
                    child: Icon(
                      Icons.edit_outlined,
                      color: Color(0xFF00aaf7),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => {
                      handleDeleteBill(bill.id, context),
                      getType,
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

Future<bool> getType(String type) async {
  bool result = true;
  final docAccount = FirebaseFirestore.instance.collection('types');
  final querySnapshot = await docAccount.get();
  if (querySnapshot.docs.isNotEmpty) {
    final docSnapshot = querySnapshot.docs.first;
    final data = docSnapshot.data();
    if (data.containsKey("income")) {
      final items = data['income'];
      items.forEach((key, value) {
        if (value == type) result = true;
      });
    }
    if (data.containsKey("spending")) {
      final items = data['spending'];
      items.forEach((key, value) {
        if (value == type) result = false;
      });
    }
  }
  return result;
}

void handlEditBill(String id, BuildContext context, Future<void> callback) {
  //pass id to editProductScreen

  editProductScreen.navigate(context, id).then((value) => {callback});
}
