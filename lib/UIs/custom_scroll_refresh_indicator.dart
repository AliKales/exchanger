import 'package:flutter/material.dart';
import 'package:trade/colors.dart';

class CustomScrollRefreshIndicator extends StatefulWidget {
  const CustomScrollRefreshIndicator(
      {Key? key, required this.child, required this.onRefresh})
      : super(key: key);

  final Widget child;
  final Function() onRefresh;

  @override
  State<CustomScrollRefreshIndicator> createState() =>
      _CustomScrollRefreshIndicatorState();
}

class _CustomScrollRefreshIndicatorState
    extends State<CustomScrollRefreshIndicator> {
  ScrollController scrollController = ScrollController();

  bool isReadyRefresh = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    scrollController.addListener(() {
      if ((scrollController.offset - 52) >
          scrollController.position.maxScrollExtent) {
        setState(() {
          isReadyRefresh = true;
        });
      } else if (isReadyRefresh) {
        isReadyRefresh = false;
        widget.onRefresh.call();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<OverscrollIndicatorNotification>(
      onNotification: (OverscrollIndicatorNotification overscroll) {
        overscroll.disallowIndicator();
        return true;
      },
      child: Stack(
        children: [
          Align(
              alignment: Alignment.bottomCenter,
              child: Icon(Icons.refresh,
                  size: isReadyRefresh ? 46 : 36, color: colorText)),
          SingleChildScrollView(
            controller: scrollController,
            physics: const BouncingScrollPhysics(),
            child: Container(color: color1, child: widget.child),
          ),
        ],
      ),
    );
  }
}
