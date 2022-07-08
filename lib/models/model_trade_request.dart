import 'package:trade/models/model_item.dart';

class ModelTradeRequest {
  String? tradeId;
  String? uploadDate;
  String? rSenderId;
  String? rSenderName;
  String? rTakerId;
  String? rTakerName;
  ModelItem? rSenderItem;
  String? rTakerItemId;

  ModelTradeRequest(
      {this.tradeId,
      this.uploadDate,
      this.rSenderId,
      this.rSenderName,
      this.rTakerId,
      this.rTakerName,
      this.rSenderItem,
      this.rTakerItemId});

  ModelTradeRequest.fromJson(Map<String, dynamic> json) {
    tradeId = json['tradeId'];
    uploadDate = json['uploadDate'];
    rSenderId = json['rSenderId'];
    rSenderName = json['rSenderName'];
    rTakerId = json['rTakerId'];
    rTakerName = json['rTakerName'];
    rSenderItem = ModelItem.fromJson(json['rSenderItem']);
    rTakerItemId = json['rTakerItemId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['tradeId'] = tradeId;
    data['uploadDate'] = uploadDate;
    data['rSenderId'] = rSenderId;
    data['rSenderName'] = rSenderName;
    data['rTakerId'] = rTakerId;
    data['rTakerName'] = rTakerName;
    data['rSenderItem'] = rSenderItem?.toJson();
    data['rTakerItemId'] = rTakerItemId;
    return data;
  }
}
