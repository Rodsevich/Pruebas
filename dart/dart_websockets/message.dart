part of dartchat;

/**
  An implementation of the Dart chat API. 
*/
class APIMessage {
  static const MESSAGE = "message";
  static const NOTICE = "notice";
  static const INIT = "init";
  static const UNKNOWN = "unknown";

  String _type;

  APIMessage(){
    _type = APIMessage.UNKNOWN;
  }

  /**
    Factory constructor that will build the appropriate
    API message object. It will build it from a json string
  */
  factory APIMessage.fromJson(String json){
    Map decoded = JSON.decode(json);
    switch (decoded["type"]){
      case APIMessage.MESSAGE:
        return new Message.fromMap(decoded);
      case APIMessage.INIT:
        return new InitMessage.fromMap(decoded);
      case APIMessage.NOTICE:
        return new NoticeMessage.fromMap(decoded);
      default:
        return new APIMessage();
    }
  }

  /**
    Factory constructor that will build the appropriate 
    API message object. It will build it from a Map object
  */
  factory APIMessage.fromMap(Map map){
    switch(map["type"]){
      case APIMessage.MESSAGE:
        return new Message.fromMap(map);
      case APIMessage.INIT:
        return new Message.fromMap(map);
      case APIMessage.NOTICE:
        return new Message.fromMap(map);
      default:
        return new APIMessage();
    }
  }
  
  /**
    Convert the api message object to a JSON string
  */
  String toJson() {
    Map msg = new Map();
    msg["type"] = _type;
    return JSON.encode(msg);
  }

  String get type => _type;
}

class Message extends APIMessage {
  String _from;
  String _to;
  String _message;

  Message(String from, String message, {String to: null}){
    this._type = APIMessage.MESSAGE;
    this._from = from;
    this._to = to;
    this._message = message;
  }

  Message.fromJson(String json){
    Map msg = JSON.decode(json);
    this._type = APIMessage.MESSAGE;
    this._from = msg["from"];
    this._to = msg["to"];
    this._message = msg["message"];
  }

  Message.fromMap(Map map){
    this._type = APIMessage.MESSAGE;
    this._from = map["from"];
    this._to = map["to"];
    this._message = map["message"];
  }

  @override
  String toJson() {
    Map msg = new Map();
    msg["type"] = this._type;
    msg["from"] = this._from;
    msg["to"] = this._to;
    msg["message"] = this._message;

    return JSON.encode(msg);
  }

  String get message => _message;
  String get from => _from;
  String get to => _to;
}

class InitMessage extends APIMessage {
  String _username;

  InitMessage(this._username){
    _type = APIMessage.INIT;
  }

  InitMessage.fromJson(String json){
    Map msg = JSON.decode(json);
    this._type = APIMessage.INIT;
    this._username = msg["username"];
  }

  InitMessage.fromMap(Map map){
    this._type = APIMessage.INIT;
    this._username = map["username"];
  }

  @override
  String toJson() {
    Map msg = new Map();
    msg["type"] = this._type;
    msg["username"] = this._username;
    return JSON.encode(msg);
  }

  String get username => _username;
}

class NoticeMessage extends APIMessage {
  String _message;

  NoticeMessage(this._message){
    _type = APIMessage.NOTICE;
  }

  NoticeMessage.fromJson(String json){
    Map msg = JSON.decode(json);
    _type = APIMessage.NOTICE;
    _message = msg["message"];
  }

  NoticeMessage.fromMap(Map map){
    _type = APIMessage.NOTICE;
    _message = map["message"];
  }

  @override
  String toJson(){
    Map msg = new Map();
    msg["type"] = _type;
    msg["message"] = _message;
    return JSON.encode(msg);
  }

  String get message => _message;
}

