import 'dart:convert';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_socket_io/flutter_socket_io.dart';
import 'package:flutter_socket_io/socket_io_manager.dart';
import 'package:jitsi_meet/jitsi_meet.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  SocketIO socketIO;
  String _nameRoom;
  var roomText = TextEditingController(text: "plugintestroom");
  var subjectText = TextEditingController(text: "My Plugin Test Meeting");
  var nameText = TextEditingController(text: "Plugin Test User");
  var emailText = TextEditingController(text: "fake@email.com");
  var isAudioOnly = true;
  var isAudioMuted = true;
  var isVideoMuted = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
          actions: <Widget>[
            PopupMenuButton(
                icon: Icon(Icons.settings),
                offset: Offset.fromDirection(pi / 2, 48.0),
                itemBuilder: (context) => <PopupMenuEntry>[
                      PopupMenuItem(
                          child: FlatButton(
                        child: Text("Change Server URL (TODO)"),
                        onPressed: () {},
                      )),
                      PopupMenuItem(
                          child: FlatButton(
                        child: Text("Use Token (TODO)"),
                        onPressed: () {},
                      )),
                    ]),
          ],
        ),
        body: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 16.0,
          ),
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 24.0,
                ),
                TextField(
                  controller: roomText,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Room",
                  ),
                ),
                SizedBox(
                  height: 16.0,
                ),
                /* TextField(
                  controller: subjectText,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Subject",
                  ),
                ), */
                SizedBox(
                  height: 16.0,
                ),
                TextField(
                  controller: nameText,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Display Name",
                  ),
                ),
                SizedBox(
                  height: 16.0,
                ),
                /* TextField(
                  controller: emailText,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Email",
                  ),
                ), */
               /* SizedBox(
                  height: 16.0,
                ),
                CheckboxListTile(
                  title: Text("Audio Only"),
                  value: isAudioOnly,
                  onChanged: _onAudioOnlyChanged,
                ),
                SizedBox(
                  height: 16.0,
                ),
                CheckboxListTile(
                  title: Text("Audio Muted"),
                  value: isAudioMuted,
                  onChanged: _onAudioMutedChanged,
                ),
                SizedBox(
                  height: 16.0,
                ),
                CheckboxListTile(
                  title: Text("Video Muted"),
                  value: isVideoMuted,
                  onChanged: _onVideoMutedChanged,
                ),
                Divider(
                  height: 48.0,
                  thickness: 2.0,
                ),*/
                SizedBox(
                  height: 64.0,
                  width: double.maxFinite,
                  child: RaisedButton(
                    onPressed: () {
                      _joinMeeting();
                    },
                    child: Text(
                      "Join Meeting",
                      style: TextStyle(color: Colors.white),
                    ),
                    color: Colors.blue,
                  ),
                ),
                new RaisedButton(
                  child: const Text('CONNECT  SOCKET 01',
                      style: TextStyle(color: Colors.white)),
                  color: Theme.of(context).accentColor,
                  elevation: 0.0,
                  splashColor: Colors.blueGrey,
                  onPressed: () {
                    _connectSocket01();
//                _sendChatMessage(mTextMessageController.text);
                  },
                ),
                new RaisedButton(
              child: const Text('DISCONNECT',
                  style: TextStyle(color: Colors.white)),
              color: Theme.of(context).accentColor,
              elevation: 0.0,
              splashColor: Colors.blueGrey,
              onPressed: () {
                _disconnectSocket();
//                _sendChatMessage(mTextMessageController.text);
              },
            ),  RaisedButton(
              child:
                  const Text('DESTROY', style: TextStyle(color: Colors.white)),
              color: Theme.of(context).accentColor,
              elevation: 0.0,
              splashColor: Colors.blueGrey,
              onPressed: () {
                _destroySocket();
//                _sendChatMessage(mTextMessageController.text);
              },
            ),
                SizedBox(
                  height: 48.0,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _onAudioOnlyChanged(bool value) {
    setState(() {
      isAudioOnly = value;
    });
  }

  _onAudioMutedChanged(bool value) {
    setState(() {
      isAudioMuted = value;
    });
  }

  _onVideoMutedChanged(bool value) {
    setState(() {
      isVideoMuted = value;
    });
  }
  
  _connectSocket01() {
    //update your domain before using
    /*socketIO = new SocketIO("http://127.0.0.1:3000", "/chat",
        query: "userId=21031", socketStatusCallback: _socketStatus);*/
    socketIO = SocketIOManager().createSocketIO(
        "https://cryptic-garden-43170.herokuapp.com", "/",
        query: "", socketStatusCallback: _socketStatus);

    //call init socket before doing anything
    socketIO.init();

    //subscribe event
    socketIO.subscribe("on-join", _onSocketInfo);

    //connect socket
    socketIO.connect();
  }
  _disconnectSocket() {
    if (socketIO != null) {
      socketIO.disconnect();
    }
  }

  _onSocketInfo(dynamic data) {
    print("Socket info: " + data);
    setState(() {
       //roomText.text=data;
    });
     _showDialog();
     //_joinMeeting();
  }
   _destroySocket() {
    if (socketIO != null) {
      SocketIOManager().destroySocket(socketIO);
    }
  }


  _socketStatus(dynamic data) {
    print("Status "+data);
    if (data == "connect") {
      // Send message to server on the 'chat' event.
      var data = {
        'username':  nameText.text,
      };
      String result = json.encode(data);
      socketIO.sendMessage('join',result , _callBack);
    }
  }

  void _callBack(dynamic data) {
    print("object in connect === " + data);
    setState(() {
      //roomText.text=data;
    });
  }

  _joinMeeting() async {
    try {
      var options = JitsiMeetingOptions()
        ..room = roomText.text
        ..subject = subjectText.text
        ..userDisplayName = nameText.text
        ..userEmail = emailText.text
        ..audioOnly = isAudioOnly
        ..audioMuted = isAudioMuted
        ..videoMuted = isVideoMuted;

      JitsiMeetingResponse response = await JitsiMeet.joinMeeting(options);

      if (response.isSuccess) {
        print("RESPONSE >>>>>>>>>>" + response.message);
        //_connectSocket01();
      } else {}
    } catch (error) {
      debugPrint("error: $error");
    }
  }
   void _showDialog() {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Aviso"),
          content: new Text("El ticket fue enviado para validar"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: Icon(Icons.call_end),
              
              onPressed: () {
                Navigator.of(context).pop();
                
              },
            ),
            new FlatButton(
              child: Icon(Icons.call),
              onPressed: () {
                _joinMeeting();
                Navigator.of(context).pop();
                
              },
            ),
          ],
        );
      },
    );
  }
}
