
class WebRTCNetwork{
  Server server;
  List<Pair> pairs;

  WebRTCNetwork(String server_uri){
    server = new Server(server_uri);

  }

  send(Identity to, Message msj){

  }

  sendAll(Message msj){

  }

  int get totalPairs() => pairs.length;

  int get cantDirectConnections() => pairs.where(p.directConnection).count();

  Stream<Message> onMessage;
  Stream<Command> onCommand;
  Stream<Identity> onNewConnection;
}
