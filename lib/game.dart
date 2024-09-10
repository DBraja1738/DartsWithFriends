import 'package:flutter/material.dart';
import "package:flutter/services.dart";
class GameScore{
  int dart1;
  int dart2;
  int dart3;
  int playerFlag;

  GameScore(this.dart1, this.dart2, this.dart3, this.playerFlag);

  int sumDarts(){
    return dart1+dart2+dart3;
  }
}


class Game extends StatefulWidget {
  const Game({super.key});

  @override
  State<Game> createState() => _GameState();
}


class _GameState extends State<Game> {
  TextEditingController _dart1controller = TextEditingController();
  TextEditingController _dart2controller = TextEditingController();
  TextEditingController _dart3controller = TextEditingController();

  int mainScore = 501;
  List<int> playerScores = [];
  int currentPlayer = 1;
  List<GameScore> scoreList = [];

  @override
  void initState(){
    super.initState();
    playerScores = List<int>.filled(2,501);
  }

  void changePlayer(){
    if(currentPlayer==1){
      currentPlayer=2;
    }else currentPlayer=1;
  }

  void submitScore(){

    setState(() {
      GameScore score = GameScore(int.parse(_dart1controller.text),int.parse(_dart2controller.text),int.parse(_dart3controller.text), currentPlayer);
      scoreList.add(score);
      playerScores[currentPlayer-1] = playerScores[currentPlayer-1] - score.sumDarts();
      currentPlayer = (currentPlayer%2) + 1;
    });
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
                  Text("Player 1"),
                  Text("$playerScores"),
                ],
              ),
              SizedBox(width: 50,),
              Column(
                children: [
                  Text("PLAYER 2"),
                  Text("$playerScores"),
                ],
              ),
            ],
          ),
          Row(
            children: <Widget>[
              Flexible(
                  child: TextField(
                    controller: _dart1controller,
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                  )
              ),
              SizedBox(width: 10,),
              Flexible(child: TextField(
                controller: _dart2controller,
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly,
                ],
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                ),
              )),
              SizedBox(width: 10,),
              Flexible(child: TextField(
                controller: _dart3controller,
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly,
                ],
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                ),
              )),
            ],
          ),
          ElevatedButton(onPressed: submitScore, child: Text("Submit score")),
        ],
      )
    );
  }
}

