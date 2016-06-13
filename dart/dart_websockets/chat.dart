library dartchat;

import 'dart:html';
import 'dart:async';
import 'dart:convert';

part 'message.dart';

class LoginScreenOverlay {
  Element _overlay;
  Element _register;
  Element _notice;
  Element _user;
  Element _signin;
  Element _info;

  ImageElement _spinner = new ImageElement(src: "images/spinner.gif", width: 48, height: 48);
  ImageElement _success = new ImageElement(src: "images/star.png", width: 48, height: 48);
  ImageElement _error = new ImageElement(src: "images/warning.png", width: 48, height: 48);
  Completer<String> _nameCompleter = new Completer();
  String _username;
  bool _nameValid;

  LoginScreenOverlay(this._overlay){
    _register = _overlay.querySelector("#register");
    _notice = _register.querySelector("#notice");
    _user = _register.querySelector("#user-name");
    _signin = _register.querySelector("#sign-in");
    _info = _register.querySelector("#info");

    _user.focus();

    _user.onChange.listen(_onUsernameEntered);
    _signin.onClick.listen(_onUsernameEntered);
  }

  bool _isValidName(String userName){
    if (userName.isEmpty){
      return false;
    }

    if (userName.length < 3){
      return false;
    }

    if (userName.length > 15){
      return false;
    }

    if (userName.startsWith(new RegExp(r'\d'))){
      return false;
    }

    if (userName.contains(new RegExp(r'\s'))){
      return false;
    }

    return true;
  }

  void _onUsernameEntered(Event e){
    String name = _user.value.trim();
    
    if (_isValidName(name)){
      _username = name;
      _nameValid = true;
      _user.value = "";
      _info.text = "";
      _nameCompleter.complete(_username);
    }
    else if (!_nameValid) {
      _info.text = "Invalid user name, Please try again";
      _user.value = "";
    }
  }

  Future<String> getUserName() {
    return _nameCompleter.future; 
  }

  void spinner(String text){
    this.clear();
    _register.children.add(_spinner);
    _notice.text = text;
  }

  void success(String text){
    this.clear();
    _notice.text = text;
    _register.children.add(_success);
  }


  void clear() {
    _register.children.remove(_user);
    _register.children.remove(_signin);
    _register.children.remove(_spinner);
    _register.children.remove(_success);
    _register.children.remove(_error);
    _register.children.remove(_info);
  }

  void error(String text, {String info: ""}){
    this.clear();
    _notice.text = text;
    _register.children.add(_error);
    _register.children.add(_info);
    _info.text = info;
  }

  void close(){
     _overlay.classes.clear();
     _overlay.classes.add("registered");
  }

  void show(){
    _overlay.classes.clear();
    _overlay.classes.add("unregistered");
  }
}

class MessageView {
  Element _messages;

  MessageView(this._messages);

  void displayMessage(Message m, {bool local: false}){
    _postElement(_messageToElement(m, local));
  }

  void displayNotice(NoticeMessage notice){
    _postElement(_noticeToElement(notice));
  }

  void _postElement(Element e){
    _messages.children.add(e);

    while(_messages.children.length > 1000){
      _messages.children.removeAt(0);
    }

    _messages.scrollTop = _messages.scrollHeight;
  }

  Element _messageToElement(Message m, bool local) {
    TableRowElement row = new TableRowElement();
    TableCellElement name = row.insertCell(0);
    if (local){
      name.classes.add('from-local');
    }
    else {
      name.classes.add('from-remote');
    }
    name.text = m.from;

    TableCellElement message = row.insertCell(1);
    message.classes.add('message');
    message.text = m.message;

    return row;
  }

  Element _noticeToElement(NoticeMessage m){
    TableRowElement row = new TableRowElement();
    TableCellElement name = row.insertCell(0);
    TableCellElement message = row.insertCell(1);

    message.classes.add('message');
    message.classes.add('notice');
    message.text = m.message;
  
    return row;
  }
}

class ServerConnection {
  WebSocket _socket;
  String _server;
  String _client;
  LoginScreenOverlay _overlay;

  ServerConnection(String where, String client, LoginScreenOverlay overlay){
    _client = client;
    _server = where;
    _overlay = overlay;
    _connect();
  }

  void _connect(){
    _overlay.spinner("Connecting to server");
    _socket = new WebSocket(_server); 
    _socket.onOpen.listen(_onConnect);
    _socket.onMessage.listen(_onMessage);
    _socket.onClose.listen(_onClose);
    _socket.onError.listen(_onError);
  }

  void _onConnect(Event e){
    _sendInitMessage();
    _overlay.success("Connected!");
    _overlay.close();
  }

  void _onMessage(MessageEvent m){
    APIMessage message = new APIMessage.fromJson(m.data);
    if (message == null){
      print("Failed to decode message: ${m.data}");
      return;
    }

    if (message.type == APIMessage.MESSAGE){
      messages.displayMessage(message as Message);
    }
    else if (message.type == APIMessage.NOTICE){
      messages.displayNotice(message as NoticeMessage);
    }
  }

  void _onClose(Event e){
    _overlay.error("Connection to server lost...", info: "Server closed connection");
    _overlay.show();
  }

  void _onError(Event e){
    _overlay.error("Error", info: "The WebSocket has failed!");
    _overlay.show();
  }

  void _sendInitMessage(){
    InitMessage init = new InitMessage(_client);
    send(init);
  }

  void send(APIMessage m){
    _socket.send(m.toJson()); 
  }
  
}

String username;
MessageView messages;
TextInputElement chatInput;
ServerConnection connection;

void main() {
  LoginScreenOverlay overlay = new LoginScreenOverlay(querySelector('#overlay')); 
  chatInput = querySelector('#chat-input');
  var sendButton = querySelector('#send-button');
  messages = new MessageView(querySelector('#message-body'));

  overlay.getUserName().then((String name) {
    username = name;
    connection = new ServerConnection('ws://relativity:8080/ws', username, overlay);
    chatInput.focus();
  });

  chatInput.onChange.listen(onUserMessage);
  chatInput.onClick.listen((Event e) => chatInput.focus());
  sendButton.onClick.listen(onUserMessage);
}

void onUserMessage(Event e){
  String input = chatInput.value.trim();
  chatInput.value = "";
  chatInput.focus();

  if (input.isEmpty){
    return;
  }

  Message msg = new Message(username, input);
  messages.displayMessage(msg, local: true);
  connection.send(msg);
}


