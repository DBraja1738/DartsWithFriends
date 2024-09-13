import 'package:flutter/material.dart';
import 'package:darts_with_friends/main.dart';
class Navbar extends StatefulWidget {
  final List<String> initialPlayerNames;
  final List<int> initialPlayerScores;

  const Navbar({
    super.key,
    required this.initialPlayerNames,
    required this.initialPlayerScores,
  });

  @override
  State<Navbar> createState() => _NavbarState();
}

class _NavbarState extends State<Navbar> {
  late List<String> playerNames;
  late List<int> playerScores;


  @override
  void initState(){
    super.initState();

    playerNames = widget.initialPlayerNames;
    playerScores = widget.initialPlayerScores;
  }

  void endGame(BuildContext context){
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("End game"),
            content: Text("Are you sure to end the game?"),
            actions: [
              TextButton(
                onPressed: (){
                  Navigator.of(context).pop();
                  Navigator.of(context).push(MaterialPageRoute(builder: (context)=> const Home()));
                },
                child: Text("Yes"),
                style: TextButton.styleFrom(
                  backgroundColor: Colors.red[500],
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                },
                child: Text('No'),
                style: TextButton.styleFrom(
                  backgroundColor: Colors.green[500],
                ),
              ),
            ],
          );
        }
    );

  }


  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          UserAccountsDrawerHeader(accountName: Text("Game stats"), accountEmail: Text("Scores and players")),

          ...List.generate(
              playerNames.length,
              (index) {
                return ListTile(
                  title: Text(playerNames[index] + ": " + playerScores[index].toString()),
                );
              }

          ),
          Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: ElevatedButton(
                  onPressed: () => endGame(context),
                  child: Text("End game"),
                  style: TextButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.red,

                ),
              ),
          ),

        ],
      ),
    );
  }
}
