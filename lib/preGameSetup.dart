import 'package:flutter/material.dart';
import "package:darts_with_friends/game.dart";
import "package:darts_with_friends/widgets/textInputForPlayers.dart";


class GameSetup extends StatefulWidget {
  const GameSetup({super.key});

  @override
  State<GameSetup> createState() => _GameSetupState();
}

class _GameSetupState extends State<GameSetup> {
  TextEditingController controller = TextEditingController();

  int selectedScore=501;
  List<int> scoreOptions = [180,301,501,701];
  int numberOfPlayers=0;
  List<String> playerNames = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Setup game"),
      ),
      body: Column(
        children: [
          Text("Select score"),
          Center(
            child: DropdownButton<int>(
              value: selectedScore,

              onChanged: (int? newValue){
                setState(() {
                  selectedScore = newValue!;
                });
              },

              items: scoreOptions.map<DropdownMenuItem<int>>((int value){
                return DropdownMenuItem<int>(
                  value: value,
                  child: Text(value.toString()),
                );
              }).toList(),

            ),
          ),
          Text("Add player"),
          PlayerTextInput(controller: controller),
          ElevatedButton(onPressed: (){
            Navigator.of(context).push(MaterialPageRoute(builder: (context)=>Game(numberOfPlayers: 2, playerNames: playerNames, mainScore: selectedScore,)));
          },
              child: Text("Start game")),
        ],
      ),
    );
  }
}
