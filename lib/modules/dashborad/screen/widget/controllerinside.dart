import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mqtt_app/modules/core/managers/MQTTManager.dart';
import 'package:provider/provider.dart';

class controllerinside extends StatefulWidget {
  final String title;
  final String pub;
  final int qos;
  controllerinside({this.title, this.pub, this.qos});

  @override
  _controllerinsideState createState() => _controllerinsideState();

}

class _controllerinsideState extends State<controllerinside> {
  MQTTManager _manager;
  bool _keypadShown = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _manager = Provider.of<MQTTManager>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 30.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 50),
            Visibility(
              visible: !_keypadShown,
              child: Expanded(
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: ControllerButton(
                        child: Text(
                          "OK",
                          style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                        onPressed: () async {
                          //await tv.sendKey(KEY_CODES.KEY_ENTER);
                          _manager.publish('OK', widget.qos, widget.pub, false);
                        },
                      ),
                    ),
                    Align(
                      alignment: Alignment(0, -0.6),
                      child: ControllerButton(
                        borderRadius: 10,
                        child: Icon(Icons.arrow_drop_up, size: 30, color: Colors.white),
                        onPressed: () async {
                          //await tv.sendKey(KEY_CODES.KEY_UP);
                          _manager.publish('UP', widget.qos, widget.pub, false);
                        },
                      ),
                    ),
                    Align(
                      alignment: Alignment(0, 0.6),
                      child: ControllerButton(
                        borderRadius: 10,
                        child: Icon(Icons.arrow_drop_down, size: 30, color: Colors.white),
                        onPressed: () async {
                          //await tv.sendKey(KEY_CODES.KEY_DOWN);
                          _manager.publish('DOWN', widget.qos, widget.pub, false);
                        },
                      ),
                    ),
                    Align(
                      alignment: Alignment(0.6, 0),
                      child: ControllerButton(
                        borderRadius: 10,
                        child: Icon(Icons.arrow_right, size: 30, color: Colors.white),
                        onPressed: () async {
                          //await tv.sendKey(KEY_CODES.KEY_RIGHT);
                          _manager.publish('RIGHT', widget.qos, widget.pub, false);
                        },
                      ),
                    ),
                    Align(
                      alignment: Alignment(-0.7, 0),
                      child: ControllerButton(
                        borderRadius: 10,
                        child: Icon(Icons.arrow_left, size: 30, color: Colors.white),
                        onPressed: () async {
                         // await tv.sendKey(KEY_CODES.KEY_LEFT);
                          _manager.publish('LEFT', widget.qos, widget.pub, false);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 50),
            SizedBox(height: 50),
            SizedBox(height: 50),
              ],
            ),
        ),
    ),
    );
  }
}

class ControllerButton extends StatelessWidget {
  final Widget child;
  final VoidCallback onPressed;
  final double borderRadius;
  final Color color;
  const ControllerButton({Key key, this.child, this.borderRadius = 30, this.color, this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
        color: Color(0XFF2e2e2e),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          colors: [Color(0XFF1c1c1c), Color(0XFF383838)],
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0XFF1c1c1c),
            offset: Offset(5.0, 5.0),
            blurRadius: 10.0,
          ),
          BoxShadow(
            color: Color(0XFF404040),
            offset: Offset(-5.0, -5.0),
            blurRadius: 10.0,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(2),
        child: Container(
          decoration: BoxDecoration(
            // shape: BoxShape.circle,
            borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
            gradient: const LinearGradient(begin: Alignment.topLeft, colors: [Color(0XFF303030), Color(0XFF1a1a1a)]),
          ),
          child: MaterialButton(
            color: color,
            minWidth: 0,
            onPressed: onPressed,
            shape: CircleBorder(),
            child: child,
          ),
        ),
      ),
    );
  }
}