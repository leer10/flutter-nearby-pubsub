import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:minigames/main.dart';
import 'package:minigames/NearbyClasses.dart';
import 'package:nearby_connections/nearby_connections.dart';

class JoinPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      builder: (context) => JoinsState(),
      child: Scaffold(
          appBar: AppBar(
            title: Text("Host Search"),
            actions: <Widget>[
              _hostSearchButton(),
              _hostSearchStopButton(),
            ],
          ),
          body: JoinPageBody()),
    );
  }
}

class _hostSearchButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return IconButton(
      icon: Icon(Icons.search),
      onPressed: () async {
        try {
        bool a = await Nearby().startDiscovery(
        Provider.of<GameState>(context).selfPlayer.fancyName,
        Strategy.P2P_STAR,
        onEndpointFound: (String id,String userName, String serviceId) {
          print("$id found with name $userName and $serviceId");
          Provider.of<JoinsState>(context).addHost(id, userName, serviceId);

        },
        onEndpointLost: (String id) {
            //called when an advertiser is lost (only if we weren't connected to it )
        },
        );
        } catch (e) {
          print(e);
          Provider.of<JoinsState>(context).searchingChange(false);
        }
        Provider.of<JoinsState>(context).searchingChange(true);
      }
    );
  }
}

class _hostSearchStopButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return IconButton(
      icon: Icon(Icons.cancel),
      onPressed: () async {
      await Nearby().stopDiscovery();
      Provider.of<JoinsState>(context).searchingChange(false);
    }
    );
  }

}

class JoinsState with ChangeNotifier{
  bool isSearching = false;
  List<Host> HostList = [];
void searchingChange(bool state){
  isSearching = state;
  notifyListeners();
}
void addHost (String id, String userName, String serviceId){
  if (HostList.every((element) => element.id != id)){
  HostList.add(Host(id, userName, serviceId));
  notifyListeners();} else {print("$userName $id already discovered");}
}
}

class Host extends StatelessWidget {
  final String id;
  final String userName;
  final String serviceId;
  Host(this.id, this.userName, this.serviceId);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(userName),
      subtitle: Text(id),
      trailing: RaisedButton(
        child: Text("CONNECT"),
        onPressed: (){
          print("This device wants to connect with $userName");
          try{
    Nearby().requestConnection(
        Provider.of<GameState>(context).selfPlayer.fancyName,
        id,
        onConnectionInitiated: (id, info) {
          connectionRequestPrompt(id, info, context);
        },
        onConnectionResult: (id, status) {
        },
        onDisconnected: (id) {
        },
    );
    }catch(exception){
        print(exception);
        }
        }
      )
    );
  }
}

class JoinPageBody extends StatefulWidget {
  @override
  _JoinPageBodyState createState() => _JoinPageBodyState();
}

class _JoinPageBodyState extends State<JoinPageBody> {
  _JoinPageBodyState();
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          if (Provider.of<JoinsState>(context).isSearching == true)
          ...[Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text("Searching for hosts", textAlign: TextAlign.center),
          ), Padding(
            padding: const EdgeInsets.all(8.0),
            child: CircularProgressIndicator(),
          ),
        Divider()],
        if (Provider.of<JoinsState>(context).isSearching == false)
        ...[Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text("Not searching", textAlign: TextAlign.center),
        ),
      Divider(),],
    Expanded(
      child: ListView.builder(
        itemCount: Provider.of<JoinsState>(context).HostList.length,
        itemBuilder: (BuildContext context, int index) {
          return Provider.of<JoinsState>(context).HostList[index];
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
              Provider.of<GameState>(context).addPlayer(deviceID: id, fancyName: info.endpointName, isHost: true);
                    Navigator.pop(context);
                    Navigator.pushNamedAndRemoveUntil(
                        context, '/lobby', (_) => false);
                    Nearby().acceptConnection(
                      id,
                      onPayLoadRecieved: (endid, payload) {
                        print(endid + ": " + String.fromCharCodes(payload.bytes));
                        NearbyStream(endid).receive(payload.bytes);
                      },
                    );
                    Provider.of<GameState>(context).connectWithServer(id);
            }),
           ]
         )]),
      );
    }
  );
}
