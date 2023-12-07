import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'controllers/login_text_feild_controller.dart';

class CustomInputFeild extends StatelessWidget {
  final int? maxLen;
  final String label;
  final TextEditingController controller;
  final String? Function(String?)? validatorFunction;
  final AutovalidateMode validator;
  final TextInputType inputType;
  final FocusNode? focus;
  final String filter;
  final double? width;
  final bool enabled;
  final bool password;
  final TextInputAction textInputAction;
  final double? height;

  final void Function(String)? onChanged;
  final void Function()? onEditingComplete;
  const CustomInputFeild(
      {required this.label,
      required this.controller,
      this.onChanged,
      this.maxLen,
      this.onEditingComplete,
      this.focus,
      this.width,
      this.height,
      this.inputType = TextInputType.text,
      this.filter = r'[\s\S]*',
      this.validator = AutovalidateMode.disabled,
      this.validatorFunction,
      this.enabled = true,
      this.password = false,
      this.textInputAction = TextInputAction.next,
      super.key});

  @override
  Widget build(BuildContext context) {
    double feildWidth;

    if (width == null) {
      feildWidth = MediaQuery.of(context).size.width * 0.9;
    } else {
      feildWidth = width!;
    }
    return ChangeNotifierProvider(
        create: (context) => LoginFieldController(password: password),
        builder: (context, child) {
          return Container(
            alignment: Alignment.bottomCenter,
            padding: const EdgeInsets.only(top: 10, bottom: 10),
            width: feildWidth,
            height: height,
            child: TextFormField(
              maxLength: maxLen,
              cursorColor: Theme.of(context).colorScheme.onBackground,
              obscureText:
                  Provider.of<LoginFieldController>(context, listen: true)
                      .hidden,

              enabled: enabled,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(filter)),
              ],
              textInputAction: textInputAction,
              autovalidateMode: validator,
              validator: validatorFunction,
              controller: controller,
              focusNode: focus,
              onChanged: onChanged,
              onEditingComplete: onEditingComplete,
              //autofocus: true,
              keyboardType: inputType,
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.normal,
                  color: Theme.of(context).colorScheme.onBackground),
              decoration: InputDecoration(
                labelText: label,
                labelStyle: TextStyle(
                  fontSize: 18,
                  letterSpacing: 1,
                  fontWeight: FontWeight.normal,
                  color: Theme.of(context).colorScheme.onBackground,
                ),
                fillColor:
                    Theme.of(context).colorScheme.onBackground.withOpacity(0.2),
                filled: true,
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: Theme.of(context).colorScheme.background),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide(
                        color: Theme.of(context).colorScheme.onBackground)),
                suffixIcon: password
                    ? IconButton(
                        icon: Icon(Provider.of<LoginFieldController>(context,
                                    listen: true)
                                .hidden
                            ? Icons.visibility_off
                            : Icons.visibility),
                        onPressed: () => Provider.of<LoginFieldController>(
                                context,
                                listen: false)
                            .bottonPressed(),
                      )
                    : null,
              ),
            ),
          );
        });
  }
}
