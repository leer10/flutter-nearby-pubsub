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
      //body: Placeholder(),
      body: Column(
        children: <Widget>[
          Builder(
            builder: (context) {
              bool isSubbed = false;
              return RaisedButton(child: Text("subscribe"),
              onPressed: (){
                if (!isSubbed) {
                print(Provider.of<GameState>(context).client.clientId);
              var greetingcatch = Provider.of<GameState>(context).client.subscribe("greeting");
              greetingcatch.then((sub) {
                print("listening to sub");
    sub.listen((msg) {
              print('got a greeting');
              final snackBar = SnackBar(content: Text("Got a greeting! It says: $msg"),);
              Scaffold.of(context).showSnackBar(snackBar);
    });
  });
isSubbed = true;} else {print("already subbed!");}});
            }
          ),
          RaisedButton(
            child: Text("emit a Hello World"),
            onPressed: (){
              Provider.of<GameState>(context).client.publish("greeting", "Hello World");
            }
          ),
          MessageForm(),
        ],
      )
    );
  }

}

class MessageForm extends StatefulWidget{
  @override
  _MessageFormState createState() => _MessageFormState();
}

class _MessageFormState extends State<MessageForm> {
  final myController = TextEditingController();

  @override
  void dispose(){
myController.dispose();
super.dispose();
}

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Row(
      children: <Widget>[
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: myController,
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration(
                hintText: "Enter a greeting"
              )
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: IconButton(
            icon: Icon(Icons.send),
            onPressed: (){
              Provider.of<GameState>(context).client.publish("greeting", myController.text);
            }
          ),
        )
      ],
    );
  }
}
