import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

//Classes
import 'package:minigames/playerClasses.dart';

//Screens
import 'package:minigames/OpeningScreen.dart';
import 'package:minigames/WelcomeScreen.dart';


void main() => runApp(ChangeNotifierProvider(builder: (context) => GameState(), child: MyApp()));


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
      }
    );
  }
}

class GameState with ChangeNotifier {
List<Player> PlayerList = [];
Player selfPlayer;

void addSelf(String name){
  selfPlayer = Player(fancyName: name, isSelf: true);
}
}
