import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trade/UIs/custom_scroll_refresh_indicator.dart';
import 'package:trade/UIs/custom_tabs.dart';
import 'package:trade/UIs/widget_listview_items.dart';
import 'package:trade/colors.dart';
import 'package:trade/firebase/auth.dart';
import 'package:trade/firebase/firestore.dart';
import 'package:trade/funcs.dart';
import 'package:trade/models/model_item.dart';
import 'package:trade/models/model_trade_request.dart';
import 'package:trade/pages/item_details_page.dart';
import 'package:trade/pages/upload_item_page.dart';
import 'package:trade/providers/provider_exchanges_page.dart';
import 'package:trade/values.dart';

class ExchangesPage extends StatefulWidget {
  const ExchangesPage({Key? key}) : super(key: key);

  @override
  State<ExchangesPage> createState() => _ExchangesPageState();
}

class _ExchangesPageState extends State<ExchangesPage>
    with AutomaticKeepAliveClientMixin<ExchangesPage> {
  int selectedTab = 0;

  List<Map>? itemIDsFromYou;
  List<ModelTradeRequest>? tradeRequests;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (tradeRequests == null) Firestore.getTradeRequests(context: context);
      if (itemIDsFromYou == null) Firestore.getUserData(context: context);
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    tradeRequests = Provider.of<ProviderExchangesPage>(context).tradeRequests;
    itemIDsFromYou = Provider.of<ProviderExchangesPage>(context).itemIDsFromYou;

    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            children: [
              CustomTabs(
                onChange: (value) {
                  setState(() {
                    selectedTab = value;
                  });
                },
                titles: const ["To You", "From You"],
              ),
              Expanded(child: pages()),
            ],
          ),
        ),
        Positioned(
          bottom: 16,
          right: 16,
          child: FloatingActionButton(
            elevation: 10,
            onPressed: () {
              if (Auth().getId() != "") {
                Funcs().navigatorPush(context, const UploadItemPage());
              }
            },
            backgroundColor: color3,
            child: const Icon(
              Icons.add,
              color: colorText,
            ),
          ),
        ),
      ],
    );
  }

  pages() {
    switch (selectedTab) {
      case 0:
        return WidgetToYou(
          tradeRequests: tradeRequests ?? [],
        );
      case 1:
        return WidgetFromYou(
          itemIDsFromYou: itemIDsFromYou ?? [],
        );
    }
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}

class WidgetToYou extends StatelessWidget {
  const WidgetToYou({Key? key, required this.tradeRequests}) : super(key: key);

  final List<ModelTradeRequest> tradeRequests;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: CustomScrollRefreshIndicator(
        onRefresh: () {
          Firestore.getTradeRequests(context: context);
        },
        child: ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: tradeRequests.length,
          itemBuilder: (context, index) {
            return WidgetItem(
                modelItem: tradeRequests[index].rSenderItem!,
                onClick: () => onClick(context, index));
          },
        ),
      ),
    );
  }

  Future onClick(context, int index) async {
    ModelItem? item = await Firestore.getSingleItem(
        context: context, id: tradeRequests[index].rTakerItemId!);

    if (item == null) return;

    Funcs().navigatorPush(
        context,
        ItemDetailsPage(
            exchangeItem: item, modelItem: tradeRequests[index].rSenderItem!));
  }
}

class WidgetFromYou extends StatelessWidget {
  const WidgetFromYou({Key? key, required this.itemIDsFromYou})
      : super(key: key);

  final List<Map> itemIDsFromYou;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListView.builder(
        itemCount: itemIDsFromYou.length,
        itemBuilder: (_, index) {
          return Container(
            padding: const EdgeInsets.all(8),
            margin: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
              color: color2,
              borderRadius: BorderRadius.all(
                Radius.circular(customRadius),
              ),
            ),
            child: Text(
              "${index.toInt() + 1}- " + itemIDsFromYou[index]['to'],
              style: Theme.of(context).textTheme.headline6,
            ),
          );
        },
      ),
    );
  }
}
