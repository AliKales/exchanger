import 'package:flutter/cupertino.dart';

class ProviderPageController with ChangeNotifier {
  int selectedPage = 0;

  int get getSelectedPage => selectedPage;

  void changePage(int index) {
    selectedPage = index;
    notifyListeners();
  }
}
