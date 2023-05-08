import 'dart:io';
import 'package:flutter/material.dart';
import 'package:exercise_1/class/bill.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:intl/intl.dart';
import 'package:exercise_1/class/dateFormatter.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../context/myProvider.dart';

class editProductScreen extends StatefulWidget {
  final String id;
  static Future<dynamic> navigate(BuildContext context, String id) async {
    return Navigator.of(context)
        .push(MaterialPageRoute(builder: (_) => editProductScreen(id: id)));
  }

  editProductScreen({required this.id});
  @override
  State<editProductScreen> createState() => _editProductScreenState();
}

class _editProductScreenState extends State<editProductScreen> {
  final _formKey = new GlobalKey<FormState>();
  TextEditingController ngay = TextEditingController();
  TextEditingController loai = TextEditingController();
  TextEditingController ghi_chu = TextEditingController();
  TextEditingController so_tien = TextEditingController();
  List<String> list1 = <String>[];
  List<String> list2 = <String>[];
  Bill bill = Bill('', 0, '', '', '');
  @override
  void initState() {
    super.initState();
    // TODO: implement initState
    getListSpendingIncome();
    getData();
  }

  Future<void> getData() async {
    await getDatafromFireBase(widget.id);
    ngay.text = bill.date;
    loai.text = bill.noi_dung;
    ghi_chu.text = bill.ghi_chu;
    so_tien.text = bill.tien.toString();
  }

  Future<void> getListSpendingIncome() async {
    final docAccount = FirebaseFirestore.instance.collection('types');
    final snapshot = await docAccount.get();
    if (snapshot.docs.isNotEmpty) {
      final data = snapshot.docs.first.data();
      if (data.containsKey('income')) {
        list2 = data['income'].values.cast<String>().toList();
      }
      if (data.containsKey('spending')) {
        list1 = data['spending'].values.cast<String>().toList();
      }
    }
  }

  Future<void> saveDataToFirebase(
      String type, String date, String content, int money) async {
    final docAccount = FirebaseFirestore.instance.collection('bills');
    final querySnapshot = await docAccount
        .where('accountID',
            isEqualTo:
                Provider.of<MyProvider>(context, listen: false).accountID)
        .get();
    final newItem = {
      'type': type,
      'money': money,
      'content': content,
      'date': date,
    };
    if (querySnapshot.docs.isNotEmpty) {
      final docRef = querySnapshot.docs.first.reference;
      //print (docRef);
      Map<String, dynamic> data = querySnapshot.docs.first.data();
      Map<String, dynamic> items = data['items'][widget.id];
      final itemKey = items.keys.first;
      items[itemKey]['date'] = date;
      items[itemKey]['type'] = type;
      items[itemKey]['content'] = content;
      items[itemKey]['money'] = money;
      await docRef.update({
        'items.${widget.id}': items,
      });
    } else {
      final newDocRef = await docAccount.add({
        'accountID': Provider.of<MyProvider>(context, listen: false).accountID,
        'items': {'items.${DateTime.now().toString()}': newItem},
      });
      Provider.of<MyProvider>(context, listen: false).setBillID(newDocRef.id);
    }
    //await widget.callback;
    Navigator.pop(
      context,
    );
  }

