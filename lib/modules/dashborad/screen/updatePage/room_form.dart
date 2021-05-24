import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mqtt_app/helpers/database_helper.dart';
// import 'package:mqtt_app/models/devices.dart';
import 'package:mqtt_app/models/room.dart';

class Room_form extends StatefulWidget {
  final Room room;

  Room_form({@required this.room});
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<Room_form> {
  var selectedCurrency, selectedType;
  final GlobalKey<FormState> _formKeyValue = new GlobalKey<FormState>();
  // List<String> _accountType = <String>[
  //   'Savings',
  //   'Deposit',
  //   'Checking',
  //   'Brokerage'
  // ];
  DatabaseHelper _dbHelper = DatabaseHelper();
  int _qosValue = 0;
  bool _retainValue = false;
  bool _saveNeeded = false;
  int _taskId = 0;
  String _taskTitle = "";
  String _devSub = "";
  String _devRetain = "";
  String _devQos = "";

  FocusNode _titleFocus;
  FocusNode _descriptionFocus;
  FocusNode _todoFocus;

  bool _contentVisile = false;

  @override
  void initState() {
    if (widget.room != null) {
      // Set visibility to true
      _contentVisile = true;

      _taskTitle = widget.room.title;
      _devSub = widget.room.sub;
      _taskId = widget.room.id;
      // _devQos = widget.room.qos;
      // _devRetain = widget.room.retain;
    }

    _titleFocus = FocusNode();
    _descriptionFocus = FocusNode();
    _todoFocus = FocusNode();

    super.initState();
  }

  @override
  void dispose() {
    _titleFocus.dispose();
    _descriptionFocus.dispose();
    _todoFocus.dispose();

    super.dispose();
  }

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
            child: Text("Update Room",
                style: TextStyle(
                  color: Colors.white,
                )),
          ),
        ),
        body: Stack(
          children: <Widget>[
            Form(
              key: _formKeyValue,
              // autovalidateMode: true,
              child: new ListView(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                children: <Widget>[
                  SizedBox(height: 20.0),
                  new TextFormField(
                      controller: TextEditingController()..text = _taskTitle,
                      decoration: const InputDecoration(
                        icon: const Icon(
                          FontAwesomeIcons.tv,
                          color: Colors.blueAccent,
                        ),
                        hintText: 'Enter your device name',
                        labelText: 'Device name ',
                      ),
                      onChanged: (value) async {
                        await _dbHelper.updateRoomTitle(_taskId, value);
                      },
                      keyboardType: TextInputType.text),
                  new TextFormField(
                      controller: TextEditingController()..text = _devSub,
                      decoration: const InputDecoration(
                        icon: const Icon(
                          Icons.topic,
                          color: Colors.blueAccent,
                        ),
                        hintText: 'Enter Topic to Subscribe',
                        labelText: 'Topic',
                      ),
                      onChanged: (value) async {
                        await _dbHelper.updateRoomSub(_taskId, value);
                      }),

                  SizedBox(
                    height: 15.0,
                  ),
                  _buildConnectBtn(),
                ],
              ),
            ),
            Visibility(
              visible: _contentVisile,
              child: Positioned(
                bottom: 24.0,
                right: 24.0,
                child: GestureDetector(
                  onTap: () async {
                    if (_taskId != 0) {
                      await _dbHelper.delete_room(_taskId);
                      Navigator.pop(context);
                    }
                  },
                  child: Container(
                    width: 60.0,
                    height: 60.0,
                    decoration: BoxDecoration(
                      color: Color(0xFFFE3577),
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: Image(
                      image: AssetImage(
                        "assets/images/delete_icon.png",
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
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
          Navigator.pop(context);
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
              setState(() async {
                _qosValue = selected ? index : null;
                await _dbHelper.updateDevicesqos(_taskId, _qosValue);
              });
            },
          );
        },
      ).toList(),
    );
  }
}
