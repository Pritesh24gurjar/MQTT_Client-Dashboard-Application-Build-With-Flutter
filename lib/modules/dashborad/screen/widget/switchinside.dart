import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mqtt_app/modules/core/managers/MQTTManager.dart';
import 'package:provider/provider.dart';

class switchinside extends StatefulWidget {
  final String title;
  final String pub;
  final int qos;
  switchinside({this.title, this.pub, this.qos});

  @override
  _switchinsideState createState() => _switchinsideState();
}

class _switchinsideState extends State<switchinside> {
  MQTTManager _manager;
  String sent = 'On';
  var isTurnon = false;
  var col = Color(0XFF26282B);

  List<Color> colors = [Colors.black, Colors.black45, Colors.black54];
  bool status = false;

  @override
  Widget build(BuildContext context) {
    _manager = Provider.of<MQTTManager>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
        widget.title,
        style: TextStyle(color: Colors.black87),
      ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[

            CupertinoSwitch(
              trackColor: Colors.grey[500],
              activeColor: Colors.blue[400],
              value: status,
              onChanged: (value) {
                setState(() {
                  status = value;
                  value == true
                      ? sent = 'ON'
                      : sent = 'OFF';
                });
                _manager.publish(sent, widget.qos, widget.pub, false);
              },
            ),
            SizedBox(height: 12.0,),
            Text('Value : $status', style: TextStyle(
                color: Colors.black,
                fontSize: 20.0
            ),)
          ],
        ),
      ),
    );
  }
}