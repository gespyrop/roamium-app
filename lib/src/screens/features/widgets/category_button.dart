import 'package:flutter/material.dart';
import 'package:roamium_app/src/models/category.dart';
import 'package:roamium_app/src/theme/colors.dart';

class CategoryButton extends StatelessWidget {
  final Category category;
  final Function()? onPressed;
  final bool selected;

  const CategoryButton(
      {Key? key,
      required this.category,
      required this.onPressed,
      this.selected = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            elevation: 0,
            primary: selected ? secondaryColor : Colors.white,
            side: const BorderSide(width: 2, color: secondaryColor),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(32.0),
            )),
        onPressed: onPressed,
        child: Text(
          category.toString(),
          textAlign: TextAlign.center,
          style: TextStyle(
            color: selected ? Colors.white : secondaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
