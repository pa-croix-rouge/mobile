import 'package:flutter/material.dart';

class XButton extends StatelessWidget {
  final Widget child;

  final void Function() onPressed;

  final Color color;

  final double borderRadius;

  const XButton({
    super.key,
    required this.child,
    required this.onPressed,
    this.color = Colors.black,
    this.borderRadius = 10,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        textStyle: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
        backgroundColor: color,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 40),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius)
        ),
      ),
      child: child,
    );
  }
}