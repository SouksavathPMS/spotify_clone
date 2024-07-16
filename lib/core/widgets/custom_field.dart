import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class CustomField extends StatelessWidget {
  const CustomField({
    super.key,
    required this.name,
    this.hintText,
    this.isObscureText = false,
    this.validator,
    this.textInputType,
    this.readOnly = false,
    this.onTap,
  });
  final String name;
  final String? hintText;
  final bool isObscureText;
  final String? Function(String?)? validator;
  final TextInputType? textInputType;
  final bool readOnly;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return FormBuilderTextField(
      name: name,
      readOnly: readOnly,
      decoration: InputDecoration(hintText: hintText),
      keyboardType: textInputType,
      obscureText: isObscureText,
      validator: validator,
      onTap: onTap,
    );
  }
}
