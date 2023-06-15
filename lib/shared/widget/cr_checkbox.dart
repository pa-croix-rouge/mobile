import 'package:flutter/material.dart';

class CrCheckBox extends StatefulWidget {
  const CrCheckBox({
    super.key,
    required this.text,
    required this.isChecked,
    required this.onChanged
  });

  final String text;
  final bool isChecked;
  final Function(bool? value) onChanged;

  @override
  State<CrCheckBox> createState() => _CrCheckBoxState();
}

class _CrCheckBoxState extends State<CrCheckBox> {

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Checkbox(
            activeColor: Theme.of(context).colorScheme.tertiary,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
            value: widget.isChecked,
            onChanged: (value) {
              widget.onChanged(value);
            }),
        Text(
          widget.text,
          style: Theme.of(context).textTheme.bodyText1,
        )
      ],
    );
  }
}