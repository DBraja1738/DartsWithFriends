import 'package:flutter/material.dart';


class PlayerTextInput extends StatelessWidget{
  final TextEditingController controller;

  const PlayerTextInput({
    Key? key,
    required this.controller,
  }): super(key: key);
  Widget build(BuildContext context){

    return TextField(
      controller: controller,
      decoration: InputDecoration(
        border: OutlineInputBorder(),
      ),
    );
  }
}