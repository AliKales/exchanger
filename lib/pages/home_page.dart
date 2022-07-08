import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trade/UIs/custom_animated_text.dart';
import 'package:trade/UIs/custom_scroll_refresh_indicator.dart';
import 'package:trade/UIs/widget_listview_items.dart';
import 'package:trade/colors.dart';
import 'package:trade/firebase/firestore.dart';
import 'package:trade/funcs.dart';
import 'package:trade/models/model_item.dart';
import 'package:trade/pages/item_details_page.dart';
import 'package:trade/providers/provider_home_page.dart';
import 'package:trade/simple_uis.dart';
import 'package:trade/values.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with AutomaticKeepAliveClientMixin<HomePage> {
  List<ModelItem> items = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(const Duration(milliseconds: 3200)).then((value) {
      Firestore.loadItems(context: context);
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    items = Provider.of<ProviderHomePage>(context).items;
    return CustomScrollRefreshIndicator(
      onRefresh: () {
        loadMore();
      },
      child: Column(
        children: [
          textHeadline(context),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: items.length,
              itemBuilder: (context, index) {
                return WidgetItem(
                  modelItem: items[index],
                  onClick: () => onClickint(index, items[index]),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget itemsWidget() {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: items.length,
      itemBuilder: (context, index) {
        ModelItem modelItem = items[index];
        if (index != items.length - 1) {
          return widgetContainerItem(context, modelItem, index);
        } else {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              widgetContainerItem(context, modelItem, index),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: IconButton(
                  onPressed: loadMore,
                  iconSize: 36,
                  icon: const Icon(
                    Icons.refresh,
                    color: colorText,
                  ),
                ),
              ),
            ],
          );
        }
      },
    );
  }

  Container widgetContainerItem(
      BuildContext context, ModelItem modelItem, int index) {
    return Container(
      margin: const EdgeInsets.all(8),
      padding: const EdgeInsets.all(8),
      height: MediaQuery.of(context).size.height / 1.4,
      width: MediaQuery.of(context).size.width -
          (MediaQuery.of(context).size.width / 7),
      decoration: const BoxDecoration(
          color: color2,
          borderRadius: BorderRadius.all(Radius.circular(customRadius))),
      child: InkWell(
        onTap: () {},
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
                child: Hero(
                  tag: index.toString(),
                  child: ClipRRect(
                    borderRadius:
                        const BorderRadius.all(Radius.circular(customRadius)),
                    child: widgetImage(modelItem.imageURL),
                  ),
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

  Widget textHeadline(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Align(
        alignment: Alignment.topCenter,
        child: CustomAnimatedText(
          duration: const Duration(milliseconds: 3400),
          textWidget: Text(
            "Exchange Your Stuff",
            style: Theme.of(context)
                .textTheme
                .headline4!
                .copyWith(fontWeight: FontWeight.w600),
          ),
        ),
      ),
    );
  }

  Widget widgetImage(String? imageURL) {
    return CachedNetworkImage(
      imageUrl: imageURL ?? "",
      placeholder: (context, url) => SimpleUIs.progressIndicator(),
      errorWidget: (context, url, error) => Container(
        color: color1,
      ),
    );
  }

  Future loadMore() async {
    SimpleUIs().showProgressIndicator(context);
    await Firestore.loadItems(context: context);
    if (mounted) Navigator.pop(context);
  }

  void onClickint(int index, ModelItem modelItem) {
    Funcs().navigatorPush(
      context,
      ItemDetailsPage(
        modelItem: modelItem,
      ),
    );
  }

  Future<void> onRefresh() async {
    SimpleUIs().showProgressIndicator(context);
    await Firestore.loadItems(context: context);
    if (mounted) Navigator.pop(context);
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
