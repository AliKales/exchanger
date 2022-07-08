import 'package:flutter/material.dart';
import 'package:trade/colors.dart';
import 'package:trade/custom_icons_icons.dart';

class FaveIcon extends StatefulWidget {
  const FaveIcon({Key? key}) : super(key: key);

  @override
  State<FaveIcon> createState() => _FaveIconState();
}

class _FaveIconState extends State<FaveIcon> {
  bool isFave = false;

  @override
  Widget build(BuildContext context) {
    if (!isFave) {
      return IconButton(
          highlightColor: Colors.transparent,
          splashColor: Colors.transparent,
          onPressed: changeState,
          icon: const Icon(
            CustomIcons.favorite,
            color: colorText,
          ));
    } else {
      return IconButton(
          highlightColor: Colors.transparent,
          splashColor: Colors.transparent,
          onPressed: changeState,
          icon: const Icon(
            CustomIcons.favorite,
            color: Color.fromARGB(255, 255, 191, 0),
          ));
    }
  }

  void changeState() => setState(() {
        isFave = !isFave;
      });
}
