import 'package:flutter/material.dart';

class WidgetForm extends StatelessWidget {
  const WidgetForm({
    Key? key,
    this.marginTop,
    this.hint,
    this.textEditingController,
    required this.obscureTextController,
    this.iconController,
  }) : super(key: key);

  final double? marginTop;
  final String? hint;
  final TextEditingController? textEditingController;
  final Icon? iconController;
  final bool obscureTextController;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: marginTop ?? 16),
      // width: 350,
      // height: 45,
      width: 260,
      height: 60,
      child: TextFormField(
        controller: textEditingController,
        obscureText: obscureTextController,
        autovalidateMode: AutovalidateMode.always,
        autocorrect: false,
        decoration: InputDecoration(
            suffix: iconController,
            labelText: hint,
            border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(8)),
            )),
      ),
      // child: TextFormField(
      //   controller: textEditingController,
      //   decoration: InputDecoration(
      //     // hintText: hint,
      //     filled: true,
      //     icon: iconController,
      //     border: const OutlineInputBorder(),
      //     labelText: hint,
      //   ),
      //   // obscureText: trfxvbsfvue,
      //   autovalidateMode: AutovalidateMode.always,
      //   autocorrect: false,
      // ),
    );
  }
}
