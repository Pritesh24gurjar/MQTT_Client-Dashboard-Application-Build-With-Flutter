import 'package:flutter/material.dart';
import 'package:mqtt_app/modules/core/managers/MQTTManager.dart';
import 'package:provider/provider.dart';
import 'package:mqtt_app/models/devices.dart';
import 'package:mqtt_app/models/devicechoice.dart';
import 'package:mqtt_app/helpers/database_helper.dart';

class CustomPayLoad extends StatefulWidget {
  // final Room roomdivinfo;
  final Deviceschoice devicess;
  final String payload;
  final String label;
  final divinfo;
  CustomPayLoad({
    this.payload,
    this.label,
    this.divinfo,
    @required this.devicess
  });

  // CustomSlider({@required this.roomdivinfo});
  @override
  _CustomPayLoadState createState() => _CustomPayLoadState();
}

class _CustomPayLoadState extends State<CustomPayLoad> {
  final TextEditingController _payload = TextEditingController();
  final TextEditingController _label = TextEditingController();
  DatabaseHelper _dbHelper = DatabaseHelper();
  double value = 0;
  bool _contentVisile = false;
  MQTTManager _manager;
  int _taskId = 0;
  String _tasklabel = "";
  String _taskpayload  = "";
  FocusNode _labelFocus;
  FocusNode _payloadFocus;
  @override
  void initState() {
    if (widget.divinfo != null) {
      // Set visibility to true
      _contentVisile = true;

      _tasklabel = widget.divinfo.label;
      _taskpayload = widget.divinfo.payloads;
      _taskId = widget.divinfo.id;
      // _devRetain = widget.devices.retain;
    }

    _labelFocus = FocusNode();
    _payloadFocus = FocusNode();

    super.initState();
  }

  @override


  Widget build(BuildContext context) {
    _manager = Provider.of<MQTTManager>(context);
    return Container(
      child: Row(
        children: [
          Card(
            elevation: 3,
            shadowColor: Colors.grey[300],
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            // margin: EdgeInsets.all(20),
            child: Container(
              height: 60,
              width: 200,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          widget.payload,
                          style: TextStyle(color: Colors.grey),
                        ),
                        Text(
                          widget.label,
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              _buildiglod(context);
              /*Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => RoomDivForm_slider(
                        // roomdivinfo: widget.room,
                        roomdevices: widget.roomdivinfo,
                      )));*/
            },
            alignment: Alignment.topRight,
          ),
        ],
      ),
    );
  }

  Future<void> _buildiglod(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  TextField(
                      controller: TextEditingController()..text = _taskpayload,
                      decoration: const InputDecoration(
                        labelText: 'Payload',
                      ),
                      onChanged: (value) async {
                        await _dbHelper.updateDevicePayload(_taskId, value);
                      },
                      keyboardType: TextInputType.text),
                  TextField(
                      controller: TextEditingController()..text = _tasklabel,
                      decoration: const InputDecoration(
                        labelText: 'Label',
                      ),
                      onChanged: (value) async {
                        await _dbHelper.updateDevicesLabel(_taskId, value);
                      },
                      keyboardType: TextInputType.text),
                ],
              ),
            ),
            actions: <Widget>[
              RaisedButton(
                elevation: 5.0,
                onPressed: () async {
                  setState(() {Navigator.pop(context);});
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
          );
        });
  }
}
