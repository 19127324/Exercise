import 'package:flutter/services.dart';

class _DateFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final formattedValue = _formatDate(newValue.text);
    return TextEditingValue(
      text: formattedValue,
      selection: TextSelection.collapsed(offset: formattedValue.length),
    );
  }

  String _formatDate(String input) {
    if (input.isEmpty) return '';

    var numbers = input.replaceAll(RegExp('[^0-9]'), '');
    if (numbers.length > 8) {
      numbers = numbers.substring(0, 8);
    }

    final day = numbers.length >= 2 ? numbers.substring(0, 2) : '';
    final month = numbers.length >= 4 ? numbers.substring(2, 4) : '';
    final year = numbers.length >= 8 ? numbers.substring(4, 8) : '';

    final parts =
        <String>[day, month, year].where((e) => e.isNotEmpty).toList();

    return parts.join('/');
  }
}
