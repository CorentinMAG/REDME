import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  String tooltip;
  Function() onPressed;
  Icon icon;
  Color color;
  MyButton(
    {
      super.key, 
      required this.tooltip, 
      required this.onPressed, 
      required this.icon,
      required this.color
    }
  );

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: tooltip,
      onPressed: onPressed,
      padding: const EdgeInsets.all(0),
      icon: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(10)),
        child: icon
      )
    );
  }
}