import 'package:flutter/material.dart';

class CustomAnimatedText extends StatefulWidget {
  const CustomAnimatedText(
      {Key? key, required this.textWidget, required this.duration})
      : super(key: key);
  final Text textWidget;
  final Duration duration;

  @override
  State<CustomAnimatedText> createState() => _CustomAnimatedTextState();
}

class _CustomAnimatedTextState extends State<CustomAnimatedText>
    with TickerProviderStateMixin {
  late AnimationController controller;
  late AnimationController controllerOpacity;
  late Animation<Offset> offset;
  late Animation<double> opacity;

  @override
  void initState() {
    super.initState();

    controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 1));
    controllerOpacity =
        AnimationController(vsync: this, duration: const Duration(seconds: 1));

    offset = Tween<Offset>(begin: const Offset(0.0, -1.0), end: Offset.zero)
        .animate(controller);

    opacity = Tween<double>(begin: 0, end: 1).animate(controllerOpacity);

    Future.delayed(widget.duration).then((value) => animate());
  }

  animate() {
    if (mounted) {
      controller.forward();
      controllerOpacity.forward();
    }
  }

  @override
  void dispose() {
    controller.dispose();
    controllerOpacity.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: opacity,
      child: SlideTransition(
        position: offset,
        child: widget.textWidget,
      ),
    );
  }
}
