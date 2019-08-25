import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:minigames/main.dart';

class StartingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Nearby Minigames"),
        ),
        body: NameInputForm());
  }
}

class NameInputForm extends StatefulWidget {
  @override
  _NameInputFormState createState() => _NameInputFormState();
}

class _NameInputFormState extends State<NameInputForm> {
  final controller = TextEditingController();
  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
      Text("What do you want to call yourself?"),
      Padding(
        padding: const EdgeInsets.all(24.0),
        child: TextField(
          controller: controller,
          textCapitalization: TextCapitalization.words,
          onSubmitted: (name) {
            Provider.of<GameState>(context).addSelf(name);
            print("$name added as self!");
            Navigator.pushNamedAndRemoveUntil(
                context, '/welcome', (_) => false);
          },
        ),
      )
    ]);
  }
}
