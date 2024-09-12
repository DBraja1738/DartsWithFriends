import 'package:flutter/material.dart';
import "package:flutter/services.dart";
import 'dart:async';
import 'package:darts_with_friends/widgets/textInputForDarts.dart';
import "package:darts_with_friends/main.dart";

class GameScore{
  int dart1;
  int dart2;
  int dart3;
  int playerFlag;

  GameScore(this.dart1, this.dart2, this.dart3, this.playerFlag);

  int sumDarts(){
    int dart1clamped = dart1.clamp(0, 60);
    int dart2clamped = dart2.clamp(0, 60);
    int dart3clamped = dart3.clamp(0, 60);
    return dart1clamped+dart2clamped+dart3clamped;
  }
}


class Game extends StatefulWidget {
  final int numberOfPlayers;
  final List<String> playerNames;
  final int mainScore;
  Game({super.key, required this.numberOfPlayers, required this.playerNames, required this.mainScore});

  @override
  State<Game> createState() => _GameState();
}


class _GameState extends State<Game> {
  final TextEditingController _dart1controller = TextEditingController();
  final TextEditingController _dart2controller = TextEditingController();
  final TextEditingController _dart3controller = TextEditingController();


  List<int> playerScores = [];
  int currentPlayer = 1;
  String currentPlayerName="";
  List<GameScore> scoreList = [];
  int currentPlayerValue = 0;

  @override
  void initState(){
    super.initState();

    currentPlayerValue = widget.mainScore;
    playerScores = List<int>.filled(widget.numberOfPlayers,widget.mainScore);
    currentPlayerName=widget.playerNames.first;

  }

  void callSnackBarMessage(String message){
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  void submitScore(){
    GameScore score = GameScore(
        int.tryParse(_dart1controller.text) ?? 0,
        int.tryParse(_dart2controller.text) ?? 0,
        int.tryParse(_dart3controller.text) ?? 0,
        currentPlayer);
    scoreList.add(score);

    int dartSum = score.sumDarts();



    setState(() {

      if(currentPlayerValue - dartSum == 0){
        callSnackBarMessage(currentPlayerName + " has won!");

        Timer(Duration(seconds: 3), (){
          Navigator.of(context).push(MaterialPageRoute(builder: (context)=>const Home()));
        });
      }else if(currentPlayerValue - dartSum < 0){
        callSnackBarMessage(currentPlayerName + " has went overboard");

        currentPlayer = (currentPlayer % widget.numberOfPlayers) + 1;
        currentPlayerValue = playerScores[currentPlayer-1];
        currentPlayerName = widget.playerNames[currentPlayer-1];
      }else {
        playerScores[currentPlayer-1] -= dartSum;
        currentPlayer = (currentPlayer % widget.numberOfPlayers) + 1;
        currentPlayerValue = playerScores[currentPlayer-1];
        currentPlayerName = widget.playerNames[currentPlayer-1];
      }
    });

    _dart1controller.clear();
    _dart2controller.clear();
    _dart3controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Hello game"),
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Column(

                children: [
                  Text("Player: $currentPlayerName, $currentPlayer"),
                  Text("$currentPlayerValue"),
                ],
              ),
            ],
          ),
          Row(
            children: <Widget>[
              Flexible(
                  child: DartTextInput(controller: _dart1controller),
              ),
              SizedBox(width: 10,),
              Flexible(
                  child: DartTextInput(controller: _dart2controller),
              ),
              SizedBox(width: 10,),
              Flexible(
                  child: DartTextInput(controller: _dart3controller),
              ),
            ],
          ),
          ElevatedButton(onPressed: submitScore, child: Text("Submit score")),
        ],
      )
    );
  }
}

