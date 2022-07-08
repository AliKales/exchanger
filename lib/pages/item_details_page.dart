import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trade/UIs/custom_button.dart';
import 'package:trade/UIs/fave_icon.dart';
import 'package:trade/colors.dart';
import 'package:trade/custom_icons_icons.dart';
import 'package:trade/firebase/auth.dart';
import 'package:trade/firebase/firestore.dart';
import 'package:trade/funcs.dart';
import 'package:trade/models/model_item.dart';
import 'package:trade/pages/upload_item_page.dart';
import 'package:trade/providers/provider_exchanges_page.dart';
import 'package:trade/simple_uis.dart';
import 'package:trade/values.dart';

class ItemDetailsPage extends StatelessWidget {
  const ItemDetailsPage(
      {Key? key,
      this.heroTag,
      required this.modelItem,
      this.exchangeItem,
      this.isButtonActive = true})
      : super(key: key);

  final String? heroTag;
  final ModelItem modelItem;
  final bool? isButtonActive;

  ///[exchangeItem] is the item which sent to exchange for
  final ModelItem? exchangeItem;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: color1,
      appBar: AppBar(
        title: const Text("Trader",
            style: TextStyle(color: colorText, fontWeight: FontWeight.w600)),
        elevation: 0,
        backgroundColor: color1,
        leading: SimpleUIs.customAppbarBackButton(context: context),
        actions: const [
          FaveIcon(),
        ],
      ),
      body: heroTag == null
          ? widgetChild(context)
          : Hero(tag: heroTag!, child: widgetChild(context)),
    );
  }

  Padding widgetChild(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            WidgetItemDetails(modelItem: modelItem),
            if (isButtonActive! && exchangeItem == null)
              CustomButton(
                  text: "SEND REQUEST",
                  margin: const EdgeInsets.symmetric(vertical: 25),
                  onTap: () => sendRequest(context)),
            Visibility(
              visible: exchangeItem != null,
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Align(
                  alignment: Alignment.center,
                  child: Icon(
                    Icons.keyboard_double_arrow_down_sharp,
                    color: colorText,
                    size: 36,
                  ),
                ),
              ),
            ),
            if (exchangeItem != null)
              WidgetItemDetails(modelItem: exchangeItem!),
          ],
        ),
      ),
    );
  }

  Future sendRequest(context) async {
    if (Auth().getId() == "") return;
    if (Auth().getId() == modelItem.ownerId) {
      Funcs().showSnackBar(context, "This item is yours!");
      return;
    }

    if (Provider.of<ProviderExchangesPage>(context, listen: false)
            .itemIDsFromYou ==
        null) {
      await Firestore.getUserData(context: context);
    }

    List<Map>? ids = Provider.of<ProviderExchangesPage>(context, listen: false)
        .itemIDsFromYou;
    if (ids!.indexWhere(
          (element) => element['to'] == modelItem.itemId,
        ) !=
        -1) {
      Funcs().showSnackBar(context, "You have already requested!");
      return;
    }

    ModelItem? result = await Funcs().navigatorPush(
        context,
        const UploadItemPage(
          isForTradeRequest: true,
        ));

    if (result == null) return;

    bool resultTradeRequest = await Firestore.sendTradeRequest(
        context: context, rSenderItem: result, itemTaker: modelItem);

    if (resultTradeRequest) {
      Provider.of<ProviderExchangesPage>(context, listen: false)
          .updateItemIDsFromYou([
        {'to': modelItem.itemId!, 'fromYou': result.toJson()}
      ], true);
      Navigator.pop(context);
    }
  }
}

class WidgetItemDetails extends StatelessWidget {
  const WidgetItemDetails({Key? key, required this.modelItem})
      : super(key: key);

  final ModelItem modelItem;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Align(
          alignment: Alignment.topCenter,
          child: Container(
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              borderRadius:
                  const BorderRadius.all(Radius.circular(customRadius)),
              border: Border.all(color: Colors.black, width: 4),
            ),
            height: MediaQuery.of(context).size.height / 2,
            child: ClipRRect(
                borderRadius:
                    const BorderRadius.all(Radius.circular(customRadius)),
                child: widgetImage(modelItem.imageURL)),
          ),
        ),
        Align(
          alignment: Alignment.topCenter,
          child: Text(
            modelItem.title ?? "",
            textAlign: TextAlign.center,
            style: Theme.of(context)
                .textTheme
                .headline5!
                .copyWith(fontWeight: FontWeight.w600),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              modelItem.description ?? "",
              style: Theme.of(context).textTheme.headline6,
            ),
          ),
        ),
        const Divider(),
        Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            const Icon(CustomIcons.user, color: colorText),
            Text(modelItem.ownerName ?? ""),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(top: 5),
          child: Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              const Icon(Icons.location_on, color: colorText),
              Text("${modelItem.city}/${modelItem.country}"),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 5),
          child: Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              const Icon(Icons.date_range_outlined, color: colorText),
              Text(Funcs().formatDate(Funcs().getFixedDateTime(
                  DateTime.tryParse(modelItem.uploadDate!))!)),
            ],
          ),
        ),
      ],
    );
  }

  Widget widgetImage(String? imageURL) {
    return CachedNetworkImage(
      imageUrl: imageURL ?? "",
      fit: BoxFit.scaleDown,
      placeholder: (context, url) => SimpleUIs.progressIndicator(),
      errorWidget: (context, url, error) => Container(
        color: color1,
      ),
    );
  }
}
