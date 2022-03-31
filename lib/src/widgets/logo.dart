import 'package:flutter/material.dart';
import 'package:roamium_app/src/theme/colors.dart';

class RoamiumLogo extends StatelessWidget {
  const RoamiumLogo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      decoration: BoxDecoration(
        color: secondaryColor.withOpacity(0.8),
        borderRadius: BorderRadius.circular(32.0),
      ),
      child: const Text(
        'Roamium',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 32.0,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
