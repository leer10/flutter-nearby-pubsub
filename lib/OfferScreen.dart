import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:minigames/main.dart';
import 'package:minigames/NearbyClasses.dart';
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
              IconButton(
                icon: Icon(Icons.arrow_forward),
                onPressed: (){
                  Navigator.pushNamed(context, '/lobby');
                }
              )
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
              connectionRequestPrompt(id, info, context);
              },
              onConnectionResult: (String id,Status status) {
              // Called when connection is accepted/rejected
              },
              onDisconnected: (String id) {
              // Callled whenever a discoverer disconnects from advertiser
              },
          );
          //print("start advertising");
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
      Divider()],
      Expanded(
        child: ListView.builder(
          itemCount: Provider.of<GameState>(context).PlayerList.length,
          itemBuilder: (BuildContext context, int index) {
            return ListTile(
              title: Text(Provider.of<GameState>(context).PlayerList[index].fancyName),
              subtitle: Text(Provider.of<GameState>(context).PlayerList[index].deviceID),
            );
          }
        ),
      )
        ]
      ),
    );
  }
}

void connectionRequestPrompt(String id, ConnectionInfo info, BuildContext context) {
  showModalBottomSheet(
    context: context,
    builder: (builder) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
           Text("${info.endpointName} wants in!", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
         Row(
           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
           children:[
             RaisedButton(color: Colors.red, child: Text("REJECT"), onPressed: () async {
               Navigator.pop(context);
               try {
                      await Nearby().rejectConnection(id);
                    } catch (exception) {
                      print(exception);
                    }}),
            RaisedButton(color: Colors.green, child: Text("ACCEPT"), onPressed: () {
              Provider.of<GameState>(context).addPlayer(deviceID: id, fancyName: info.endpointName, isHost: false);
                    Navigator.pop(context);
                    Nearby().acceptConnection(
                      id,
                      onPayLoadRecieved: (endid, payload) {
                        print(endid + ": " + String.fromCharCodes(payload.bytes));
                        NearbyStream(endid).receive(payload.bytes);

                      },
                    );
                    Provider.of<GameState>(context).connectWithClient(id);
            }),
           ]
         )]),
      );
    }
  );
}
