import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:minigames/main.dart';
import 'package:nearby_connections/nearby_connections.dart';

class OfferPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      builder: (context) => OffersState(),
      child: Scaffold(
          appBar: AppBar(
            title: Text("Player Search"),
            actions: <Widget>[
              _searchButton(),
              _stopButton(),
            ],
          ),
          body: OfferPageBody()),
    );
  }
}

class _searchButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return IconButton(
      icon: Icon(Icons.search),
      onPressed: () async {
        try {
          bool a = await Nearby().startAdvertising(
              Provider.of<GameState>(context).selfPlayer.fancyName,
              Strategy.P2P_STAR,
              onConnectionInitiated: (String id,ConnectionInfo info) {
              // Called whenever a discoverer requests connection
              print("$id found with ${info.endpointName}");
              },
              onConnectionResult: (String id,Status status) {
              // Called when connection is accepted/rejected
              },
              onDisconnected: (String id) {
              // Callled whenever a discoverer disconnects from advertiser
              },
          );
          Provider.of<OffersState>(context).searchingChange(true);
      } catch (exception) {
          // platform exceptions like unable to start bluetooth or
          // insufficient permissions
          print(exception);
      }
      }
    );
  }
}

class _stopButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return IconButton(
      icon: Icon(Icons.cancel),
      onPressed: () async {
      await Nearby().stopAdvertising();
      Provider.of<OffersState>(context).searchingChange(false);
    }
    );
  }

}

class OffersState with ChangeNotifier{
  bool isSearching = false;
void searchingChange(bool state){
  isSearching = state;
  notifyListeners();
}
}

class OfferPageBody extends StatefulWidget {
  @override
  _OfferPageBodyState createState() => _OfferPageBodyState();
}

class _OfferPageBodyState extends State<OfferPageBody> {
  _OfferPageBodyState();
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          if (Provider.of<OffersState>(context).isSearching == true)
          ...[Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text("Searching for players", textAlign: TextAlign.center),
          ), Padding(
            padding: const EdgeInsets.all(8.0),
            child: CircularProgressIndicator(),
          ),
        Divider()]
        else
        ...[Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text("Not searching", textAlign: TextAlign.center),
        ),
      Divider()]
        ]
      ),
    );
  }
}

void playerWantsToJoin(String id, ConnectionInfo info, BuildContext context) {
  showModalBottomSheet(
    context: context,
    builder:
  );
}
