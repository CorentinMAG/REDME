import 'package:flutter/material.dart';

class MyFloatingButton extends StatelessWidget {
  const MyFloatingButton({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 70.0,
      height: 70.0,
      child: FloatingActionButton(
        child: Icon(
          Icons.add,
          size: 50.0,
        ),
        onPressed: () => print("pressed"),
      ),
    );
  }
}