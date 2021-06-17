import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:mqtt_app/modules/core/managers/MQTTManager.dart';
import 'package:provider/provider.dart';
import 'package:flutter_hsvcolor_picker/flutter_hsvcolor_picker.dart';

enum SingingCharacter { lafayette, jefferson }

class lightinside extends StatefulWidget {
  final String title;
  final String pub;
  final int qos;
  lightinside({this.title, this.pub, this.qos});

  @override
  State<StatefulWidget> createState() {
    return _lightinside();
  }
}

class _lightinside extends State<lightinside> {
  SingingCharacter _character = SingingCharacter.lafayette;
  List<Color> currentColors = [Colors.limeAccent, Colors.green];
  final TextEditingController _messageTextController = TextEditingController();
  final TextEditingController _topicTextController = TextEditingController();
  final _controller = ScrollController();
  // var _scaffoldKey = new GlobalKey<ScaffoldState>();
  // bool _hasMessage = false;
  // bool _hasTopic = false;
  bool _retainValue = false;
  // bool _saveNeeded = false;
  // int _qosValue = 0;
  // String _messageContent;
  //String _topicContent = 'temp/con';
  MQTTManager _manager;
  bool _keypadShown = false;
  bool hasflashlight = true; //to set is there any flashlight ?
  bool isturnon = false; //to set if flash light is on or off
  IconData flashicon = Icons.flash_off; //icon for lashlight button
  Color flashbtncolor = Colors.deepOrangeAccent; //color for flash button
  var test;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _messageTextController.dispose();
    _topicTextController.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  // void initState() {
  //   Future.delayed(Duration.zero,() async {
  //      //we use Future.delayed because there is async function inside it.
  //      bool istherelight = await Flashlight.hasFlashlight;
  //      setState(() {
  //         hasflashlight = istherelight;
  //      });
  //   });
  //   super.initState();
  // }
  // void changeColors(List<Color> colors) =>
  //     setState(() => currentColors = colors);

  @override
  Widget build(BuildContext context) {
    _manager = Provider.of<MQTTManager>(context);
    var _dialVisible = true;
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: Container(
        width: double.infinity,
        height: MediaQuery.of(context).size.height,
        alignment: Alignment.center,
        padding: EdgeInsets.all(40),
        //set width and height of outermost wrapper to 100%;
        child: flashlightbutton(),
      ),
    );
  }

  Color pickerColor = Color(0xff443a49);
  Color currentColor = Color(0xff443a49);

// ValueChanged<Color> callback
  void changeColor(Color color) {
    setState(() => pickerColor = color);
  }

  Widget flashlightbutton() {
    // List<Color> currentColors = [Colors.limeAccent, Colors.green];
    // Color currentColor = Colors.limeAccent;
    // void changeColor(Color color) => setState(() => currentColor = color);
    Color _customColor = Colors.red;
    var myColor = _customColor;
    var hex = '#${myColor.value.toRadixString(16)}';
    if (hasflashlight) {
      return SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SingleChildScrollView(
              child: new ColorPicker(
                color: Colors.red,
                onChanged: (value) {
                  setState(() {
                    _customColor = value;
                  });
                  hex = '#${_customColor.value.toRadixString(16)}';
                  print("\n\n\ncolor----------$hex");
                  hex = hex[0] +
                      hex[3] +
                      hex[4] +
                      hex[5] +
                      hex[6] +
                      hex[7] +
                      hex[8];
                  _manager.publishColor(
                      hex.toString(), widget.qos, widget.pub, _retainValue);
                  test = hex;
                },
              ),
            ),
            // Text("Your device has flash light."),
            // Text(isturnon ? "Flash is ON" : 'Flash is OFF'),
            const SizedBox(height: 40),
            // const SizedBox(height: 10),
            ListTile(
              title: const Text('HEX'),
              leading: Radio<SingingCharacter>(
                value: SingingCharacter.lafayette,
                groupValue: _character,
                onChanged: (SingingCharacter value) {
                  setState(() {
                    _character = value;
                  });
                },
              ),
            ),
            ListTile(
                title: const Text('Number String'),
                leading: Radio<SingingCharacter>(
                  value: SingingCharacter.jefferson,
                  groupValue: _character,
                  onChanged: (SingingCharacter value) {
                    setState(() {
                      _character = value;
                    });
                  },
                )),

            const SizedBox(height: 40),
            Container(
              child: RaisedButton(
                elevation: 5.0,
                onPressed: () async {
                  _manager.publishColor(
                      test.toString(), widget.qos, widget.pub, _retainValue);
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
              /*icon: Icon(
                  flashicon,
                  color: Colors.white,
                ),
                color: flashbtncolor,
                label: Text(
                  isturnon ? 'TURN OFF' : 'TURN ON',
                  style: TextStyle(color: Colors.white),
                ),*/
            ),
          ],
        ),
      );
    } else {
      return Text("Your device do not have flash light.");
    }
  }

  /*Widget _buildHEXCheck() {
    return Container(
      height: 20.0,
      child: Row(
        children: <Widget>[
          Theme(
            data: ThemeData(unselectedWidgetColor: Colors.white),
            child: Checkbox(
              value: _ws,
              checkColor: Colors.green,
              activeColor: Colors.white,
              onChanged: (value) {
                setState(() {
                  _ws = value;
                  if(value == true)
                    _wsint = 1;
                  else
                    _wsint = 0;
                });
              },
            ),
          ),
          Text(
            'Ws/Wss',
            style: kLabelStyle,
          ),
        ],
      ),
    );
  }

  Widget _buildNumericCheck() {
    return Container(
      height: 20.0,
      child: Row(
        children: <Widget>[
          Theme(
            data: ThemeData(unselectedWidgetColor: Colors.white),
            child: Checkbox(
              value: _ssl,
              checkColor: Colors.green,
              activeColor: Colors.white,
              onChanged: (value) {
                setState(() {
                  _ssl = value;
                  if(value == true)
                    _sslint = 1;
                  else
                    _sslint = 0;
                });
              },
            ),
          ),
          Text(
            'TLS/SSL',
            style: kLabelStyle,
          ),
        ],
      ),
    );
  }*/
}
