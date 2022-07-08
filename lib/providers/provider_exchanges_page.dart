import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:trade/models/model_trade_request.dart';

class ProviderExchangesPage with ChangeNotifier {
  ///[itemIDsFromYou] is null at the first to see if User Data is already loaded or not.
  List<Map>? itemIDsFromYou;
  List<ModelTradeRequest>? tradeRequests;

  void updateItemIDsFromYou(List<Map> items, bool notify) {
    List<Map> list = itemIDsFromYou ?? [];
    list += items;
    itemIDsFromYou = list;
    if (notify) notifyListeners();
  }

  bool checkExistingFromYouIDs(String id) {
    return itemIDsFromYou?.contains(id) ?? false;
  }

  void updateAll(Map? values) {
    if (values == null) {
      itemIDsFromYou = [];
      notifyListeners();
      return;
    }

    itemIDsFromYou = values['itemIDsFromYou']?.cast<String>();

    notifyListeners();
  }

  void updateTradeRequests(
      List<QueryDocumentSnapshot<Map<String, dynamic>>>? docs) {
    if (docs == null) {
      tradeRequests = [];
      notifyListeners();
      return;
    }

    tradeRequests ??= [];

    for (var element in docs) {
      tradeRequests!.add(ModelTradeRequest.fromJson(element.data()));
    }

    notifyListeners();
  }
}
