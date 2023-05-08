import 'dart:io';
import 'package:flutter/material.dart';
import 'package:exercise_1/class/bill.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:exercise_1/screen/userInfoScreen.dart';
import 'package:intl/intl.dart';
import 'package:exercise_1/main.dart';

class Setting extends StatefulWidget {
  const Setting({super.key});

  @override
  State<Setting> createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  String selectedValue = 'VND';

  List<String> dropdownItems = [
    'VND',
    'USD',
  ];
  bool _isSwitched = false;
  bool hideMoney = true;
  TimeOfDay _selectedTime = TimeOfDay.now();
  TextEditingController _timeController = TextEditingController();
  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
        builder: (BuildContext context, Widget? child) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
            child: child!,
          );
        });

    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
        final formattedTime = DateFormat.Hm()
            .format(DateTime(2021, 1, 1, picked.hour, picked.minute));
        _timeController.text = formattedTime;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
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
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const UserInformation()));
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(50),
                            ),
                            child: Image.asset('lib/assets/profile.png',
                                fit: BoxFit.contain, width: 60, height: 60),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 10),
                          child: const Text(
                            'User',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ]),
                ),
                Container(
                  margin: EdgeInsets.only(left: 10),
                  child: Text('Cài đặt chung',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 20,
                      )),
                ),
                Container(
                    margin: const EdgeInsets.only(top: 10),
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  children: [
                                    Container(
                                      margin: const EdgeInsets.only(left: 15),
                                      child: GestureDetector(
                                        onTap: () {
                                          _selectTime(context);
                                        },
                                        child: const Text(
                                          'Nhắc nhở hàng ngày',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      child: SizedBox(
                                        width: 100,
                                        child: TextField(
                                          controller: _timeController,
                                          readOnly: true,
                                          decoration: InputDecoration(
                                            border: InputBorder.none,
                                            focusedBorder: InputBorder.none,
                                            enabledBorder: InputBorder.none,
                                            errorBorder: InputBorder.none,
                                            disabledBorder: InputBorder.none,
                                            contentPadding: EdgeInsets.zero,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Container(
                                  child: Switch(
                                    value: _isSwitched,
                                    onChanged: (value) {
                                      setState(() {
                                        _isSwitched = value;
                                      });
                                    },
                                  ),
                                )
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  margin: const EdgeInsets.only(left: 15),
                                  child: const Text(
                                    'Đơn vị tiền tệ',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(right: 15),
                                  child: DropdownButton<String>(
                                    value: selectedValue,
                                    items: dropdownItems.map((String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value),
                                      );
                                    }).toList(),
                                    onChanged: (newValue) {
                                      setState(() {
                                        selectedValue = newValue!;
                                      });
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ]),
                    )),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                  child: Center(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const Login()));
                      },
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                            Colors.red,
                          ),
                          minimumSize: MaterialStateProperty.all(
                              const Size(double.infinity, 48))),
                      child: const Text('Đăng xuất',
                          style: TextStyle(color: Colors.white)),
                    ),
                  ),
                ),
              ]),
            ],
          ),
        ));
  }
}
