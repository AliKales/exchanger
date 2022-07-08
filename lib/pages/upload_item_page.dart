import 'dart:io';

import 'package:flutter/material.dart';
import 'package:trade/UIs/custom_button.dart';
import 'package:trade/UIs/custom_textfield.dart';
import 'package:trade/colors.dart';
import 'package:trade/firebase/auth.dart';
import 'package:trade/firebase/firestore.dart';
import 'package:trade/firebase/storage.dart';
import 'package:trade/funcs.dart';
import 'package:trade/models/model_item.dart';
import 'package:trade/simple_uis.dart';
import 'package:trade/values.dart';

class UploadItemPage extends StatefulWidget {
  const UploadItemPage({Key? key, this.isForTradeRequest = false})
      : super(key: key);

  final bool? isForTradeRequest;

  @override
  State<UploadItemPage> createState() => _UploadItemPageState();
}

class _UploadItemPageState extends State<UploadItemPage> {
  TextEditingController tECTitle = TextEditingController();
  TextEditingController tECDescription = TextEditingController();
  ScrollController scrollController = ScrollController();

  String? country;
  String? city;
  List? _cities;
  String? path;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Share Your Stuff",
          style: TextStyle(color: colorText),
        ),
        backgroundColor: color1,
        leading: SimpleUIs.customAppbarBackButton(context: context),
      ),
      backgroundColor: color1,
      body: body(),
    );
  }

  body() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SingleChildScrollView(
        controller: scrollController,
        child: Column(
          children: [
            CustomTextField(
                controller: tECTitle,
                labelText: "Title",
                maxLength: 50,
                maxLines: null),
            CustomTextField(
              controller: tECDescription,
              labelText: "Description",
              maxLines: null,
            ),
            SimpleUIs.showDropdownButton(
              context: context,
              list: countries,
              hint: "Country",
              onChanged: onCountryChange,
              dropdownValue: country,
            ),
            SimpleUIs.showDropdownButton(
              context: context,
              list: _cities ?? [],
              hint: "City",
              onChanged: (val) {
                city = val as String;
              },
              dropdownValue: city,
            ),
            if (path == null)
              CustomButton.outlined(
                  textOutlined: "Take Photo", onTap: takePhoto),
            if (path != null) widgetImage(),
            if (path != null)
              CustomButton.text(
                textTextButton: "Delete Image",
                onTap: () {
                  setState(() {
                    path = null;
                  });
                },
              ),
            CustomButton(text: "Share", onTap: share),
          ],
        ),
      ),
    );
  }

  Container widgetImage() {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(color: color3, width: 2),
          borderRadius: const BorderRadius.all(Radius.circular(customRadius))),
      child: ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(customRadius)),
        child: Image.file(
          File(path!),
        ),
      ),
    );
  }

  void onCountryChange(val) {
    country = val;
    _cities =
        cities.firstWhere((element) => element['country'] == val)['cities'];
    setState(() {});
  }

  Future takePhoto() async {
    path = await Funcs().takePhotoWithCamera();
    setState(() {});
    await Future.delayed(const Duration(milliseconds: 500));
    scrollController.animateTo(scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 800), curve: Curves.easeIn);
  }

  Future share() async {
    DateTime dateTime = Funcs().getGMTDateTimeNow();
    String itemId = Funcs().getIdByTime(dateTime);
    String pathToStorage =
        "itemImages/${Auth().getId()}/$itemId.${path!.split(".").last}";
    String? imageURL = await Storage.uploadFile(
        context: context, file: File(path!), path: pathToStorage);

    if (imageURL == null) return;

    ModelItem item = ModelItem(
      title: tECTitle.text.trim(),
      description: tECDescription.text.trim(),
      country: country,
      city: city,
      imageURL: imageURL,
      ownerId: Auth().getId(),
      ownerName: Auth().getDisplayName(),
      uploadDate: dateTime.toIso8601String(),
      itemId: itemId,
    );

    if (widget.isForTradeRequest!) {
      Navigator.pop(context, item);
    } else {
      bool result =
          await Firestore.uploadItem(context: context, doc: itemId, item: item);
      if (result && mounted) {
        Navigator.pop(context);
        Funcs().showSnackBar(context, "Succesfully shared!");
      }
    }
  }
}
