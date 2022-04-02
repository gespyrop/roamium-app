import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:roamium_app/src/screens/authentication/login_screen.dart';
import 'package:roamium_app/src/theme/style.dart';

class Roamium extends StatelessWidget {
  const Roamium({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Roamium',
      debugShowCheckedModeBanner: false,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      theme: appThemeData,
      home: const LoginScreen(),
    );
  }
}
