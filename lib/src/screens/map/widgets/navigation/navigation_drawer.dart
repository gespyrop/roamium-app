import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:roamium_app/src/blocs/auth/auth_bloc.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:roamium_app/src/theme/colors.dart';
import 'package:roamium_app/src/widgets/logo.dart';

class NavigationDrawer extends StatelessWidget {
  const NavigationDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  // Navigation menu
                  const Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: 8.0, horizontal: 48.0),
                    child: RoamiumLogo(),
                  ),
                  const Divider(),
                  ListTile(
                    title: Text(
                      AppLocalizations.of(context).myProfile,
                      style: const TextStyle(color: Colors.black54),
                    ),
                    leading: Icon(Icons.person,
                        color: primaryColor.withOpacity(0.8)),
                    onTap: () => Navigator.of(context).pushNamed('/profile'),
                  ),
                  ListTile(
                    title: Text(
                      AppLocalizations.of(context).routeHistory,
                      style: const TextStyle(color: Colors.black54),
                    ),
                    leading: Icon(Icons.history,
                        color: primaryColor.withOpacity(0.8)),
                    onTap: () =>
                        Navigator.of(context).pushNamed('/route-history'),
                  ),
                ],
              ),
            ),

            // Logout
            ListTile(
              title: Text(
                AppLocalizations.of(context).logout,
                style: const TextStyle(color: Colors.black54),
              ),
              leading: Icon(Icons.logout, color: primaryColor.withOpacity(0.8)),
              onTap: () => context.read<AuthBloc>().add(Logout()),
            ),
          ],
        ),
      ),
    );
  }
}
