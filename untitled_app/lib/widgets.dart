import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomInputFeild extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final String? Function(String?)? validatorFunction;
  final AutovalidateMode validator;
  final TextInputType inputType;
  final FocusNode? focus;
  final String filter;
  final double? width;
  final bool enabled;
  final bool obscure;
  CustomInputFeild(
      {required this.label,
      required this.controller,
      this.focus,
      this.width,
      this.inputType = TextInputType.text,
      this.filter = r'[\s\S]*',
      this.validator = AutovalidateMode.disabled,
      this.validatorFunction,
      this.enabled = true,
      this.obscure = false,
      super.key});

  double feildWidth = 0.0;

  @override
  Widget build(BuildContext context) {
    if (width == null) {
      feildWidth = MediaQuery.of(context).size.width * 0.9;
    } else {
      feildWidth = width!;
    }
    return Container(
      padding: const EdgeInsets.only(top: 10, bottom: 10),
      width: feildWidth,
      child: TextFormField(
        obscureText: obscure,
        enabled: enabled,
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp(filter)),
        ],
        autovalidateMode: validator,
        validator: validatorFunction,
        controller: controller,
        focusNode: focus,
        //autofocus: true,
        keyboardType: inputType,
        style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.normal,
            color: Theme.of(context).colorScheme.tertiary),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(
            fontSize: 18,
            letterSpacing: 1,
            fontWeight: FontWeight.normal,
            color: Theme.of(context).colorScheme.primary,
          ),
          fillColor: Theme.of(context).colorScheme.onBackground,
          filled: true,
          enabledBorder: OutlineInputBorder(
            borderSide:
                BorderSide(color: Theme.of(context).colorScheme.onPrimary),
            borderRadius: BorderRadius.circular(10.0),
          ),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide:
                  BorderSide(color: Theme.of(context).colorScheme.primary)),
        ),
      ),
    );
    ;
  }
}
