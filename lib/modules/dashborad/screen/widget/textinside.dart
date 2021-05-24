import 'package:flutter/material.dart';
import 'package:mqtt_app/helpers/database_helper.dart';
import 'package:mqtt_app/modules/core/managers/MQTTManager.dart';
import 'package:provider/provider.dart';

class textinside extends StatefulWidget {
  final String title;
  final String pub;
  final int qos;
  textinside({this.title, this.pub, this.qos});

  @override
  textinsideState createState() => textinsideState();
}

class textinsideState extends State<textinside> {
  final _controller = ScrollController();
  final TextEditingController _text = TextEditingController();
  void dispose() {
    _controller.dispose();
    super.dispose();
  }


  bool _hasMessage = false;
  String _messageContent;
  MQTTManager _manager;

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    _manager = Provider.of<MQTTManager>(context);
    if (_controller.hasClients) {
      _controller.jumpTo(_controller.position.maxScrollExtent);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextFormField(
              controller: _text,
              decoration: const InputDecoration(labelText: 'Message', filled: true),
              style: theme.textTheme.headline4,
              maxLines: 2,
              validator: (value) {
                if (value.isEmpty) {
                  return 'Please enter some text';
                  }
                },
              onSaved: (String value) {
                setState(() {
                  _hasMessage = value.isNotEmpty;
                  if (_hasMessage) {
                    _messageContent = value;
                  }
                });
              },
            ),
            RaisedButton(
              elevation: 5.0,
              onPressed: () async {
                  _manager.publish(_text.text, widget.qos, widget.pub, false);
              },
              padding: EdgeInsets.all(10.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0),
              ),
              color: Colors.white,
              child: Text(
                'Save',
                style: TextStyle(
                  color: Color(0xFF527DAA),
                  letterSpacing: 1.5,
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'OpenSans',
                ),
              ),
            ),

          ],
        ),
      ),

    );
  }
}