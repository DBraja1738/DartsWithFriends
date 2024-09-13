import 'package:flutter/material.dart';
import "package:flutter/services.dart";
import 'dart:async';
import 'package:darts_with_friends/widgets/textInputForDarts.dart';
import "package:darts_with_friends/main.dart";
import 'package:darts_with_friends/widgets/navbar.dart';

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

  bool hasWon(int currentScore, int dartThrown, bool gamemode){
    if(currentScore - dartThrown == 0){
      if(gamemode){
        return dartThrown<=20; //single out
      }else return dartThrown<=40 && dartThrown.isEven; //dupli out
    }
    return false;
  }
}


class Game extends StatefulWidget {
  final int numberOfPlayers;
  final List<String> playerNames;
  final int mainScore;
  bool gameMode; //true za single out, false za dupli out
  Game({super.key, required this.numberOfPlayers, required this.playerNames, required this.mainScore, required this.gameMode});

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
    print(widget.gameMode);
  }

  void callSnackBarMessage(String message){
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  void submitScore(){
    GameScore score = GameScore(
        (int.tryParse(_dart1controller.text) ?? 0).clamp(0, 60),
        (int.tryParse(_dart2controller.text) ?? 0).clamp(0, 60),
        (int.tryParse(_dart3controller.text) ?? 0).clamp(0, 60),
        currentPlayer);
    scoreList.add(score);



    setState(() {
      int previousScore = playerScores[currentPlayer - 1];
      int currentScore = previousScore;

      bool hasWonGame = false;

      // Dart 1
      if (currentScore - score.dart1 >= 0) {
        currentScore -= score.dart1;
        print("provjera za prvu strelicu");
        if (score.hasWon(currentScore, score.dart1, widget.gameMode)) {
          hasWonGame = true;
          callSnackBarMessage(currentPlayerName + " has won!");

        }
      } else{
        print("revert");
        playerScores[currentPlayer - 1] = previousScore;  // Revert to previous score
      }

      if (currentScore - score.dart2 >= 0) {
        currentScore -= score.dart2;
        print("provjera za 2 strelicu");
        if (score.hasWon(currentScore, score.dart2, widget.gameMode)) {
          hasWonGame = true;
          callSnackBarMessage(currentPlayerName + " has won!");

        }
      } else{
        print("revert");
        playerScores[currentPlayer - 1] = previousScore;  // Revert to previous score
      }

      if (currentScore - score.dart3 >= 0) {
        currentScore -= score.dart3;
        print("provjera za 3 strelicu");
        if (score.hasWon(currentScore, score.dart3, widget.gameMode)) {
          hasWonGame = true;
          callSnackBarMessage(currentPlayerName + " has won!");

        }
      }else{
        print("revert");
        playerScores[currentPlayer - 1] = previousScore;  // Revert to previous score
      }

      playerScores[currentPlayer-1] = currentScore;
      //playerScores[currentPlayer-1] -= score.sumDarts();
      // Move to the next player if not won
      if (!hasWonGame) {
        currentPlayer = (currentPlayer % widget.numberOfPlayers) + 1;
        currentPlayerName = widget.playerNames[currentPlayer-1];
        currentPlayerValue = playerScores[currentPlayer-1];
      }
      });
    print(playerScores);

    _dart1controller.clear();
    _dart2controller.clear();
    _dart3controller.clear();
  }

  void undoLastScore() {
    if (scoreList.isNotEmpty) {
      setState(() {
        GameScore lastScore = scoreList.removeLast();
        playerScores[lastScore.playerFlag - 1] += lastScore.sumDarts();
        currentPlayer = lastScore.playerFlag;

        currentPlayerValue = playerScores[currentPlayer-1];
        currentPlayerName = widget.playerNames[currentPlayer-1];
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Navbar(initialPlayerNames: widget.playerNames, initialPlayerScores: playerScores),
      appBar: AppBar(
        leading: Builder(
            builder: (BuildContext context){
              return IconButton(
                icon: Icon(Icons.person),
                onPressed: (){
                  Scaffold.of(context).openDrawer();
                },
              );
            }
        ),
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[

              ElevatedButton(onPressed: submitScore, child: Text("Submit score")),
              ElevatedButton(onPressed: undoLastScore, child: Text("Undo last round")),

            ],
          )

        ],
      )
    );

  }
}

