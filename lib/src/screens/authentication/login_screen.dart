import 'package:flutter/material.dart';
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
      backgroundColor: secondaryColor,
      body: Form(
        key: _key,
        autovalidateMode: _autovalidateMode,
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: mq.size.width * 0.2),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: EdgeInsets.only(
                    top: mq.size.height *
                        (mq.orientation == Orientation.portrait ? 0.25 : 0.05),
                    bottom: 30.0,
                  ),
                  child: const RoamiumLogo(),
                ),
                TextFormField(
                  style: const TextStyle(color: primaryColor),
                  cursorColor: secondaryColor,
                  decoration: InputDecoration(
                    labelStyle: const TextStyle(color: secondaryColor),
                    labelText: 'Email', // TODO Translate
                    hintStyle:
                        const TextStyle(color: secondaryColor, fontSize: 16.0),
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                    hintText: 'Email',
                    fillColor: Colors.white,
                    filled: true,
                    isDense: true,
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  autocorrect: false,
                  validator: (email) {
                    if (email == null || email.isEmpty) {
                      return 'Email is required.'; // TODO Translate
                    }

                    if (!RegExp(emailRegex).hasMatch(email)) {
                      return 'Provide a valid email address.'; // TODO Translate
                    }

                    return null;
                  },
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24.0),
                  child: TextFormField(
                    style: const TextStyle(color: primaryColor),
                    cursorColor: secondaryColor,
                    decoration: InputDecoration(
                      labelText: 'Password', // TODO Translate
                      labelStyle: const TextStyle(color: secondaryColor),
                      floatingLabelBehavior: FloatingLabelBehavior.never,
                      hintText: 'Password',
                      hintStyle: const TextStyle(
                          color: secondaryColor, fontSize: 16.0),
                      fillColor: Colors.white,
                      isDense: true,
                      filled: true,
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    obscureText: true,
                    controller: _passwordController,
                    validator: (password) {
                      if (password == null || password.isEmpty) {
                        return 'Password is required.';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 16.0),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      primary: Colors.white, onPrimary: primaryColor),
                  child: const Text('LOG IN'), // TODO Translate
                  onPressed: _login,
                ),
                const SizedBox(height: 24.0),
                const InkWell(
                  child: Text(
                    'Don\'t have an account yet? Sign up.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      decoration: TextDecoration.underline,
                      color: Colors.white, // TODO Darker color?
                    ),
                  ),
                ),
                const SizedBox(height: 24.0),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

const String emailRegex =
    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";
