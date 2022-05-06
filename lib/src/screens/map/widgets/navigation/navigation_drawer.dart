import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:roamium_app/src/blocs/auth/auth_bloc.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
                  ListTile(
                    title: Text(AppLocalizations.of(context).myProfile),
                    leading: const Icon(Icons.person),
                    onTap: () => Navigator.of(context).pushNamed('/profile'),
                  ),
                  ListTile(
                    title: Text(AppLocalizations.of(context).routeHistory),
                    leading: const Icon(Icons.history),
                    onTap: () =>
                        Navigator.of(context).pushNamed('/route-history'),
                  ),
                ],
              ),
            ),

            // Logout
            ListTile(
              title: Text(AppLocalizations.of(context).logout),
              leading: const Icon(Icons.logout),
              onTap: () => context.read<AuthBloc>().add(Logout()),
            ),
          ],
        ),
      ),
    );
  }
}
