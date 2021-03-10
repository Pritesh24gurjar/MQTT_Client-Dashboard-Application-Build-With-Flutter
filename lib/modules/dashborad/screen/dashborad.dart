import 'package:flutter/material.dart';
import 'package:mqtt_app/helpers/database_helper.dart';
import 'package:mqtt_app/modules/dashborad/screen/device_form.dart';
import 'package:mqtt_app/modules/dashborad/screen/room_form.dart';
import 'package:mqtt_app/modules/helpers/screen_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mqtt_app/modules/message/screen/message_screen.dart';
import 'package:mqtt_app/modules/core/managers/MQTTManager.dart';
import 'package:mqtt_app/modules/core/models/MQTTAppState.dart';
import 'package:mqtt_app/screens/deviceUpdate.dart';
import 'package:mqtt_app/widgets/custum_dialog.dart';
import 'package:provider/provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mqtt_app/models/devices_model.dart';
import 'package:mqtt_app/models/rooms_model.dart';
import 'package:mqtt_app/screens/screens.dart';
import 'package:mqtt_app/widgets/widgets.dart';
import 'package:custom_switch/custom_switch.dart';

hexColor(String colorhexcode) {
  String colornew = '0xff' + colorhexcode;
  colornew = colornew.replaceAll('#', '');
  int colorint = int.parse(colornew);
  return colorint;
}

class Dashborad extends StatefulWidget {
  _Dashborad createState() => _Dashborad();
}

class _Dashborad extends State<Dashborad> {
  DatabaseHelper _dbHelper = DatabaseHelper();
  @override
  var _scaffoldKey = new GlobalKey<ScaffoldState>();
  MQTTManager _manager;
  List<Widget> dynamicList = [];
  List<String> data = [];
  bool isSwitched = false;
  bool status = false;
  Icon floatingIcon = new Icon(Icons.add);
  var datatemp = 'text';

  // TextDynamic(BuildContext context) {
  //   //dynamicList.add(new AddText());
  //   dynamicList.add(Textwidth(_manager.currentState));
  //   setState(() {});
  // }

  // SwitchDynamic(BuildContext context) {
  //   //dynamicList.add(new AddText());
  //   dynamicList.add(Switchwidth(_manager.currentState));
  //   setState(() {});
  // }

  // SliderDynamic(BuildContext context) {
  //   //dynamicList.add(new AddSlider());
  //   setState(() {});
  // }

  // LEDDynamic(BuildContext context) {
  //   dynamicList.add(Ledwidth(_manager.currentState));
  //   setState(() {});
  // }

  // List<RoomsModel> _listRooms = [
  //   RoomsModel(image: 'assets/images/kitchen.jpg', name: 'Kitchen', temp: '24'),
  //   RoomsModel(
  //       image: 'assets/images/livingroom.jpg', name: 'Living room', temp: '25'),
  //   RoomsModel(image: 'assets/images/bedroom.jpg', name: 'Bedroom', temp: '28'),
  //   RoomsModel(
  //       image: 'assets/images/bathroom.jpg', name: 'Bathroom', temp: '27'),
  // ];

  // List<DevicesModel> _listDevices = [
  //   DevicesModel(image: 'assets/images/microwave.png', name: 'Microwave'),
  //   DevicesModel(image: 'assets/images/range_hood.png', name: 'Range hood'),
  //   DevicesModel(image: 'assets/images/tv.png', name: 'TV'),
  //   DevicesModel(image: 'assets/images/refrigerator.png', name: 'Refrigerator'),
  // ];

