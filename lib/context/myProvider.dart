import 'package:flutter/foundation.dart';
import 'package:exercise_1/class/bill.dart';

class MyProvider with ChangeNotifier {
  String _accountID = '';
  String _billID = '';
  String get accountID => _accountID;
  String get billID => _billID;
  List<Bill> _bills = <Bill>[]; // List of bills
  List<Bill> get bills => _bills;

  void setBills(List<Bill> newBills) {
    _bills = newBills;
    notifyListeners();
  }

  void setAccountID(String newValue) {
    _accountID = newValue;
    notifyListeners();
  }

  void setBillID(String newValue) {
    _billID = newValue;
    notifyListeners();
  }
}