  Future<void> getDatafromFireBase(String id) async {
    final docAccount = FirebaseFirestore.instance.collection('bills');
    final querySnapshot = await docAccount
        .where('accountID',
            isEqualTo:
                Provider.of<MyProvider>(context, listen: false).accountID)
        .get();
    if (querySnapshot.docs.isNotEmpty) {
      final docSnapshot = querySnapshot.docs.first;
      final data = docSnapshot.data();
      if (data.containsKey('items')) {
        final items = data['items'];
        List<dynamic> itemsToRemove = [];
        items.forEach((key, value) {
          if (key == id) {
            print(value);
            value.forEach((key, value) {
              bill = Bill(value['type'], value['money'], value['content'],
                  value['date'], id);

              return;
            });
          }
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: const Text('Sửa sản phẩm'),
          backgroundColor: const Color(0xFF00aaf7),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              // widget.callback;
              Navigator.pop(
                context,
              );
            },
          ),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.only(top: 20),
              width: MediaQuery.of(context).size.width,
              height: 100,
              decoration: const BoxDecoration(
                color: Color(0xFF00aaf7),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(
                      20.0), // thiết lập bán kính cho góc dưới trái
                  topRight: Radius.circular(
                      20.0), // thiết lập bán kính cho góc dưới phải
                ),
                // các thuộc tính khác của BoxDecoration
              ),
              child: Row(children: [
                Container(
                  margin: EdgeInsets.only(left: 15),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Image.asset('lib/assets/profile.png',
                      fit: BoxFit.contain, width: 40, height: 40),
                ),
                Container(
                  margin: EdgeInsets.only(left: 15),
                  child: const Text(
                    'Nhập đầy đủ thông tin cho hóa đơn của bạn',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                ),
              ]),
            ),
            Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(
                        20.0), // thiết lập bán kính cho góc dưới trái
                    bottomRight: Radius.circular(
                        20.0), // thiết lập bán kính cho góc dưới phải
                  ),
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
                      Center(
                        child: Form(
                          key: _formKey,
                          child: SafeArea(
                            child: Column(
                              children: [
                                Container(
                                  margin: const EdgeInsets.only(
                                      left: 15, right: 15, bottom: 10),
                                  child: TextFormField(
                                    controller: so_tien,
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      labelText: 'Số tiền',
                                      suffixIcon: Icon(Icons.money),
                                    ),
                                    keyboardType: TextInputType.number,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Vui lòng nhập số tiền';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                                Container(
                                  margin: const EdgeInsets.only(
                                      left: 15, right: 15, bottom: 10),
                                  child: TextFormField(
                                    controller: ngay,
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      labelText: 'Ngày',
                                      suffixIcon: GestureDetector(
                                        onTap: () async {
                                          DateTime? picked =
                                              await showDatePicker(
                                            context: context,
                                            initialDate: DateTime.now(),
                                            firstDate: DateTime(2020),
                                            lastDate: DateTime(2030),
                                          );
                                          if (picked != null) {
                                            setState(() {
                                              ngay.text =
                                                  DateFormat('dd/MM/yyyy')
                                                      .format(picked);
                                            });
                                          }
                                        },
                                        child: Icon(Icons.calendar_today),
                                      ),
                                    ),
                                    keyboardType: TextInputType.number,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Vui lòng nhập ngày';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                                Container(
                                  margin: const EdgeInsets.only(
                                      left: 15, right: 15, bottom: 10),
                                  child: TextFormField(
                                    controller: loai,
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      labelText: 'Loại',
                                      suffixIcon: GestureDetector(
                                        onTap: () {
                                          showModalBottomSheet(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return _buildBottomSheet(
                                                  list1, list2, (index) {
                                                setState(() {
                                                  loai.text = list1[index];
                                                });
                                                Navigator.pop(context);
                                              }, (index) {
                                                setState(() {
                                                  loai.text = list2[index];
                                                });
                                                Navigator.pop(context);
                                              });
                                            },
                                          );
                                        },
                                        child: Icon(
                                          Icons.list_alt_outlined,
                                          size: 30,
                                        ),
                                      ),
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Vui lòng nhập loại';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                                Container(
                                  margin: const EdgeInsets.only(
                                      left: 15, right: 15, bottom: 10),
                                  child: TextFormField(
                                    controller: ghi_chu,
                                    maxLines: null,
                                    maxLength: 500,
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      labelText: 'Ghi chú',
                                      suffixIcon: GestureDetector(
                                        onTap: () {
                                          // Xử lý sự kiện khi bấm vào icon
                                        },
                                        child: Icon(
                                          Icons.edit_note_outlined,
                                          size: 30,
                                        ),
                                      ),
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Vui lòng nhập ghi chú';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15),
                                  child: Center(
                                    child: ElevatedButton(
                                      onPressed: () {
                                        if (_formKey.currentState!.validate()) {
                                          saveDataToFirebase(
                                              loai.text,
                                              ngay.text,
                                              ghi_chu.text,
                                              int.parse(so_tien.text));
                                        } else {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            const SnackBar(
                                                content:
                                                    Text('Please fill input')),
                                          );
                                        }
                                      },
                                      style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.all<Color>(
                                            Colors.blue,
                                          ),
                                          minimumSize:
                                              MaterialStateProperty.all(
                                                  const Size(
                                                      double.infinity, 48))),
                                      child: const Text('Hoàn thành',
                                          style:
                                              TextStyle(color: Colors.white)),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                )),
          ],
        ));
  }
}

Widget _buildBottomSheet(List<String> list1, List<String> list2,
    Function(int x) onClick, Function(int x) onClick2) {
  return DefaultTabController(
    length: 2,
    child: Column(
      children: <Widget>[
        const TabBar(
          labelColor: Color(0xFF00aaf7),
          tabs: <Widget>[
            Tab(text: "Chi tiêu"),
            Tab(text: "Thu nhập"),
          ],
        ),
        Expanded(
          child: TabBarView(
            children: <Widget>[
              GridView.count(
                crossAxisCount: 2, // số cột
                crossAxisSpacing: 8.0, // khoảng cách giữa các cột
                mainAxisSpacing: 8.0,
                childAspectRatio: 4.5,
                children: List.generate(list1.length, (index) {
                  return GestureDetector(
                    onTap: () {
                      onClick(index);
                    },
                    child: ListTile(
                      leading: Image.asset('lib/assets/home.png',
                          fit: BoxFit.cover,
                          width: 28,
                          height: 28), // icon bên trái
                      title: Text(list1[index]), // nội dung item
                      // icon bên phải
                    ),
                  );
                }),
              ),
              GridView.count(
                crossAxisCount: 2, // số cột
                crossAxisSpacing: 8.0, // khoảng cách giữa các cột
                mainAxisSpacing: 8.0,
                childAspectRatio: 4.5,
                children: List.generate(list2.length, (index) {
                  return GestureDetector(
                    onTap: () {
                      onClick2(index);
                    },
                    child: ListTile(
                      leading: Image.asset('lib/assets/home.png',
                          fit: BoxFit.cover,
                          width: 28,
                          height: 28), // icon bên trái
                      title: Text(list2[index]), // nội dung item
                      // icon bên phải
                    ),
                  );
                }),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
