import 'package:flutter/material.dart';
import 'package:trade/colors.dart';

class SimpleUIs {
  static IconButton customAppbarBackButton(
      {required context, Function()? onTap}) {
    if (onTap == null) {
      return IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(
            Icons.arrow_back_ios_outlined,
            color: colorText,
          ));
    } else {
      return IconButton(
          onPressed: () => onTap.call(),
          icon: const Icon(Icons.arrow_back_ios_outlined, color: colorText));
    }
  }

  static Widget progressIndicator() {
    return const Center(child: CircularProgressIndicator.adaptive());
  }

  Future showProgressIndicator(context) async {
    FocusScope.of(context).unfocus();
    if (ModalRoute.of(context)?.isCurrent ?? true) {
      await showGeneralDialog(
          barrierLabel: "Barrier",
          barrierDismissible: false,
          barrierColor: Colors.black.withOpacity(0.5),
          transitionDuration: const Duration(milliseconds: 500),
          context: context,
          pageBuilder: (_, __, ___) {
            return WillPopScope(
              onWillPop: () async => false,
              child: progressIndicator(),
            );
          });
    }
  }

  static Widget showDropdownButton({
    required context,
    required List list,
    required Function(Object?) onChanged,
    required var dropdownValue,
    String? hint,
  }) {
    return StatefulBuilder(
      builder: (context, setState) {
        return DropdownButton(
          isExpanded: true,
          hint: Text(
            hint ?? "",
            style: const TextStyle(color: colorText),
          ),
          dropdownColor: color1,
          value: dropdownValue,
          items: List.generate(list.length,
              (index) => _widgetDropDownMenuItem(value: list[index])),
          onChanged: (value) {
            setState(() {
              dropdownValue = value;
            });
            onChanged.call(value);
          },
        );
      },
    );
  }

  static DropdownMenuItem<String> _widgetDropDownMenuItem(
      {required String value}) {
    return DropdownMenuItem(
      value: value,
      child: Text(value.toUpperCase()),
    );
  }
}
