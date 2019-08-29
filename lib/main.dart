import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pub_sub/pub_sub.dart';
import 'package:pub_sub/json_rpc_2.dart';
import 'dart:async';
import 'package:stream_channel/stream_channel.dart';
import 'package:minigames/NearbyClasses.dart';


//Classes
import 'package:minigames/playerClasses.dart';

//Screens
import 'package:minigames/OpeningScreen.dart';
import 'package:minigames/WelcomeScreen.dart';
import 'package:minigames/OfferScreen.dart';
import 'package:minigames/JoinScreen.dart';
import 'package:minigames/LobbyScreen.dart';

void main() => runApp(
    ChangeNotifierProvider(builder: (context) => GameState(), child: MyApp()));

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Nearby Minigames',
        theme: ThemeData(
          // This is the theme of your application.
          //
          // Try running your application with "flutter run". You'll see the
          // application has a blue toolbar. Then, without quitting the app, try
          // changing the primarySwatch below to Colors.green and then invoke
          // "hot reload" (press "r" in the console where you ran "flutter run",
          // or simply save your changes to "hot reload" in a Flutter IDE).
          // Notice that the counter didn't reset back to zero; the application
          // is not restarted.
          primarySwatch: Colors.blue,
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => StartingPage(),
          '/welcome': (context) => WelcomePage(),
          '/welcome/offer': (context) => OfferPage(),
          '/welcome/join': (context) => JoinPage(),
          '/lobby': (context) => LobbyPage(),
        });
  }
}

class GameState with ChangeNotifier {
  List<Player> PlayerList = [];
  Player selfPlayer;
  // For server
  bool isServerInitalized = false;
  Server server;
  StreamController<StreamChannel<String>> controller;
  Stream<StreamChannel<String>> incomingConnections;
  JsonRpc2Adapter adapter;

  // For client
  bool isClientInitalized = false;
  JsonRpc2Client client;



  void addSelf(String name) {
    selfPlayer = Player(fancyName: name, isSelf: true, deviceID: "This Device");
    PlayerList.add(selfPlayer);

  }
  void addPlayer({@required fancyName, @required deviceID, isHost}){
    PlayerList.add(Player(fancyName: fancyName, deviceID: deviceID, isHost: isHost));
    notifyListeners();
  }

  void initalizeServer() {
    if (!isServerInitalized) {
    print("Initalizing server");
    controller = StreamController<StreamChannel<String>>();
    incomingConnections = controller.stream;
    adapter = JsonRpc2Adapter(incomingConnections, isTrusted: true);
    server = Server([adapter])
    ..start();
    connectWithSelf();
  isServerInitalized = true;} else {print("server already initalized!");}
  }

  void connectWithClient(String id){
    StreamChannel<String> clientChannel = StreamChannel(NearbyStream(id).stream, NearbyStream(id).sink);
    controller.add(clientChannel);
    print("added client $id");
  }

  void connectWithSelf(){
    LoopbackStream loopbackStream = LoopbackStream();
    StreamChannel<String> localClientChannel = StreamChannel(loopbackStream.clientStream, loopbackStream.clientSink);
    StreamChannel<String> localServerChannel = StreamChannel(loopbackStream.serverStream, loopbackStream.serverSink);
    client = JsonRpc2Client(null, localClientChannel);
    controller.add(localServerChannel);
    print("added self");
  }

  void connectWithServer(String id){
    StreamChannel<String> serverChannel = StreamChannel(NearbyStream(id).stream, NearbyStream(id).sink);
    client = JsonRpc2Client(null, serverChannel);
  }
}
