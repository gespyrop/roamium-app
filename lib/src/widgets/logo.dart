import 'package:flutter/material.dart';
import 'package:roamium_app/src/theme/colors.dart';

class RoamiumLogo extends StatelessWidget {
  const RoamiumLogo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Text(
      'Roamium',
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 32.0,
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
