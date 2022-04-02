import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:roamium_app/src/screens/authentication/registration_screen.dart';
import 'package:roamium_app/src/screens/authentication/widgets/auth_form_fields.dart';
import 'package:roamium_app/src/theme/colors.dart';
import 'package:roamium_app/src/widgets/logo.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  AutovalidateMode _autovalidateMode = AutovalidateMode.disabled;

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  _login() {
    if (_key.currentState!.validate()) {
      // TODO Add login logic
    } else {
      setState(() => _autovalidateMode = AutovalidateMode.always);
    }
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData mq = MediaQuery.of(context);

    return Scaffold(
      body: Container(
        height: double.infinity,
        decoration: BoxDecoration(
          color: secondaryColor,
          image: DecorationImage(
            image: const AssetImage('assets/images/auth_background.jpg'),
            colorFilter: ColorFilter.mode(
              secondaryColor.withOpacity(0.7),
              BlendMode.dstATop,
            ),
            fit: BoxFit.cover,
          ),
        ),
        child: Form(
          key: _key,
          autovalidateMode: _autovalidateMode,
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: mq.size.width * 0.15),
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                      top: mq.size.height *
                          (mq.orientation == Orientation.portrait ? 0.1 : 0.07),
                      bottom: mq.size.height *
                          (mq.orientation == Orientation.portrait ? 0.3 : 0.07),
                    ),
                    child: const RoamiumLogo(),
                  ),
                  AuthTextFormField(
                    label: 'Email',
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    validator: (email) {
                      if (email == null || email.isEmpty) {
                        return AppLocalizations.of(context).emailRequired;
                      }

                      if (!RegExp(emailRegex).hasMatch(email)) {
                        return AppLocalizations.of(context).invalidEmail;
                      }

                      return null;
                    },
                  ),
                  AuthTextFormField(
                    label: AppLocalizations.of(context).password,
                    obscureText: true,
                    controller: _passwordController,
                    validator: (password) {
                      if (password == null || password.isEmpty) {
                        return AppLocalizations.of(context).passwordRequired;
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 12.0),
                  AuthButton(
                    text: AppLocalizations.of(context).login,
                    onPressed: _login,
                  ),
                  AuthLink(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const RegistrationScreen(),
                      ),
                    ),
                    text: AppLocalizations.of(context).signUpLink,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

const String emailRegex =
    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";
