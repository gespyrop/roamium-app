import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:roamium_app/src/blocs/auth/auth_bloc.dart';
import 'package:roamium_app/src/theme/colors.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context).myProfile)),
      body: SizedBox(
        width: double.infinity,
        child: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            if (state is AuthLoaded) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.05,
                  ),
                  const Icon(Icons.person, size: 128.0, color: primaryColor),
                  Text(
                    '${state.user.firstName} ${state.user.lastName}',
                    style: const TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black45),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.03,
                  ),
                  Text(
                    state.user.email,
                    style: const TextStyle(
                      fontSize: 16.0,
                      color: Colors.black45,
                    ),
                  )
                ],
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
