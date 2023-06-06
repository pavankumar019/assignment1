import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ScreenUpdate extends ChangeNotifier {
  bool update = true;

  setValue() {
    update = false;
  }

  changeValue(bool value) {
    update = value;
    notifyListeners();
  }
}
