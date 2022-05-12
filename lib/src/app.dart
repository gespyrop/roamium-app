import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:roamium_app/src/screens/authentication/login_screen.dart';
import 'package:roamium_app/src/screens/map/map_screen.dart';
import 'package:roamium_app/src/screens/profile/profile_screen.dart';
import 'package:roamium_app/src/screens/route_history/route_history_screen.dart';
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
          return state is AuthLoaded ? const MapScreen() : const LoginScreen();
        },
      ),
      routes: {
        '/profile': (context) => const ProfileScreen(),
        '/route-history': (context) => const RouteHistoryScreen()
      },
    );
  }
}
