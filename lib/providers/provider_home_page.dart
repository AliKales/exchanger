import 'package:flutter/material.dart';
import 'package:trade/models/model_item.dart';

class ProviderHomePage with ChangeNotifier {
  List<ModelItem> items = [];

  void updateItems(List<ModelItem> _items) {
    items += _items;
    notifyListeners();
  }
}
