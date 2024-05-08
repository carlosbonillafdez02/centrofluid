import 'package:flutter/material.dart';
//Agregar importacion del provider del login

class PasswordTextField extends StatefulWidget {
  final void Function(String)? onChanged;
  final String? Function(String?)? validator;

  const PasswordTextField({
    super.key,
    required this.onChanged,
    required this.validator,
    required TextStyle style,
    required InputDecoration decoration,
  });

  @override
  State<PasswordTextField> createState() => _PasswordTextFieldState();
}

class _PasswordTextFieldState extends State<PasswordTextField> {
  bool passwordHidden = true;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: TextFormField(
        autocorrect: false,
        obscureText: passwordHidden,
        keyboardType: TextInputType.visiblePassword,
        decoration: InputDecoration(
          hintText: "Contraseña",
          suffixIcon: IconButton(
            onPressed: () {
              setState(() {
                passwordHidden = !passwordHidden;
              });
            },
            icon:
                Icon(passwordHidden ? Icons.visibility : Icons.visibility_off),
          ),
        ),
        onChanged: widget.onChanged,
        validator: widget.validator,
      ),
    );
  }
}