  @override
  Widget build(BuildContext context) {
    double _height = MediaQuery.of(context).size.height;
    double _width = MediaQuery.of(context).size.width;
    _manager = Provider.of<MQTTManager>(context);
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Color(0xFFF6F6F6),
      drawer: new AppDrawer(),
      appBar: _buildAppBar(context),
      body: Center(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.only(left: 16),
            child: Container(
              color: Color(0xFFF6F6F6),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TopHeader(),
                  SizedBox(
                    height: _height * 0.05,
                  ),
                  textCate(nameCate: 'Rooms'),
                  SizedBox(
                    height: 16,
                  ),
                  Container(
                    child: FutureBuilder(
                      initialData: [],
                      future: _dbHelper.getrooms(),
                      builder: (context, snapshot) {
                        return Container(
                          height: _height * 0.45,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: snapshot.data.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child: GestureDetector(
                                  onLongPress: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => Room_form(
                                          room: snapshot.data[index],
                                        ),
                                      ),
                                    ).then(
                                      (value) {
                                        setState(() {});
                                      },
                                    );
                                  },
                                  child: CateContainer(
                                    image: 'assets/images/livingroom.jpg',
                                    name: snapshot.data[index].title,
                                    temp: '30',
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  DetailScreen(
                                                    room: snapshot.data[index],
                                                  )));
                                    },
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  textCate(nameCate: 'Devices'),
                  SizedBox(
                    height: 16,
                  ),
                  Container(
                    child: FutureBuilder(
                      initialData: [],
                      future: _dbHelper.getDevices(),
                      builder: (context, snapshot) {
                        return Container(
                          height: _height * 0.5,
                          child: GridView.builder(
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                            ),
                            itemCount: snapshot.data.length,
                            itemBuilder: (context, index) {
                              return Container(
                                child: Container(
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 16.0),
                                    child: GestureDetector(
                                      onTap: () {},
                                      onLongPress: () async {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => Device_form(
                                              devices: snapshot.data[index],
                                            ),
                                          ),
                                        ).then(
                                          (value) {
                                            setState(() {});
                                          },
                                        );
                                      },
                                      child: Devices(
                                        image: 'assets/images/tv.png',
                                        name: snapshot.data[index].title,

                                        // image: _listDevices[index].image,
                                        // name: _listDevices[index].name,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     //       if (datatemp=="text")
      //     // {
      //     //   // TextDynamic(context);
      //     //   Textwidth(_manager.currentState);
      //     // }
      //     showAlertDialog(context);
      //   },
      //   child: Icon(Icons.add),
      //   backgroundColor: Colors.green,
      // ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return AppBar(
      leading: IconButton(
          icon: Icon(
            FontAwesomeIcons.bars,
            color: Colors.white,
          ),
          onPressed: () {
            _scaffoldKey.currentState.openDrawer();
          }),
      title: Container(
        alignment: Alignment.center,
        child: Text("Dashboard",
            style: TextStyle(
              color: Colors.white,
            )),
      ),
      actions: <Widget>[
        IconButton(
          icon: Icon(
            Icons.add_circle,
            size: 30.0,
            color: Colors.white,
          ),
          onPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext context) => CustomDialog(
                title: "Would you like to create Rooms and device tiles?",
                description:
                    "By creating rooms you can access to other devices which cames under room",
                primaryButtonText: "Create Device",
                primaryButtonRoute: "/Device",
                secondaryButtonText: "Create Room",
                secondaryButtonRoute: "/Room",
              ),
            );
          },
        ),
      ],
    );
  }

  Widget textCate({nameCate}) {
    return Text(
      nameCate,
      style: TextStyle(
        color: Colors.black87,
        fontSize: 18,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}
//   showAlertDialog(BuildContext context) {
//     // set up the list options
//     Widget optionOne = SimpleDialogOption(
//       child: const Text('Text'),
//       onPressed: () {
//         print('Text');
//         TextDynamic(context);
//         Navigator.of(context).pop();
//       },
//     );
//     Widget optionTwo = SimpleDialogOption(
//       child: const Text('Switch/button'),
//       onPressed: () {
//         print('Switch/button');
//         SwitchDynamic(context);
//         Navigator.of(context).pop();
//       },
//     );
//     Widget optionThree = SimpleDialogOption(
//       child: const Text('Range/Progress'),
//       onPressed: () {
//         print('Range/Progress');
//         SliderDynamic(context);
//         Navigator.of(context).pop();
//       },
//     );
//     Widget optionFour = SimpleDialogOption(
//       child: const Text('Multi choice'),
//       onPressed: () {
//         print('Multi choice');
//         Navigator.of(context).pop();
//       },
//     );
//     Widget optionFive = SimpleDialogOption(
//       child: const Text('Image'),
//       onPressed: () {
//         print('Image');
//         Navigator.of(context).pop();
//       },
//     );
//     Widget optionSix = SimpleDialogOption(
//       child: const Text('Color'),
//       onPressed: () {
//         print('Color');
//         LEDDynamic(context);
//         Navigator.of(context).pop();
//       },
//     );

//     // set up the SimpleDialog
//     SimpleDialog dialog = SimpleDialog(
//       title: const Text('Choose type'),
//       children: <Widget>[
//         optionOne,
//         optionTwo,
//         optionThree,
//         optionFour,
//         optionFive,
//         optionSix,
//       ],
//     );

//     // show the dialog
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return dialog;
//       },
//     );
//   }
// }

// class AppDrawer extends StatefulWidget {
//   @override
//   _AppDrawerState createState() => _AppDrawerState();
// }

// class _AppDrawerState extends State<AppDrawer> {
//   @override
//   Widget build(BuildContext context) {
//     return new Drawer(
//         child: new ListView(
//       children: <Widget>[
//         new DrawerHeader(
//           child: Text(
//             "MQTT APP",
//             style: TextStyle(
//               color: Colors.white,
//               fontSize: 24,
//             ),
//           ),
//           decoration: BoxDecoration(
//             color: Colors.blueAccent,
//           ),
//         ),
//         new ListTile(
//           leading: Icon(
//             Icons.account_circle,
//             color: Colors.blueAccent,
//           ),
//           title: Text(
//             "Dashborad",
//             style: TextStyle(
//               color: Colors.blueAccent,
//               fontSize: 16,
//             ),
//           ),
//           onTap: () {
//             Navigator.of(context).pushNamed(DASHBORAD_ROUTE);
//           },
//         ),
//         new ListTile(
//           leading: Icon(
//             Icons.cloud_download,
//             color: Colors.blueAccent,
//           ),
//           title: Text(
//             "Main",
//             style: TextStyle(
//               color: Colors.blueAccent,
//               fontSize: 16,
//             ),
//           ),
//           onTap: () {
//             Navigator.of(context).pushNamed('/');
//           },
//         ),
//         new ListTile(
//           leading: Icon(
//             Icons.message_outlined,
//             color: Colors.blueAccent,
//           ),
//           title: Text(
//             "Message",
//             style: TextStyle(
//               color: Colors.blueAccent,
//               fontSize: 16,
//             ),
//           ),
//           onTap: () {
//             Navigator.of(context).pushNamed(MESS_ROUTE);
//           },
//         ),
//         new ListTile(
//           leading: Icon(
//             Icons.lightbulb,
//             color: Colors.blueAccent,
//           ),
//           title: Text(
//             "light on/off",
//             style: TextStyle(
//               color: Colors.blueAccent,
//               fontSize: 16,
//             ),
//           ),
//           onTap: () {
//             Navigator.of(context).pushNamed(LIGHT_ROUTE);
//           },
//         ),
//         new ListTile(
//           leading: Icon(
//             Icons.lightbulb,
//             color: Colors.blueAccent,
//           ),
//           title: Text(
//             "Logging",
//             style: TextStyle(
//               color: Colors.blueAccent,
//               fontSize: 16,
//             ),
//           ),
//           onTap: () {
//             Navigator.of(context).pushNamed(LOGGING_ROUTE);
//           },
//         ),
//       ],
//     ));
//   }
// }

Widget Textwidth(MQTTAppState currentAppState) {
  return Container(
    margin: new EdgeInsets.only(left: 100.0, right: 100.0, bottom: 20.0),
    padding: const EdgeInsets.all(5.0),
    width: 100,
    height: 100,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(5),
      color: Colors.black12,
    ),
    child: Center(
      child: Text(
        currentAppState.getReceivedText,
        textAlign: TextAlign.center,
      ),
    ),
  );
}

Widget Switchwidth(MQTTAppState currentAppState) {
  bool status = false;
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: <Widget>[
      CustomSwitch(
        activeColor: Colors.green,
        value: status,
        onChanged: (value) {},
      ),
      SizedBox(
        height: 6.0,
      ),
    ],
  );
}

/*class AddSlider extends StatefulWidget{
  _AddSlider createState()=> _AddSlider();
}

class _AddSlider extends State<AddSlider> {
  double _value = 0;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: new EdgeInsets.all(8.0),
      child: new Slider(
        value: _value.toDouble(),
        min: 0.0,
        max: 100.0,
        divisions: 100,
        activeColor: Colors.green,
        inactiveColor: Colors.orange,
        label: _value.round().toString(),
        onChanged: (double newValue) {
          setState(() {
            _value = newValue;
          });
        },
      ),
    );
  }
}*/

/*Widget Sliderwidth(String text) {
    return Container(
      margin: new EdgeInsets.all(8.0),
      child: new Slider(
        value: _value.toDouble(),
        min: 0.0,
        max: 100.0,
        divisions: 100,
        activeColor: Colors.green,
        inactiveColor: Colors.orange,
        label: _value.round().toString(),
        onChanged: (double newValue) {
          setState(() {
            _value = newValue;
          });
        },
      ),
    );
}*/

/*class AddLed extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: new EdgeInsets.all(15.0),
      height: 42.0,
      width: 42.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(2),
        color: Colors.red,
      ),
    );
  }
}*/

Widget Ledwidth(MQTTAppState currentAppState) {
  String test = currentAppState.getReceivedText;
  return Container(
    margin: new EdgeInsets.all(15.0),
    height: 42.0,
    width: 42.0,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(2),
      color: Color(hexColor(test)),
    ),
  );
}
