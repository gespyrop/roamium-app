import 'package:flutter/material.dart';
import 'package:roamium_app/src/theme/colors.dart';

class ListHeader extends StatelessWidget {
  final String text;
  const ListHeader({Key? key, this.text = ''}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: EdgeInsets.zero,
      child: ListTile(
        title: Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        tileColor: primaryColor,
      ),
    );
  }
}
