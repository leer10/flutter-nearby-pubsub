import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/material.dart';
//import 'package:stream_channel/stream_channel.dart';
import 'package:nearby_connections/nearby_connections.dart';


class ActiveStreams extends ChangeNotifier{
  List<NearbyStream> nearbyStreams = [];
  NearbyStream selectedStream;

  void addStream(NearbyStream stream){
    nearbyStreams.add(stream);
    selectedStream = stream;
    notifyListeners();
  }

  void selectStream(NearbyStream stream){
    selectedStream = stream;
    notifyListeners();
  }
}

class LoopbackStream {
  final _localClientIn = StreamController<String>();
  final _localClientOut = StreamController<String>();

  final _localServerIn = StreamController<String>();
  final _localServerOut = StreamController<String>();

LoopbackStream(){
  _localClientOut.stream.forEach((data) => _localServerIn.add(data));
  _localServerOut.stream.forEach((data) => _localClientIn.add(data));
}

  Stream<String> get clientStream => _localClientIn.stream;
  StreamSink<String> get clientSink => _localClientOut.sink;

  Stream<String> get serverStream => _localServerIn.stream;
  StreamSink<String> get serverSink => _localServerOut.sink;
}

class NearbyStream {
  final String id;
  final _incontroller = StreamController<String>();
  final _outcontroller = StreamController<String>();
  void receive (Uint8List bytes) {
    _incontroller.sink.add(String.fromCharCodes(bytes));
  }

  static final Map<String, NearbyStream> _cache =
    <String, NearbyStream>{};

  factory NearbyStream(String id) {
    return _cache.putIfAbsent(
      id, () => NearbyStream._internal(id));
  }
//   Nearby().sendPayload(cId, Uint8List.fromList(a.codeUnits));
  NearbyStream._internal(this.id){
this._outcontroller.stream.forEach((data) {
  Nearby().sendBytesPayload(id, Uint8List.fromList(data.codeUnits));
  print("sent to $id, $data");
});
  }

  Stream<String> get stream => _incontroller.stream;
  StreamSink<String> get sink => _outcontroller.sink;
}
