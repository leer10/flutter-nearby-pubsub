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


class NearbyStream {
  final String id;
  final _incontroller = StreamController<Uint8List>();
  final _outcontroller = StreamController<Uint8List>();
  void receive (Uint8List bytes) {
    _incontroller.sink.add(bytes);
  }

  static final Map<String, NearbyStream> _cache =
    <String, NearbyStream>{};

  factory NearbyStream(String id) {
    return _cache.putIfAbsent(
      id, () => NearbyStream._internal(id));
  }
//   Nearby().sendPayload(cId, Uint8List.fromList(a.codeUnits));
  NearbyStream._internal(this.id){
this._outcontroller.stream.forEach((data) => Nearby().sendPayload(id, Uint8List.fromList(data)));
  }

  Stream<Uint8List> get stream => _incontroller.stream;
  StreamSink<Uint8List> get sink => _outcontroller.sink;
}
