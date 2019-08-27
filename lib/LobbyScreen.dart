import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:minigames/main.dart';
import 'package:nearby_connections/nearby_connections.dart';

class LobbyPage extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(title: Text("${Provider.of<GameState>(context).PlayerList.firstWhere((player) => player.isHost == true).fancyName}'s Lobby"),),
      body: Placeholder(),
    );
  }

}
