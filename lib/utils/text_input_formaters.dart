import 'package:flutter/services.dart';
import 'strings.dart';
import 'dart:math' as math;

class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    return TextEditingValue(
      text: newValue.text.toUpperCase(),
      selection: newValue.selection,
    );
  }
}

class CapitalizeTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    return TextEditingValue(
      text: capitalized(newValue.text),
      selection: newValue.selection,
    );
  }
}

class MaskedTextInputFormatter extends TextInputFormatter {
  final String mask;
  final String separator;

  MaskedTextInputFormatter({
    required this.mask,
    required this.separator,
  }):super();

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    if(newValue.text.length > 0) {
      if(newValue.text.length > oldValue.text.length) {
        if(newValue.text.length > mask.length) return oldValue;
        if(newValue.text.length < mask.length && mask[newValue.text.length - 1] == separator) {
          return TextEditingValue(
            text: '${oldValue.text}$separator${newValue.text.substring(newValue.text.length-1)}',
            selection: TextSelection.collapsed(
              offset: newValue.selection.end + 1,
            ),
          );
        }
      }
    }
    return newValue;
  }
}

class DecimalTextInputFormatter extends TextInputFormatter {
  DecimalTextInputFormatter({required this.decimalRange})
      : assert(decimalRange > 0);

  final int decimalRange;

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue, // unused.
    TextEditingValue newValue,
  ) {
    TextSelection newSelection = newValue.selection;
        
    String value = newValue.text.replaceAll(',', '.');
    
    value = value.replaceAll(RegExp(r'[^0-9.]'), "");
    value = value.replaceAllMapped(".", (match) {
      return match.start == value.indexOf(".") ? "." : "";
    });
    
    if (value.contains(".") && value.substring(value.indexOf(".") + 1).length > decimalRange) {
      value = oldValue.text;
      newSelection = oldValue.selection;
    } else if (value == ".") {
      value = "0.";

      newSelection = newValue.selection.copyWith(
        baseOffset: math.min(value.length, value.length + 1),
        extentOffset: math.min(value.length, value.length + 1),
      );
    }

    return TextEditingValue(
      text: value,
      selection: newSelection,
      composing: TextRange.empty,
    );    
  }
}
