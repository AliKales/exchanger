import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trade/colors.dart';
import 'package:trade/providers/provider_page_controller.dart';
import 'package:trade/values.dart';

class BottomNavBarItem {
  final String text;
  final IconData iconData;

  BottomNavBarItem({required this.text, required this.iconData});
}

class CustomBottomNavigationBar extends StatefulWidget {
  const CustomBottomNavigationBar({
    Key? key,
    required this.bottomNavBarItems,
  }) : super(key: key);

  final List<BottomNavBarItem> bottomNavBarItems;

  @override
  State<CustomBottomNavigationBar> createState() =>
      _CustomBottomNavigationBarState();
}

class _CustomBottomNavigationBarState extends State<CustomBottomNavigationBar> {
  int selectedItem = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: kBottomNavigationBarHeight,
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      decoration: const BoxDecoration(
        color: colorBottomNavBar,
        borderRadius: BorderRadius.all(
          Radius.circular(customRadius),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(
            widget.bottomNavBarItems.length,
            (index) =>
                _widgetItemInkWell(widget.bottomNavBarItems[index], index)),
      ),
    );
  }

  Widget _widgetItemInkWell(BottomNavBarItem bottomNavBarItem, int index) {
    return Stack(
      alignment: Alignment.center,
      children: [
        AnimatedSize(
          alignment: Alignment.centerLeft,
          duration: const Duration(milliseconds: 400),
          child: _widgetItem(bottomNavBarItem, index),
        ),
        InkWell(
          onTap: () {
            if (selectedItem == index) return;
            setState(() {
              selectedItem = index;
            });
            Provider.of<ProviderPageController>(context, listen: false)
                .changePage(selectedItem);
          },
          child: SizedBox(
            width: (MediaQuery.of(context).size.width / 3) - 16,
            height: kBottomNavigationBarHeight,
          ),
        ),
      ],
    );
  }

  Widget _widgetItem(BottomNavBarItem bottomNavBarItem, int index) {
    if (index == selectedItem) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _widgetIcon(bottomNavBarItem),
          Text(
            bottomNavBarItem.text,
            style: Theme.of(context)
                .textTheme
                .subtitle1!
                .copyWith(fontWeight: FontWeight.w600),
          ),
        ],
      );
    } else {
      return _widgetIcon(bottomNavBarItem);
    }
  }

  Icon _widgetIcon(BottomNavBarItem bottomNavBarItem) =>
      Icon(bottomNavBarItem.iconData, color: colorText);
}
