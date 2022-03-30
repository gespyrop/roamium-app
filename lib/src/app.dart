import 'package:flutter/material.dart';
import 'package:roamium_app/src/screens/authentication/login_screen.dart';
import 'package:roamium_app/src/theme/style.dart';

class Roamium extends StatelessWidget {
  const Roamium({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Roamium',
      theme: appThemeData,
      home: const LoginScreen(),
    );
  }
}
