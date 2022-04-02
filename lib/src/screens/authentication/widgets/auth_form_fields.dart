import 'package:flutter/material.dart';
import 'package:roamium_app/src/theme/colors.dart';

class AuthTextFormField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final bool obscureText;

  const AuthTextFormField({
    Key? key,
    required this.controller,
    this.label = '',
    this.validator,
    this.keyboardType,
    this.obscureText = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24.0),
      child: TextFormField(
        style: const TextStyle(color: primaryColor),
        cursorColor: secondaryColor,
        decoration: InputDecoration(
          labelStyle: const TextStyle(color: secondaryColor, fontSize: 14.0),
          labelText: label,
          hintStyle: const TextStyle(color: secondaryColor, fontSize: 14.0),
          errorStyle: TextStyle(
            backgroundColor: Colors.white.withOpacity(0.7),
            color: Colors.red,
          ),
          floatingLabelBehavior: FloatingLabelBehavior.never,
          hintText: label,
          fillColor: Colors.white.withOpacity(0.8),
          filled: true,
          isDense: true,
          border: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
        obscureText: obscureText,
        controller: controller,
        keyboardType: keyboardType,
        autocorrect: false,
        validator: validator,
      ),
    );
  }
}

class AuthButton extends StatelessWidget {
  final String text;
  final void Function()? onPressed;

  const AuthButton({Key? key, this.onPressed, this.text = ''})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24.0),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            primary: Colors.white.withOpacity(0.8),
            onPrimary: primaryColor,
            textStyle:
                const TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
            elevation: 0,
          ),
          child: Text(text),
          onPressed: onPressed,
        ),
      ),
    );
  }
}

class AuthLink extends StatelessWidget {
  final String text;
  final void Function()? onTap;

  const AuthLink({Key? key, this.onTap, this.text = ''}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24.0),
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
          decoration: BoxDecoration(
            color: secondaryColor.withOpacity(0.6),
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: const TextStyle(
              decoration: TextDecoration.underline,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
