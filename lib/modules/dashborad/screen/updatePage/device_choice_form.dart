import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mqtt_app/helpers/database_helper.dart';
import 'package:mqtt_app/models/devices.dart';
import 'package:mqtt_app/models/devicechoice.dart';
import 'package:select_form_field/select_form_field.dart';
import 'package:mqtt_app/widgets/widgets.dart';

class Device_choice_form extends StatefulWidget {
  final Devices devices;
  //final Deviceschoice deviceschoice;

  Device_choice_form({@required this.devices,/*this.deviceschoice*/});
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<Device_choice_form> {
  var selectedCurrency, selectedType;
  int _devicechoiceId;
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
  final TextEditingController _payload = TextEditingController();
  final TextEditingController _label = TextEditingController();

  FocusNode _titleFocus;
  FocusNode _descriptionFocus;
  FocusNode _todoFocus;

  bool _contentVisile = false;

  @override
  void initState() {
    if (widget.devices != null) {
      // Set visibility to true
      _contentVisile = true;

      _taskTitle = widget.devices.title;
      _devSub = widget.devices.sub;
      _taskId = widget.devices.id;
      _qosValue = widget.devices.qos;
      _devRetain = widget.devices.retain;
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
    double _height = MediaQuery.of(context).size.height;
    final ThemeData theme = Theme.of(context);
    return Scaffold(
        appBar: AppBar(
          title: Container(
            alignment: Alignment.centerLeft,
            child: Text("Update device",
                style: TextStyle(
                  color: Colors.white,
                )),
          ),
        ),
        body: Stack(children: <Widget>[
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
                      await _dbHelper.updateDeviceTitle(_taskId, value);
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
                      await _dbHelper.updateDevicesSub(_taskId, value);
                    }),

                new Column(
                    children: <Widget>[
                      RaisedButton(
                        elevation: 5.0,
                        onPressed: () async {
                          //showAlertDialog(context);
                          _buildiglod(context);
                        },
                        padding: EdgeInsets.all(10.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        color: Colors.white,
                        child: Text(
                          'Add Option',
                          style: TextStyle(
                            color: Color(0xFF527DAA),
                            letterSpacing: 1.5,
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'OpenSans',
                          ),
                        ),
                      ),
                      Container(
                        height: _height * 0.3,
                        child: FutureBuilder(
                          initialData: [],
                          future: _dbHelper.getDeviceschoice(widget.devices.id),
                          builder: (context, snapshot) {
                            return Container(
                              //height: _height * 0.3,
                              child: ListView.builder(
                                scrollDirection: Axis.vertical,
                                itemCount: snapshot.data.length,
                                itemBuilder: (context, index) {
                                  return GestureDetector(
                                    onLongPress: () async {
                                      //_dbHelper.getRoomdiv(widget.room.id)
                                      /*Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => RoomDivForm(
                                        // roomdivinfo: widget.room,
                                        roomdevices: snapshot.data[index],
                                      )));
                                      */
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          right: 8.0, top: 16, bottom: 16),
                                      child: CustomPayLoad(
                                        payload: snapshot.data[index].payloads,
                                        label: snapshot.data[index].label,
                                        divinfo: snapshot.data[index],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            );
                          },
                        ),
                      ),
                      //CustomPayLoad(),
                    ]
                ),

                SizedBox(height: 40.0),
                _buildQosChoiceChips(),

                SizedBox(
                  height: 5.0,
                ),
                Container(
                  decoration: BoxDecoration(
                      border: Border(
                          bottom: BorderSide(color: theme.dividerColor))),
                  child: Row(children: <Widget>[
                    Checkbox(
                        value: _retainValue,
                        onChanged: (bool value) {
                          setState(() async {
                            _retainValue = value;
                            _saveNeeded = true;
                            await _dbHelper.updateDevicesretain(
                                _taskId, _retainValue.toString());
                          });
                        }),
                    const Text('Retain message'),
                    SizedBox(
                      height: 15.0,
                    ),
                  ]),
                ),
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
                    await _dbHelper.delete_device(_taskId);
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
        ]));
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

  Future<void> _buildiglod(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  TextField(
                      controller: _payload,
                      decoration: const InputDecoration(
                        labelText: 'Payload',
                      ),
                      keyboardType: TextInputType.text),
                  TextField(
                      controller: _label,
                      decoration: const InputDecoration(
                        labelText: 'Label',
                      ),
                      keyboardType: TextInputType.text),
                ],
              ),
            ),
            actions: <Widget>[
              RaisedButton(
                elevation: 5.0,
                onPressed: () async {
                  /*Deviceschoice _newDevicechoice = Deviceschoice(
                    payloads: _payload.text,
                    label: _label.text,
                    deviceId: widget.devicesinfo,
                  );
                  _devicechoiceId = await _dbHelper.insertDeviceschoice(_newDevicechoice);
                  _payload.clear();
                  _label.clear();
                  setState(() {Navigator.pop(context);});*/
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
