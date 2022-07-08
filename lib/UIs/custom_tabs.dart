import 'package:flutter/material.dart';
import 'package:trade/colors.dart';
import 'package:trade/values.dart';

class CustomTabs extends StatefulWidget {
  const CustomTabs({Key? key, required this.onChange, required this.titles})
      : super(key: key);

  final Function(int) onChange;
  final List<String> titles;

  @override
  State<CustomTabs> createState() => _CustomTabsState();
}

class _CustomTabsState extends State<CustomTabs> {
  int selectedTab = 0;
  List<Widget> children = [];

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List<Widget>.generate(widget.titles.length,
          (index) => widgetTab(widget.titles[index], index)),
    );
  }

  Widget widgetTab(String text, int index) {
    return Expanded(
      child: InkWell(
        highlightColor: Colors.transparent,
        splashColor: Colors.transparent,
        onTap: () {
          if (selectedTab == index) return;
          setState(() => selectedTab = index);
          Future.delayed(const Duration(milliseconds: 800))
              .then((value) => widget.onChange.call(selectedTab));
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 800),
          height: kToolbarHeight / 1.3,
          decoration: BoxDecoration(
              color: color1,
              border: Border.all(
                  color: index == selectedTab ? color3 : colorText, width: 2),
              borderRadius:
                  const BorderRadius.all(Radius.circular(customRadius))),
          child: Center(
            child: Text(
              text,
              style: Theme.of(context)
                  .textTheme
                  .subtitle1!
                  .copyWith(color: colorText),
            ),
          ),
        ),
      ),
    );
  }
}
