import 'package:flutter/material.dart';
import 'package:mqtt_app/helpers/database_helper.dart';
import 'package:mqtt_app/modules/dashborad/screen/updatePage/device_form.dart';
import 'package:mqtt_app/modules/dashborad/screen/updatePage/room_form.dart';
import 'package:mqtt_app/modules/dashborad/screen/updatePage/device_image_form.dart';
import 'package:mqtt_app/modules/dashborad/screen/updatePage/device_range_form.dart';
import 'package:mqtt_app/modules/dashborad/screen/updatePage/device_choice_form.dart';

import 'package:mqtt_app/modules/dashborad/screen/widget/switchinside.dart';
import 'package:mqtt_app/modules/dashborad/screen/widget/controllerinside.dart';
import 'package:mqtt_app/modules/dashborad/screen/widget/temperatureinside.dart';
import 'package:mqtt_app/modules/dashborad/screen/widget/choiceinside.dart';
import 'package:mqtt_app/modules/dashborad/screen/widget/lightinside.dart';
import 'package:mqtt_app/modules/dashborad/screen/widget/textinside.dart';

import 'package:flutter/cupertino.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mqtt_app/modules/broker/screen/broker_screen.dart';
import 'package:mqtt_app/modules/core/managers/MQTTManager.dart';

import 'package:mqtt_app/widgets/custum_dialog.dart';
import 'package:provider/provider.dart';
import 'package:mqtt_app/modules/dashborad/screen/widgetRoom/screens.dart';
import 'package:mqtt_app/widgets/widgets.dart';

import 'package:url_launcher/url_launcher.dart';

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
                                    //temp: sub(snapshot.data[index].sub),
                                    onTap: () {
                                      //print(snapshot.data[index]);
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
                                      onTap: () async {
                                        print(snapshot.data[index].style);
                                        if (snapshot.data[index].style ==
                                            'SetSwitch') {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  switchinside(
                                                title:
                                                    snapshot.data[index].title,
                                                pub: snapshot.data[index].sub,
                                                qos: snapshot.data[index].qos,
                                              ),
                                            ),
                                          ).then(
                                            (value) {
                                              setState(() {});
                                            },
                                          );
                                        } else if (snapshot.data[index].style ==
                                            'SetController') {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  controllerinside(
                                                title:
                                                    snapshot.data[index].title,
                                                pub: snapshot.data[index].sub,
                                                qos: snapshot.data[index].qos,
                                              ),
                                            ),
                                          ).then(
                                            (value) {
                                              setState(() {});
                                            },
                                          );
                                        } else if (snapshot.data[index].style ==
                                            'Setthermostat') {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  temperatureinside(
                                                title:
                                                    snapshot.data[index].title,
                                                pub: snapshot.data[index].sub,
                                                qos: snapshot.data[index].qos,
                                                min: snapshot.data[index].min,
                                                max: snapshot.data[index].max,
                                              ),
                                            ),
                                          ).then(
                                            (value) {
                                              setState(() {});
                                            },
                                          );
                                        } else if (snapshot.data[index].style ==
                                            'muiltChoice') {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  choiceinside(
                                                      title: snapshot
                                                          .data[index].title,
                                                      pub: snapshot
                                                          .data[index].sub,
                                                      qos: snapshot
                                                          .data[index].qos,
                                                      devicesinfo:
                                                          snapshot.data[index]),
                                            ),
                                          ).then(
                                            (value) {
                                              setState(() {});
                                            },
                                          );
                                        } else if (snapshot.data[index].style ==
                                            'colorValue') {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => lightinside(
                                                title:
                                                    snapshot.data[index].title,
                                                pub: snapshot.data[index].sub,
                                                qos: snapshot.data[index].qos,
                                              ),
                                            ),
                                          ).then(
                                            (value) {
                                              setState(() {});
                                            },
                                          );
                                        } else if (snapshot.data[index].style ==
                                            'TextValue') {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => textinside(
                                                title:
                                                    snapshot.data[index].title,
                                                pub: snapshot.data[index].sub,
                                                qos: snapshot.data[index].qos,
                                              ),
                                            ),
                                          ).then(
                                            (value) {
                                              setState(() {});
                                            },
                                          );
                                        } else if (snapshot.data[index].style ==
                                            'ImageValue') {
                                          if (snapshot
                                                  .data[index].savewebclick ==
                                              '') {
                                            _buildigimage(context,
                                                snapshot.data[index].saveweb);
                                          } else {
                                            _launchURL(snapshot
                                                .data[index].savewebclick);
                                            //_buildigimage(context,snapshot.data[index].saveweb);
                                          }
                                          /*Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => textinside(
                                                title: snapshot.data[index].title,
                                                pub: snapshot.data[index].sub,
                                                qos: snapshot.data[index].qos,
                                              ),
                                            ),
                                          ).then(
                                                (value) {
                                              setState(() {});
                                            },
                                          );*/
                                          //_launchURL();
                                        }
                                      },
                                      onLongPress: () async {
                                        if (snapshot.data[index].style ==
                                            'Setthermostat') {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  Device_range_form(
                                                devices: snapshot.data[index],
                                              ),
                                            ),
                                          ).then(
                                            (value) {
                                              setState(() {});
                                            },
                                          );
                                        } else if (snapshot.data[index].style ==
                                            'ImageValue') {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  Device_image_form(
                                                devices: snapshot.data[index],
                                              ),
                                            ),
                                          ).then(
                                            (value) {
                                              setState(() {});
                                            },
                                          );
                                        } else if (snapshot.data[index].style ==
                                            'muiltChoice') {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  Device_choice_form(
                                                devices: snapshot.data[index],
                                              ),
                                            ),
                                          ).then(
                                            (value) {
                                              setState(() {});
                                            },
                                          );
                                        } else {
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
                                        }
                                      },
                                      child: Devicess(
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

  _launchURL(String test) async {
    String url = test;
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Future<void> _buildigimage(BuildContext context, String test) async {
    return showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            child: Image.network(test),
          );
        });
  }
}
