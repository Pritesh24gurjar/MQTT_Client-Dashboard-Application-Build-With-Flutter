import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mqtt_app/helpers/database_helper.dart';
import 'package:mqtt_app/models/devices.dart';
import 'package:mqtt_app/models/devicechoice.dart';
import 'package:mqtt_app/models/devicechoicetemp.dart';
import 'package:select_form_field/select_form_field.dart';
import 'package:flutter/services.dart';
import 'dashborad.dart';
import 'package:mqtt_app/widgets/widgets.dart';

enum choiceinage { static, payloadfrom }

class Set_device extends StatefulWidget {
  final devicesinfo;
  Set_device({@required this.devicesinfo});
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<Set_device> {
  choiceinage _character = choiceinage.static;
  final TextEditingController _title = TextEditingController();
  final TextEditingController _topic = TextEditingController();
  final TextEditingController _min = TextEditingController();
  final TextEditingController _max = TextEditingController();
  final TextEditingController _payload = TextEditingController();
  final TextEditingController _label = TextEditingController();
  final TextEditingController _url = TextEditingController();
  final TextEditingController _urlclick = TextEditingController();

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
  int _devicechoiceId;
  int _devicechoiceIdTemp;
  int _qosValue = 0;
  bool _retainValue = false;
  bool _saveNeeded = false;
  var test;
  String savetext = "";
  String saveweb = "";
  String savewebclick = "";
  double min = 0.0;
  double max = 100.0;
  final key = GlobalKey<ScaffoldState>();
  bool isVisible = false;
  bool isVisiblechoice = false;
  bool isVisibleimage = false;

  final List<Map<String, dynamic>> _items = [
    {
      'value': 'TextValue',
      'label': 'Text',
      'icon': Icon(Icons.grade),
    },
    {
      'value': 'SetSwitch',
      'label': 'Switch/button',
      'icon': Icon(Icons.toggle_off),
    },
    {
      'value': 'Setthermostat',
      'label': 'Range/progress',
      'icon': Icon(Icons.thermostat_sharp),
    },

    {
      'value': 'muiltChoice',
      'label': 'Multi Choice',
      'icon': Icon(Icons.grade),
    },
    {
      'value': 'colorValue',
      'label': 'Color',
      'icon': Icon(Icons.grade),
    },
    {
      'value': 'ImageValue',
      'label': 'Image',
      //'enable': false,
      'icon': Icon(Icons.grade),
    },
    {
      'value': 'SetController',
      'label': 'Controller',
      'icon': Icon(Icons.videogame_asset),
      'textStyle': TextStyle(color: Colors.red),
    },
  ];

  @override
  Widget build(BuildContext context) {
    double _height = MediaQuery.of(context).size.height;
    final ThemeData theme = Theme.of(context);
    return WillPopScope(
        onWillPop: () async
          {
            await _dbHelper.delete_devicechoiceTempAll();
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>  Dashborad()),
            );
          },
        child: Scaffold(
        key: key,
        appBar: AppBar(

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

            SelectFormField(
              type: SelectFormFieldType.dropdown, // or can be dialog
              icon: Icon(Icons.import_export),
              labelText: 'Style',
              items: _items,
              //controller: _test,
              onChanged: (val) {
                test = val;
                //print(test);
               // print(_test);
                setState(() {
                  if(test.toString() == "Setthermostat")
                  {
                    _payload.clear();
                    _label.clear();
                    _min.clear();
                    _max.clear();
                    isVisiblechoice = false;
                    isVisibleimage = false;
                    isVisible = true;
                  }
                  else if(test.toString() == "muiltChoice")
                  {
                    _payload.clear();
                    _label.clear();
                    _min.clear();
                    _max.clear();
                    isVisible = false;
                    isVisibleimage = false;
                    isVisiblechoice = true;
                  }
                  else if(test.toString() == "ImageValue")
                  {
                    _payload.clear();
                    _label.clear();
                    _min.clear();
                    _max.clear();
                    isVisible = false;
                    isVisiblechoice = false;
                    isVisibleimage = true;
                  }
                  else
                  {
                    _payload.clear();
                    _label.clear();
                    _min.clear();
                    _max.clear();
                    isVisible = false;
                    isVisiblechoice = false;
                    isVisibleimage = false;
                  }
                });
                },
              onSaved: (val) => test = val,
            ),
          SizedBox(height: 15.0),

          Visibility(
            visible: isVisible,
            child: new Row(
              children: <Widget>[
                new Flexible(
                  child: new TextField(
                    controller: _min..text = min.toString(),
                    decoration: const InputDecoration(helperText: "Min"),
                    style: Theme.of(context).textTheme.body1,
                    keyboardType: TextInputType.text
                  ),
                ),
                SizedBox(width: 40,),
                new Flexible(
                  child: new TextField(
                    controller: _max..text = max.toString(),
                    decoration: const InputDecoration(helperText: "Max"),
                    style: Theme.of(context).textTheme.body1,
                    keyboardType: TextInputType.text
                  ),
                ),
              ],
            ),
          ),

          Visibility(
            visible: isVisiblechoice,
            child: new Column(
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
                  future: _dbHelper.getDeviceschoiceTemp(),
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
          )
          ),

              Visibility(
                visible: isVisibleimage,
                child: new Column(
                  children: <Widget>[
                    Container(
                      height: _height * 0.06,
                      child: ListTile(
                        title: const Text('from a static url'),
                        leading: Radio<choiceinage>(
                          value: choiceinage.static,
                          groupValue: _character,
                          onChanged: (choiceinage value) {
                            setState(() {
                              _character = value;
                              print(_character);
                            });
                          },
                        ),
                      ),
                    ),
                  Container(
                    height: _height * 0.06,
                    child: ListTile(
                                title: const Text('from payload'),
                                leading: Radio<choiceinage>(
                                  value: choiceinage.payloadfrom,
                                  groupValue: _character,
                                  onChanged: (choiceinage value) {
                                    setState(() {
                                      _character = value;
                                      print(_character);
                                    });
                                  },
                                )
                            ),
                             ),
                    Container(
                      height: _height * 0.09,
                      child: new TextField(
                        controller: _url,
                        decoration: const InputDecoration(helperText: "Image URL"),
                        style: Theme.of(context).textTheme.body1,
                      ),
                    ),
                    Container(
                      height: _height * 0.09,
                      child: new TextField(
                        controller: _urlclick,
                        decoration: const InputDecoration(helperText: "Image URL When click"),
                        style: Theme.of(context).textTheme.body1,
                      ),
                    )
                  ],

                ),
              ),

              SizedBox(height: 20.0),
              _buildQosChoiceChips(),
              SizedBox(
                height: 5.0,
              ),
              Container(
                decoration: BoxDecoration(
                    border:
                        Border(bottom: BorderSide(color: theme.dividerColor))),
                child: Row(children: <Widget>[
                  Checkbox(
                      value: _retainValue,
                      onChanged: (bool value) {
                        setState(() {
                          _retainValue = value;
                          _saveNeeded = true;
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
        )));
  }



  Widget _buildConnectBtn() {
    // MQTTAppConnectionState state = _manager.currentState.getAppConnectionState;
    return Container(
      padding: EdgeInsets.symmetric(vertical: 25.0),
      width: double.infinity,
      child: RaisedButton(
        elevation: 5.0,
        onPressed: () async {
          if(test.toString() == "muiltChoice") {
            Devices _newDevice = Devices(
              title: _title.text,
              sub: _topic.text,
              qos: _qosValue,
              retain: _retainValue.toString(),
              style: test.toString(),
              savetext: savetext,
              min: min,
              max: max,
              saveweb : _url.text,
              savewebclick : savewebclick,
              saveRadio : _character.toString(),
              // qos: _qosValue,
            );
            //Navigator.pop(context);

            _deviceId = await _dbHelper.insertDevices(_newDevice);
            print(_deviceId);
            await _dbHelper.plaacedevice_devicechoice(_deviceId);
            //await _dbHelper.copy_devicechoiceTempAll();
            await _dbHelper.delete_devicechoiceTempAll();

            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>  Dashborad()),
            );
          }

          else if(_min.text.isEmpty == true && _max.text.isEmpty == true )
            {
              if(_urlclick.text.isEmpty == true){
                Devices _newDevice = Devices(
                  title: _title.text,
                  sub: _topic.text,
                  qos: _qosValue,
                  retain: _retainValue.toString(),
                  style: test.toString(),
                  savetext: savetext,
                  min: min,
                  max: max,
                  saveweb : _url.text,
                  savewebclick : savewebclick,
                  saveRadio : _character.toString(),
                  // qos: _qosValue,
                );
                //Navigator.pop(context);

                _deviceId = await _dbHelper.insertDevices(_newDevice);
                await _dbHelper.delete_devicechoiceTempAll();

                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>  Dashborad()),
                );
              }
              else
              {
                Devices _newDevice = Devices(
                  title: _title.text,
                  sub: _topic.text,
                  qos: _qosValue,
                  retain: _retainValue.toString(),
                  style: test.toString(),
                  savetext: savetext,
                  min: min,
                  max: max,
                  saveweb : saveweb,
                  savewebclick : _urlclick.text,
                  saveRadio : _character.toString(),
                  // qos: _qosValue,
                );
                //Navigator.pop(context);

                _deviceId = await _dbHelper.insertDevices(_newDevice);
                await _dbHelper.delete_devicechoiceTempAll();

                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>  Dashborad()),
                );
              }
            }

          else
          {
            Devices _newDevice = Devices(
              title: _title.text,
              sub: _topic.text,
              qos: _qosValue,
              retain: _retainValue.toString(),
              style: test.toString(),
              savetext: savetext,
              min: double.parse(_min.text),
              max: double.parse(_max.text),
              saveweb : saveweb,
              saveRadio : _character.toString(),
              // qos: _qosValue,
            );
            //Navigator.pop(context);

            _deviceId = await _dbHelper.insertDevices(_newDevice);
            await _dbHelper.delete_devicechoiceTempAll();

            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>  Dashborad()),
            );
          }

        },
        padding: EdgeInsets.all(10.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        color: Colors.white,
        child: Text(
          'Set',
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

  Widget buildBox({
    @required String text,
    @required Color color,
  }) =>
      GestureDetector(
        onTap: () {
          final snackBar = SnackBar(
            padding: EdgeInsets.symmetric(vertical: 8),
            backgroundColor: color,
            content: Text(
              '$text is clickable!!',
              style: TextStyle(fontSize: 24),
              textAlign: TextAlign.center,
            ),
          );

          key.currentState
            ..removeCurrentSnackBar()
            ..showSnackBar(snackBar);
        },
        child: Container(
          width: double.infinity,
          height: 80,
          color: color,
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 32,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      );

  Widget buildButton({
    @required String text,
    @required Color color,
    @required VoidCallback onClicked,
  }) =>
      RaisedButton(
        color: color,
        child: Text(
          text,
          style: TextStyle(fontSize: 24, color: Colors.white),
        ),
        onPressed: onClicked,
        shape: StadiumBorder(),
        padding: EdgeInsets.symmetric(vertical: 16),
      );

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
                       DeviceschoiceTemp _newDevicechoicetemp = DeviceschoiceTemp(
                         payloads: _payload.text,
                         label: _label.text,
                         deviceId: widget.devicesinfo,
                       );

                      Deviceschoice _newDevicechoice = Deviceschoice(
                        payloads: _payload.text,
                        label: _label.text,
                        deviceId: 0,
                      );

                       _devicechoiceIdTemp = await _dbHelper.insertDeviceschoiceTemp(_newDevicechoicetemp);
                      _devicechoiceId = await _dbHelper.insertDeviceschoice(_newDevicechoice);
                       _payload.clear();
                       _label.clear();
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