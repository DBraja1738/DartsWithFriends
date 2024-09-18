import 'package:flutter/material.dart';
import "package:darts_with_friends/game.dart";
import "package:darts_with_friends/widgets/textInputForPlayers.dart";
import 'package:shared_preferences/shared_preferences.dart';
import 'package:darts_with_friends/widgets/decorations.dart';

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

  void _removePlayer(int index) {
    setState(() {
      playerNames.removeAt(index);
      numberOfPlayers--;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[600],
      appBar: AppBar(
        title: Text("Setup game"),
        backgroundColor: Colors.green[900],
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Select score"),
            Center(
              child: DropdownButton<int>(
                value: selectedScore,
                onChanged: (int? newValue) {
                  setState(() {
                    selectedScore = newValue!;
                  });
                },
                items: scoreOptions.map<DropdownMenuItem<int>>((int value) {
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
                onChanged: (value) {
                  setState(() {
                    selectedGamemode = value!;
                  });
                }),
            RadioListTile<bool>(
                title: Text("Double Out"),
                value: false,
                groupValue: selectedGamemode,
                onChanged: (value) {
                  setState(() {
                    selectedGamemode = value!;
                  });
                }),

            if (loggedInPlayers.isNotEmpty) Text("Select logged-in players"),
            if (loggedInPlayers.isNotEmpty)
              SizedBox(
                height: 200,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: loggedInPlayers.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(loggedInPlayers[index]),
                      trailing: IconButton(
                        icon: Icon(Icons.add),
                        onPressed: () {
                          if (!playerNames.contains(loggedInPlayers[index])) {
                            setState(() {
                              playerNames.add(loggedInPlayers[index]);
                              numberOfPlayers++;
                            });
                          }
                        },
                      ),
                    );
                  },
                ),
              ),

            Text("Add guest player"),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: PlayerTextInput(controller: controller),
            ),
            ElevatedButton(
              style: AppDecorations.buttonStyleSubmit,
              onPressed: () {
                setState(() {
                  if (controller.text.trim().isNotEmpty) {
                    playerNames.add(controller.text.trim());
                    numberOfPlayers = numberOfPlayers + 1;
                    controller.clear();
                  }
                });
              },
              child: Text("Submit name"),
            ),
            ElevatedButton(
              style: AppDecorations.buttonStyle,
              onPressed: numberOfPlayers < 2
                  ? callErrorMessage
                  : () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => Game(
                        numberOfPlayers: numberOfPlayers,
                        playerNames: playerNames,
                        mainScore: selectedScore,
                        gameMode: selectedGamemode)));
              },
              child: Text("Start game"),
            ),

            Text("Players"),
            SizedBox(
              height: 200,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: playerNames.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(playerNames[index]),
                    trailing: IconButton(
                      icon: Icon(Icons.remove_circle_outline),
                      onPressed: () => _removePlayer(index),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),

    );
  }
}
