import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:trade/colors.dart';
import 'package:trade/firebase/firestore.dart';
import 'package:trade/models/model_item.dart';
import 'package:trade/simple_uis.dart';
import 'package:trade/values.dart';

class WidgetItem extends StatelessWidget {
  const WidgetItem({Key? key, required this.modelItem, this.index, required this.onClick})
      : super(key: key);

  final ModelItem modelItem;
  final int? index;
  final Function() onClick;

  @override
  Widget build(BuildContext context) {
    return widgetContainerItem(context, modelItem, index);
  }

  Widget widgetContainerItem(context, modelItem, index) {
    return Container(
      margin: const EdgeInsets.all(8),
      padding: const EdgeInsets.all(8),
      height: MediaQuery.of(context).size.height / 1.4,
      decoration: const BoxDecoration(
          color: color2,
          borderRadius: BorderRadius.all(Radius.circular(customRadius))),
      child: InkWell(
        onTap: () => onClick.call(),
        child: Column(
          children: [
            Expanded(
              flex: 3,
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.all(
                    Radius.circular(customRadius),
                  ),
                ),
                child:index==null? widgetImage(modelItem.imageURL):Hero(
                  tag: index.toString(),
                  child: widgetImage(modelItem.imageURL),
                ),
              ),
            ),
            const Divider(),
            Expanded(
              flex: 1,
              child: Center(
                child: Text(
                  modelItem.title ?? "---",
                  textAlign: TextAlign.center,
                  style: Theme.of(context)
                      .textTheme
                      .headline5!
                      .copyWith(fontWeight: FontWeight.w600),
                  overflow: TextOverflow.fade,
                  softWrap: true,
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                "${modelItem.city}/${modelItem.country}",
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.subtitle1,
                overflow: TextOverflow.fade,
                softWrap: true,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget widgetImage(String? imageURL) {
    return ClipRRect(
                    borderRadius:
                        const BorderRadius.all(Radius.circular(customRadius)),
      child: CachedNetworkImage(
        imageUrl: imageURL ?? "",
        placeholder: (context, url) => SimpleUIs.progressIndicator(),
        errorWidget: (context, url, error) => Container(
          color: color1,
        ),
      ),
    );
  }

  Future loadMore(context) async {
    SimpleUIs().showProgressIndicator(context);
    await Firestore.loadItems(context: context);
    Navigator.pop(context);
  }
}
