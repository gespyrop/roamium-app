import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:roamium_app/src/screens/authentication/widgets/auth_form_fields.dart';
import 'package:roamium_app/src/theme/colors.dart';
import 'package:roamium_app/src/widgets/logo.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({Key? key}) : super(key: key);

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  AutovalidateMode _autovalidateMode = AutovalidateMode.disabled;

  @override
  void dispose() {
    super.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
  }

  _register() {
    if (_key.currentState!.validate()) {
      // TODO Add registration logic
    } else {
      setState(() => _autovalidateMode = AutovalidateMode.always);
    }
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData mq = MediaQuery.of(context);

    return Scaffold(
      // backgroundColor: secondaryColor,
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
                    padding: EdgeInsets.symmetric(
                      vertical: mq.size.height *
                          (mq.orientation == Orientation.portrait ? 0.1 : 0.05),
                    ),
                    child: const RoamiumLogo(),
                  ),
                  AuthTextFormField(
                    label: AppLocalizations.of(context).firstName,
                    controller: _firstNameController,
                    keyboardType: TextInputType.name,
                    validator: (firstName) {
                      if (firstName == null || firstName.isEmpty) {
                        return AppLocalizations.of(context).firstNameRequired;
                      }
                      return null;
                    },
                  ),
                  AuthTextFormField(
                    label: AppLocalizations.of(context).lastName,
                    controller: _lastNameController,
                    keyboardType: TextInputType.name,
                    validator: (lastName) {
                      if (lastName == null || lastName.isEmpty) {
                        return AppLocalizations.of(context).lastNameRequired;
                      }
                      return null;
                    },
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
                  AuthTextFormField(
                    label: AppLocalizations.of(context).confirmPassword,
                    obscureText: true,
                    controller: _confirmPasswordController,
                    validator: (password) {
                      if (password == null || password.isEmpty) {
                        return AppLocalizations.of(context).passwordRequired;
                      }

                      if (password != _passwordController.text) {
                        return AppLocalizations.of(context).passwordsMismatch;
                      }

                      return null;
                    },
                  ),
                  const SizedBox(height: 12.0),
                  AuthButton(
                    text: AppLocalizations.of(context).signUp,
                    onPressed: _register,
                  ),
                  AuthLink(
                    onTap: () => Navigator.pop(context),
                    text: AppLocalizations.of(context).loginLink,
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

TextStyle errorStyle = TextStyle(
    color: Colors.red, backgroundColor: Colors.white.withOpacity(0.7));
