import 'package:flutter/material.dart';
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
                  TextFormField(
                    style: const TextStyle(color: primaryColor),
                    cursorColor: secondaryColor,
                    decoration: InputDecoration(
                      labelStyle: const TextStyle(color: secondaryColor),
                      labelText: 'First Name', // TODO Translate
                      hintStyle: const TextStyle(
                          color: secondaryColor, fontSize: 16.0),
                      errorStyle: errorStyle,
                      floatingLabelBehavior: FloatingLabelBehavior.never,
                      hintText: 'First Name',
                      fillColor: Colors.white.withOpacity(0.8),
                      filled: true,
                      isDense: true,
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    controller: _firstNameController,
                    keyboardType: TextInputType.name,
                    autocorrect: false,
                    validator: (firstName) {
                      if (firstName == null || firstName.isEmpty) {
                        return 'First name is required.';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24.0),
                  TextFormField(
                    style: const TextStyle(color: primaryColor),
                    cursorColor: secondaryColor,
                    decoration: InputDecoration(
                      labelStyle: const TextStyle(color: secondaryColor),
                      labelText: 'Last Name', // TODO Translate
                      hintStyle: const TextStyle(
                          color: secondaryColor, fontSize: 16.0),
                      errorStyle: errorStyle,
                      floatingLabelBehavior: FloatingLabelBehavior.never,
                      hintText: 'Last Name',
                      fillColor: Colors.white.withOpacity(0.8),
                      filled: true,
                      isDense: true,
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    controller: _lastNameController,
                    keyboardType: TextInputType.name,
                    autocorrect: false,
                    validator: (lastName) {
                      if (lastName == null || lastName.isEmpty) {
                        return 'Last name is required.';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24.0),
                  TextFormField(
                    style: const TextStyle(color: primaryColor),
                    cursorColor: secondaryColor,
                    decoration: InputDecoration(
                      labelStyle: const TextStyle(color: secondaryColor),
                      labelText: 'Email', // TODO Translate
                      hintStyle: const TextStyle(
                          color: secondaryColor, fontSize: 16.0),
                      errorStyle: errorStyle,
                      floatingLabelBehavior: FloatingLabelBehavior.never,
                      hintText: 'Email',
                      fillColor: Colors.white.withOpacity(0.8),
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
                  const SizedBox(height: 24.0),
                  TextFormField(
                    style: const TextStyle(color: primaryColor),
                    cursorColor: secondaryColor,
                    decoration: InputDecoration(
                      labelText: 'Password', // TODO Translate
                      labelStyle: const TextStyle(color: secondaryColor),
                      floatingLabelBehavior: FloatingLabelBehavior.never,
                      hintText: 'Password',
                      hintStyle: const TextStyle(
                          color: secondaryColor, fontSize: 16.0),
                      errorStyle: errorStyle,
                      fillColor: Colors.white.withOpacity(0.8),
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

                      if (password != _confirmPasswordController.text) {
                        return 'The passwords don\'t match.';
                      }

                      return null;
                    },
                  ),
                  const SizedBox(height: 24.0),
                  TextFormField(
                    style: const TextStyle(color: primaryColor),
                    cursorColor: secondaryColor,
                    decoration: InputDecoration(
                      labelText: 'Confirm password', // TODO Translate
                      labelStyle: const TextStyle(color: secondaryColor),
                      floatingLabelBehavior: FloatingLabelBehavior.never,
                      hintText: 'Confirm password',
                      hintStyle: const TextStyle(
                          color: secondaryColor, fontSize: 16.0),
                      errorStyle: errorStyle,
                      fillColor: Colors.white.withOpacity(0.8),
                      isDense: true,
                      filled: true,
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    obscureText: true,
                    controller: _confirmPasswordController,
                    validator: (password) {
                      if (password == null || password.isEmpty) {
                        return 'Password is required.';
                      }

                      if (password != _passwordController.text) {
                        return 'The passwords don\'t match.';
                      }

                      return null;
                    },
                  ),
                  const SizedBox(height: 36.0),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.white.withOpacity(0.8),
                        onPrimary: primaryColor,
                        textStyle: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16.0),
                        elevation: 0,
                      ),
                      child: const Text('SIGN UP'), // TODO Translate
                      onPressed: _register,
                    ),
                  ),
                  const SizedBox(height: 24.0),
                  InkWell(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 12.0),
                      decoration: BoxDecoration(
                        color: secondaryColor.withOpacity(0.6),
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: const Text(
                        'Already have an account? Log in.', // TODO Translate
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          decoration: TextDecoration.underline,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24.0),
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
