import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

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
  const CustomInputFeild(
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

  @override
  Widget build(BuildContext context) {
    double feildWidth;
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
  }
}

class ProfilePageTopNumberDisplay extends StatelessWidget {
  final int number;
  final String label;
  const ProfilePageTopNumberDisplay({required this.number, required this.label, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(alignment: Alignment.center,width: MediaQuery.sizeOf(context).width * 0.3,child: RichText(
      textAlign: TextAlign.center,
          text: TextSpan(
          text: NumberFormat.compact().format(number),
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          children: [
            TextSpan(
                text: "\n$label",
                style: const TextStyle(fontWeight: FontWeight.normal))
          ]),
    ));
  }
}
