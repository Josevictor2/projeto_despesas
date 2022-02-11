import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:universal_platform/universal_platform.dart';

class AdaptativeTextField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final void Function() submitForm;
  final TextInputType keyBoardType;
  const AdaptativeTextField(
      {Key? key,
      required this.submitForm,
      required this.label,
      required this.controller,
      this.keyBoardType = TextInputType.text})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (UniversalPlatform.isIOS) {
      return Padding(
        padding: const EdgeInsets.only(
          bottom: 10,
        ),
        child: CupertinoTextField(
          controller: controller,
          keyboardType: keyBoardType,
          onSubmitted: (_) => submitForm(),
          placeholder: label,
          padding: const EdgeInsets.symmetric(
            horizontal: 6,
            vertical: 12,
          ),
        ),
      );
    } else {
      return TextField(
        controller: controller,
        onSubmitted: (_) => submitForm(),
        keyboardType: keyBoardType,
        decoration: InputDecoration(
          labelText: label,
        ),
      );
    }
  }
}
