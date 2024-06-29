import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class CustomField extends StatelessWidget {
  const CustomField({
    super.key,
    required this.name,
    this.hintText,
    this.isObscureText = false,
    this.validator,
  });
  final String name;
  final String? hintText;
  final bool isObscureText;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return FormBuilderTextField(
      name: name,
      decoration: InputDecoration(hintText: hintText),
      obscureText: isObscureText,
      validator: validator,
    );
  }
}
