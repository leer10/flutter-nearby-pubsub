import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:minigames/main.dart';

class WelcomePage extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(title: Text("Select a Connection"),),
      body: WelcomePageBody()
    );
  }

}

class WelcomePageBody extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Text("Hey ${Provider.of<GameState>(context).selfPlayer.fancyName}!", textAlign: TextAlign.center, style:TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          //Text("Do you want to"),
          RaisedButton(child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text("OFFER A GAME", style:TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ), onPressed:() {print("Offer pressed");} ,),
          RaisedButton(child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text("JOIN A GAME", style:TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ), onPressed:() {print("Join pressed");} ,)
        ],
      ),
    );
  }

}
