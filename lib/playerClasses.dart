class Player {
  String fancyName;
  String deviceID;
  bool isSelf;
  bool isHost;
  Player(
      {String this.fancyName, String this.deviceID, bool this.isSelf = false, bool this.isHost = false});
}
