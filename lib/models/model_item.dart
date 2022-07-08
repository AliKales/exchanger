class ModelItem {
  String? title;
  String? description;
  String? imageURL;
  String? uploadDate;
  String? country;
  String? city;
  String? ownerName;
  String? ownerId;
  String? itemId;

  ModelItem({
    this.title,
    this.description,
    this.imageURL,
    this.uploadDate,
    this.country,
    this.city,
    this.ownerName,
    this.ownerId,
    this.itemId,
  });

  ModelItem.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    description = json['description'];
    imageURL = json['imageURL'];
    uploadDate = json['uploadDate'];
    country = json['country'];
    city = json['city'];
    ownerName = json['ownerName'];
    ownerId = json['ownerId'];
    itemId = json['itemId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['title'] = title;
    data['description'] = description;
    data['imageURL'] = imageURL;
    data['uploadDate'] = uploadDate;
    data['country'] = country;
    data['city'] = city;
    data['ownerName'] = ownerName;
    data['ownerId'] = ownerId;
    data['itemId'] = itemId;
    return data;
  }
}
