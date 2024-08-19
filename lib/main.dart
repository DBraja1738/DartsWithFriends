import 'dart:io';

import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(
    home: Home(),

  )
  );
}

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[600],
      appBar: AppBar(
        title: const Text("Darts with friends"),
        centerTitle: true,
        backgroundColor: Colors.green[900],
      ),
      body: Row(

        children: <Widget>[
          Expanded(
            flex: 2,
            child: Container(color: Colors.green,),

          ),
          Expanded(
              flex: 6,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                        onPressed: (){
                        },
                        child: Text("Start")
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                        onPressed: (){
                        },
                        child: Text("Settings")
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      onPressed: (){
                        exit(0);
                      },
                      style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.red[500]
                      ),
                      child: Text("EXIT"),

                    ),
                  ),

                ],
              )

          ),
          Expanded(
            flex: 2,
            child: Container(color: Colors.green,),

          ),

        ],
      ),
    );




  }


}

