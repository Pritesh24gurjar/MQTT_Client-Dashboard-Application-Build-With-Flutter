import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mqtt_app/helpers/database_helper.dart';
import 'package:mqtt_app/models/roomdevices.dart';

class RoomDivset extends StatefulWidget {
  final roomdivnfo;

  RoomDivset({@required this.roomdivnfo});
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<RoomDivset> {
  final TextEditingController _title = TextEditingController();
  final TextEditingController _topic = TextEditingController();
  DatabaseHelper _dbHelper = DatabaseHelper();
  var selectedCurrency, selectedType;
  final GlobalKey<FormState> _formKeyValue = new GlobalKey<FormState>();
  // List<String> _accountType = <String>[
  //   'Savings',
  //   'Deposit',
  //   'Checking',
  //   'Brokerage'
  // ];
  int _deviceId;
  int _qosValue = 0;
  bool _retainValue = false;
  bool _saveNeeded = false;
  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Scaffold(
        appBar: AppBar(
          // leading: IconButton(
          //     icon: Icon(
          //       FontAwesomeIcons.bars,
          //       color: Colors.white,
          //     ),
          //     onPressed: () {}),
          title: Container(
            alignment: Alignment.centerLeft,
            child: Text("Add device",
                style: TextStyle(
                  color: Colors.white,
                )),
          ),
        ),
        body: Form(
          key: _formKeyValue,
          // autovalidateMode: true,
          child: new ListView(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            children: <Widget>[
              SizedBox(height: 20.0),
              new TextFormField(
                  controller: _title,
                  decoration: const InputDecoration(
                    icon: const Icon(
                      FontAwesomeIcons.tv,
                      color: Colors.blueAccent,
                    ),
                    hintText: 'Enter your device name',
                    labelText: 'Device name ',
                  ),
                  keyboardType: TextInputType.text),
              new TextFormField(
                controller: _topic,
                decoration: const InputDecoration(
                  icon: const Icon(
                    Icons.topic,
                    color: Colors.blueAccent,
                  ),
                  hintText: 'Enter Topic to Subscribe',
                  labelText: 'Topic',
                ),
              ),

              SizedBox(height: 40.0),
              _buildQosChoiceChips(),
              SizedBox(
                height: 5.0,
              ),

              SizedBox(
                height: 15.0,
              ),
              _buildConnectBtn(),
            ],
          ),
        ));
  }

  Widget _buildConnectBtn() {
    // MQTTAppConnectionState state = _manager.currentState.getAppConnectionState;
    return Container(
      padding: EdgeInsets.symmetric(vertical: 25.0),
      width: double.infinity,
      child: RaisedButton(
        elevation: 5.0,
        onPressed: () async {
          Roomdevices _newRoomdiv = Roomdevices(
            title: _title.text,
            pub: _topic.text,
            qos: _qosValue,
            roomid: widget.roomdivnfo.id,
            // qos: _qosValue,
          );

          _deviceId = await _dbHelper.insertRoomdiv(_newRoomdiv);
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
    );
  }

  Wrap _buildQosChoiceChips() {
    return Wrap(
      spacing: 4.0,
      children: List<Widget>.generate(
        3,
            (int index) {
          return ChoiceChip(
            label: Text('QoS level $index'),
            selected: _qosValue == index,
            onSelected: (bool selected) {
              setState(() {
                _qosValue = selected ? index : null;
              });
            },
          );
        },
      ).toList(),
    );
  }
}