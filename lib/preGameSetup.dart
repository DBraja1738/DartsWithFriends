import 'package:flutter/material.dart';
import "package:darts_with_friends/game.dart";
import "package:darts_with_friends/widgets/textInputForPlayers.dart";
import 'package:shared_preferences/shared_preferences.dart';

class GameSetup extends StatefulWidget {
  const GameSetup({super.key});

  @override
  State<GameSetup> createState() => _GameSetupState();
}

class _GameSetupState extends State<GameSetup> {
  TextEditingController controller = TextEditingController();

  List<String> loggedInPlayers = [];
  int selectedScore=501;
  List<int> scoreOptions = [180,301,501,701];
  int numberOfPlayers=0;
  List<String> playerNames = [];
  bool selectedGamemode = true;

  @override
  void initState(){
    super.initState();
    _loadLoggedInPlayers();

  }

  Future<List<String>> getUsers() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList('emails') ?? [];
  }

  Future<void> _loadLoggedInPlayers() async {
    List<String> players = await getUsers();
    setState(() {
      loggedInPlayers = players;
    });
  }

  void callErrorMessage(){
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("You must add atleast two players")),
    );
  }

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
          Text("Select gamemode"),
          RadioListTile<bool>(
              title: Text("Single Out"),
              value: true,
              groupValue: selectedGamemode,
              onChanged: (value){
                setState(() {
                  selectedGamemode = value!;
                });
              }
          ),
          RadioListTile<bool>(
              title: Text("Double Out"),
              value: false,
              groupValue: selectedGamemode,
              onChanged: (value){
                setState(() {
                  selectedGamemode = value!;
                });
              }
          ),

          Text("Add player"),
          PlayerTextInput(controller: controller),
          ElevatedButton(
              onPressed: (){
                setState(() {
                  playerNames.add(controller.text.trim());
                  numberOfPlayers=numberOfPlayers+1;
                });

              },
              child: Text("Submit name")
          ),
          ElevatedButton(
              onPressed: numberOfPlayers < 2 ? callErrorMessage : (){
            Navigator.of(context).push(MaterialPageRoute(builder: (context)=>Game(numberOfPlayers: numberOfPlayers, playerNames: playerNames, mainScore: selectedScore, gameMode: selectedGamemode)));
          },
              child: Text("Start game")
          ),

          Text("Players"),
          Expanded(
            child: ListView.builder(
              itemCount: playerNames.length,
              itemBuilder: (context, index){
                return Padding(
                  padding: EdgeInsets.symmetric(vertical: 0.5, horizontal: 5.0),
                  child: Text(playerNames[index]),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
