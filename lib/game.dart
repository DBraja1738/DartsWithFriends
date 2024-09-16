import 'package:flutter/material.dart';
import "package:flutter/services.dart";
import 'dart:async';
import 'package:darts_with_friends/widgets/navbar.dart';
import 'package:darts_with_friends/firebaseOperations.dart';
import 'package:darts_with_friends/widgets/decorations.dart';
import 'package:vibration/vibration.dart';

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
      }else return dartThrown<=40 && dartThrown.isEven && dartThrown != 0; //dupli out
    }
    return false;
  }
}

class PlayerStats{
  int totalScore;
  int totalDartsThrown;
  PlayerStats(this.totalScore,this.totalDartsThrown);

  double threeDartAverage() {
    if (totalDartsThrown == 0) return 0; // Avoid division by zero
    return (totalScore / totalDartsThrown)*3;
  }

}


class Game extends StatefulWidget {

  final int numberOfPlayers;
  final List<String> playerNames;
  final int mainScore;
  final bool gameMode; //true za single out, false za dupli out
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
  List<PlayerStats> playerStats = [];

  @override
  void initState(){
    super.initState();

    currentPlayerValue = widget.mainScore;
    playerScores = List<int>.filled(widget.numberOfPlayers,widget.mainScore);
    playerStats = List<PlayerStats>.generate(widget.numberOfPlayers, (index)=>PlayerStats(0, 0),);
    currentPlayerName=widget.playerNames.first;

  }

  void playVictoryBuzz() async {
    // Check if the device has vibration capabilities
    if (await Vibration.hasVibrator() ?? false) {
      // [trajanje u ms, pauza u ms, ....]
      List<int> pattern = [500, 300, 500, 300, 700, 400, 500];

      // intenzitet vibracije ako ima podršku
      List<int>? intensities = [128, 255, 128, 255, 255, 128, 255];

      Vibration.vibrate(pattern: pattern, intensities: intensities);
    }
  }

  void shortBuzz() async {
    if (await Vibration.hasVibrator() ?? false) {
      Vibration.vibrate(duration: 100);
    }
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

    int dartSum = score.sumDarts();

    setState(() {
      if(currentPlayerValue - dartSum >= 0){
        playerStats[currentPlayer-1].totalScore += dartSum;
        playerStats[currentPlayer-1].totalDartsThrown +=3;
      }
      if(currentPlayerValue - dartSum == 0){
        callSnackBarMessage(currentPlayerName + " has won!");
        playVictoryBuzz();

        fetchWinnerUserAndUpdate(widget.playerNames[currentPlayer-1], playerStats[currentPlayer-1].totalDartsThrown, playerStats[currentPlayer-1].totalScore);
        playerStats.removeAt(currentPlayer-1);
        List<String> tempPlayerNames = widget.playerNames;
        tempPlayerNames.removeAt(currentPlayer-1);

        for(int i=0;i<tempPlayerNames.length;i++){
          fetchLoserUserAndUpdate(tempPlayerNames[i], playerStats[i].totalDartsThrown, playerStats[i].totalScore);
        }
        //tempPlayerNames.forEach((player){
         // fetchLoserUserAndUpdate(player);
        //});

        Timer(Duration(seconds: 3), (){
          Navigator.pop(context);
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

        shortBuzz();
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
        backgroundColor: Colors.green[900],
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
      body: Container(
        decoration: AppDecorations.boxDecoration,
        padding: EdgeInsets.all(20.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Column(

                  children: [
                  Text("Player: $currentPlayerName, $currentPlayer", style: AppDecorations.playerTextStyle,),
                  Text("$currentPlayerValue", style: AppDecorations.scoreTextStyle),
                  ],
                ),
              ],
            ),
          Row(
            children: <Widget>[
              Flexible(
                child: TextField(
                  controller: _dart1controller,
                  decoration: AppDecorations.inputDecoration,
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                )
              ),
              SizedBox(width: 10,),
              Flexible(
              child: TextField(
                controller: _dart2controller,
                decoration: AppDecorations.inputDecoration,
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly,
                ],
              )
              ),
              SizedBox(width: 10,),
              Flexible(
                child: TextField(
                  controller: _dart3controller,
                  decoration: AppDecorations.inputDecoration,
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                )
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[

              ElevatedButton(onPressed: submitScore, child: Text("Submit score"), style: AppDecorations.buttonStyle,),
              ElevatedButton(onPressed: undoLastScore, child: Text("Undo last round"), style: AppDecorations.buttonStyleRed,),

        ],
      )

      ],
    ),)
    );

  }
}

