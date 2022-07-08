import 'package:flutter/material.dart';
import 'package:trade/colors.dart';
import 'package:trade/values.dart';

class CustomButton extends StatelessWidget {
  CustomButton({Key? key, required this.text, this.onTap, this.margin})
      : super(key: key);

  CustomButton.outlined(
      {Key? key, required this.textOutlined, this.onTap, this.margin})
      : super(key: key);

  CustomButton.text(
      {Key? key, required this.textTextButton, this.onTap, this.margin})
      : super(key: key);

  String? text;
  String? textOutlined;
  String? textTextButton;
  final Function()? onTap;
  final EdgeInsetsGeometry? margin;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => onTap?.call(),
        highlightColor: Colors.transparent,
        splashColor: Colors.transparent,
        child: Container(
          width: double.maxFinite,
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
          margin:
              margin ?? const EdgeInsets.symmetric(horizontal: 8, vertical: 25),
          decoration: textTextButton != null
              ? null
              : BoxDecoration(
                  border:
                      text == null ? Border.all(color: color2, width: 2) : null,
                  color: text != null ? color2 : Colors.transparent,
                  borderRadius:
                      const BorderRadius.all(Radius.circular(customRadius))),
          child: Text(
            text ?? textOutlined ?? textTextButton ?? "",
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.subtitle1!.copyWith(
                  fontWeight: FontWeight.w600,
                  color: textTextButton == null ? null : color2,
                ),
          ),
        ),
      ),
    );
  }
}
