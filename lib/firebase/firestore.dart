import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trade/firebase/auth.dart';
import 'package:trade/funcs.dart';
import 'package:trade/models/model_item.dart';
import 'package:trade/models/model_trade_request.dart';
import 'package:trade/providers/provider_exchanges_page.dart';
import 'package:trade/providers/provider_home_page.dart';
import 'package:trade/simple_uis.dart';
import 'package:trade/values.dart';

class Firestore {
  static FirebaseFirestore firestore = FirebaseFirestore.instance;

  static Future<bool> uploadItem(
      {required context, required String doc, required ModelItem item}) async {
    try {
      SimpleUIs().showProgressIndicator(context);
      await Firestore.firestore.collection('items').doc(doc).set(item.toJson());

      Navigator.pop(context);
      return true;
    } on FirebaseException {
      Navigator.pop(context);
      Funcs().showSnackBar(context, "ERROR");
      return false;
    } catch (e) {
      Navigator.pop(context);
      Funcs().showSnackBar(context, "ERROR");
      return false;
    }
  }

  static Future loadItems({required context}) async {
    if (isLastItem) return;

    QuerySnapshot data;
    if (documentSnapshots.isEmpty) {
      data = await Firestore.firestore.collection("items").limit(1).get();
    } else {
      data = await Firestore.firestore
          .collection("items")
          .startAfterDocument(documentSnapshots.last)
          .limit(1)
          .get();
    }

    List<ModelItem> items = [];

    if (data.docs.isEmpty) {
      isLastItem = true;
      return;
    }

    for (var i = 0; i < data.docs.length; i++) {
      items
          .add(ModelItem.fromJson(data.docs[i].data() as Map<String, dynamic>));
    }

    documentSnapshots += data.docs;

    Provider.of<ProviderHomePage>(context, listen: false).updateItems(items);
  }

  static Future<bool> sendTradeRequest(
      {required context,
      required ModelItem rSenderItem,
      required ModelItem itemTaker}) async {
    try {
      SimpleUIs().showProgressIndicator(context);

      DateTime dt = Funcs().getGMTDateTimeNow();

      String id = Funcs().getIdByTime(dt);

      ModelTradeRequest tradeRequest = ModelTradeRequest(
        uploadDate: dt.toIso8601String(),
        rSenderId: Auth().getId(),
        rSenderName: Auth().getDisplayName(),
        rSenderItem: rSenderItem,
        tradeId: id,
        rTakerId: itemTaker.ownerId,
        rTakerItemId: itemTaker.itemId,
        rTakerName: itemTaker.ownerName,
      );

      await Firestore.firestore
          .collection('tradeRequest')
          .doc(id)
          .set(tradeRequest.toJson());

      await Firestore.firestore
          .collection("usersData")
          .doc(Auth().getId())
          .update({
        'itemIDsFromYou': FieldValue.arrayUnion([{'to':itemTaker.itemId,'fromYou':rSenderItem.toJson()}])
      });

      Navigator.pop(context);
      return true;
    } on FirebaseException catch (e) {
      if (e.code == "not-found") {
        bool result = await Firestore()
            ._sendTradeRequestUserData(context, itemTaker.itemId!);
        Navigator.pop(context);
        if (!result) Funcs().showSnackBar(context, "ERROR");
        return result;
      } else {
        Navigator.pop(context);
        Funcs().showSnackBar(context, "ERROR");
        return false;
      }
    } catch (e) {
      Navigator.pop(context);
      Funcs().showSnackBar(context, "ERROR");
      return false;
    }
  }

  Future<bool> _sendTradeRequestUserData(context, String id) async {
    try {
      await Firestore.firestore
          .collection("usersData")
          .doc(Auth().getId())
          .set({
        'itemIDsFromYou': [id]
      });
      return true;
    } on FirebaseException {
      return false;
    } catch (e) {
      return false;
    }
  }

  static Future getUserData({required context}) async {
    var snapshot = await Firestore.firestore
        .collection("usersData")
        .doc(Auth().getId())
        .get();

    if (snapshot.exists) {
      Provider.of<ProviderExchangesPage>(context, listen: false)
          .updateAll(snapshot.data());
    } else {
      Provider.of<ProviderExchangesPage>(context, listen: false)
          .updateAll(null);
    }
  }

  static Future getTradeRequests({required context}) async {
    if (isLastTradeRequest) return;

    QuerySnapshot<Map<String, dynamic>> snapshot;

    if (lastTradeSnapshot == null) {
      snapshot = await Firestore.firestore
          .collection("tradeRequest")
          .limit(5)
          .where('rTakerId', isEqualTo: Auth().getId())
          .get();
    } else {
      snapshot = await Firestore.firestore
          .collection("tradeRequest")
          .limit(5)
          .startAfterDocument(lastTradeSnapshot!)
          .where('rTakerId', isEqualTo: Auth().getId())
          .get();
    }

    if (snapshot.docs.isEmpty) {
      isLastTradeRequest = true;
      return;
    }

    lastTradeSnapshot = snapshot.docs.last;
    Provider.of<ProviderExchangesPage>(context, listen: false)
        .updateTradeRequests(snapshot.docs);
  }

  static Future<ModelItem?> getSingleItem({required context, required String id}) async {
    DocumentSnapshot? documentSnapshot;
    int index = documentSnapshots.indexWhere((element) => element.id == id);

    if (index != -1) documentSnapshot = documentSnapshots[index];

    if (documentSnapshot != null) {
      return ModelItem.fromJson(
          documentSnapshot.data() as Map<String, dynamic>);
    }

    var result = await Firestore.firestore.collection("items").doc(id).get();

    if (result.exists) {
      return ModelItem.fromJson(result.data() as Map<String, dynamic>);
    }

    return null;
  }
}
