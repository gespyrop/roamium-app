import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:roamium_app/src/screens/authentication/login_screen.dart';
import 'package:roamium_app/src/theme/style.dart';

import 'blocs/auth/auth_bloc.dart';

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
      home: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          if (state is AuthLoaded) {
            // TODO Replace with the landing screen
            return Scaffold(
                body: Center(
              child: Text(
                  'Logged in as ${state.user.firstName} ${state.user.lastName}'),
            ));
          }

          return const LoginScreen();
        },
      ),
    );
  }
}
