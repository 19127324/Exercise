import 'dart:io';
import 'package:flutter/material.dart';
import 'package:exercise_1/class/bill.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:intl/intl.dart';
import 'package:exercise_1/class/dateFormatter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class UserInformation extends StatefulWidget {
  const UserInformation({super.key});

  @override
  State<UserInformation> createState() => _UserInformationState();
}

class _UserInformationState extends State<UserInformation> {
  final _formKey = new GlobalKey<FormState>();
  TextEditingController ten = TextEditingController();
  TextEditingController mo_ta = TextEditingController();

  @override
  void initState() {
    super.initState();
    // TODO: implement initState
  }

  PickedFile? _image;

  Future<void> _getImage() async {
    final permissionStatus = await Permission.storage.request();
    if (permissionStatus.isGranted) {
      final pickedImage =
          await ImagePicker().pickImage(source: ImageSource.gallery);
      if (pickedImage != null) {
        setState(() {
          _image = PickedFile(pickedImage.path);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: const Text('Thông tin cá nhân'),
          backgroundColor: const Color(0xFF00aaf7),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: _getImage,
                  child: Container(
                    margin: const EdgeInsets.only(top: 20, bottom: 40),
                    width: 150.0,
                    height: 150.0,
                    child: ClipOval(
                        child: _image != null
                            ? Image.file(
                                File(_image!.path),
                                fit: BoxFit.cover,
                              )
                            : Image.asset(
                                'lib/assets/profile.png',
                                fit: BoxFit.cover,
                              )),
                  ),
                )
              ],
            ),
            Container(
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
                                controller: ten,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  labelText: 'Tên',
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Vui lòng nhập tên';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(
                                  left: 15, right: 15, bottom: 10),
                              child: TextFormField(
                                controller: mo_ta,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  labelText: 'Mô tả',
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Vui lòng nhập mô tả';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 20),
                              child: Center(
                                child: ElevatedButton(
                                  onPressed: () {
                                    if (_formKey.currentState!.validate()) {
                                      print("click");
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                            content: Text('Please fill input')),
                                      );
                                    }
                                  },
                                  style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all<Color>(
                                        Colors.blue,
                                      ),
                                      minimumSize: MaterialStateProperty.all(
                                          const Size(double.infinity, 48))),
                                  child: const Text('Lưu thay đổi',
                                      style: TextStyle(color: Colors.white)),
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
            ),
          ],
        ));
  }
}
