// import 'package:flashlight/flashlight.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:mqtt_app/modules/core/managers/MQTTManager.dart';
import 'package:mqtt_app/modules/helpers/screen_route.dart';
// import 'package:mqtt_app/modules/core/models/MQTTAppState.dart';
// import 'package:mqtt_app/modules/core/widgets/status_bar.dart';
// import 'package:mqtt_app/modules/helpers/screen_route.dart';
// import 'package:mqtt_app/modules/helpers/status_info_message_utils.dart';
import 'package:provider/provider.dart';
// import 'package:mqtt_app/modules/message/screen/message_screen.dart';
// import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_hsvcolor_picker/flutter_hsvcolor_picker.dart';

class FlashLight extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _FlashLight();
  }
}

class _FlashLight extends State<FlashLight> {
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
  String _topicContent = 'temp/con';
  MQTTManager _manager;

  bool hasflashlight = true; //to set is there any flashlight ?
  bool isturnon = false; //to set if flash light is on or off
  IconData flashicon = Icons.flash_off; //icon for lashlight button
  Color flashbtncolor = Colors.deepOrangeAccent; //color for flash button
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
      appBar: AppBar(title: Text("Flash Light")),
      body: Container(
        width: double.infinity,
        height: MediaQuery.of(context).size.height,
        alignment: Alignment.center,
        padding: EdgeInsets.all(40),
        //set width and height of outermost wrapper to 100%;
        child: flashlightbutton(),
      ),
      floatingActionButton: SpeedDial(
        // both default to 16
        marginRight: 18,
        marginBottom: 20,
        animatedIcon: AnimatedIcons.menu_close,
        animatedIconTheme: IconThemeData(size: 22.0),
        // this is ignored if animatedIcon is non null
        // child: Icon(Icons.add),
        visible: _dialVisible = true,
        // If true user is forced to close dial manually
        // by tapping main button and overlay is not rendered.
        closeManually: false,
        curve: Curves.bounceIn,
        overlayColor: Colors.black,
        overlayOpacity: 0.5,
        onOpen: () => print('OPENING DIAL'),
        onClose: () => print('DIAL CLOSED'),
        tooltip: 'Speed Dial',
        heroTag: 'speed-dial-hero-tag',
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 8.0,
        shape: CircleBorder(),
        children: [
          SpeedDialChild(
            child: Icon(Icons.accessibility),
            backgroundColor: Colors.red,
            label: 'Subscribe',
            labelStyle: TextStyle(fontSize: 18.0),
            onTap: () => Navigator.of(context).pushNamed(SUBSCRIBE_ROUTE),
          ),
          SpeedDialChild(
            child: Icon(Icons.flash_auto),
            backgroundColor: Colors.blue,
            label: 'Light on/off',
            labelStyle: TextStyle(fontSize: 18.0),
            onTap: () => Navigator.of(context).pushNamed(LIGHT_ROUTE),
          ),
          SpeedDialChild(
            child: Icon(Icons.message_rounded),
            backgroundColor: Colors.green,
            label: 'Advanced Text',
            labelStyle: TextStyle(fontSize: 18.0),
            onTap: () => Navigator.of(context).pushNamed(MESS_ROUTE),
          ),
        ],
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
                      hex.toString(), 1, _topicContent, _retainValue);
                },
              ),
            ),
            // Text("Your device has flash light."),
            // Text(isturnon ? "Flash is ON" : 'Flash is OFF'),
            const SizedBox(height: 40),
            // const SizedBox(height: 10),
            Container(
              child: FlatButton.icon(
                onPressed: () {
                  // _manager.publish('on', 1, _topicContent, _retainValue);
                  if (isturnon) {
                    //if light is on, then turn off
                    // Flashlight.lightOff();

                    setState(() {
                      _manager.publish('off', 1, _topicContent, _retainValue);
                      isturnon = false;
                      flashicon = Icons.flash_off;
                      flashbtncolor = Colors.deepOrangeAccent;
                    });
                  } else {
                    //if light is off, then turn on.
                    // Flashlight.lightOn();
                    _manager.publish('on', 1, _topicContent, _retainValue);
                    setState(() {
                      isturnon = true;
                      flashicon = Icons.flash_on;
                      flashbtncolor = Colors.greenAccent;
                    });
                  }
                },
                icon: Icon(
                  flashicon,
                  color: Colors.white,
                ),
                color: flashbtncolor,
                label: Text(
                  isturnon ? 'TURN OFF' : 'TURN ON',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      );
    } else {
      return Text("Your device do not have flash light.");
    }
  }
}
