import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DartTextInput extends StatelessWidget{
  final TextEditingController controller;

  const DartTextInput({
    Key? key,
    required this.controller,
}): super(key: key);
  Widget build(BuildContext context){
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      inputFormatters: <TextInputFormatter>[
        FilteringTextInputFormatter.digitsOnly,
      ],
      decoration: InputDecoration(
        border: OutlineInputBorder(),
      ),
    );
  }
}
