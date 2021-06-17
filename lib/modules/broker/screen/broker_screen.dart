import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:mqtt_app/helpers/database_helper.dart';
import 'package:mqtt_app/modules/core/managers/MQTTManager.dart';
import 'package:mqtt_app/modules/helpers/screen_route.dart';
import 'login_screen.dart';
import 'taskpage.dart';
import 'package:mqtt_app/widgets.dart';
import 'package:provider/provider.dart';

class AppDrawer extends StatefulWidget {
  @override
  _AppDrawerState createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  @override
  Widget build(BuildContext context) {
    return new Drawer(
        child: Container(
      color: Colors.indigo[100],
      child: new ListView(
        children: <Widget>[
          new DrawerHeader(
            child: Text(
              "",
              style: TextStyle(
                color: Colors.black54,
                fontSize: 24,
              ),
            ),
            decoration: BoxDecoration(
                color: Colors.black54,
                image: DecorationImage(
                    image: AssetImage("assets/images/logo_drawer.png"),
                    fit: BoxFit.fill)),
          ),
          new ListTile(
            leading: Icon(
              Icons.cloud_download,
              color: Colors.black54,
            ),
            title: Text(
              "Broker",
              style: TextStyle(
                color: Colors.black54,
                fontSize: 16,
              ),
            ),
            onTap: () {
              Navigator.of(context).pushNamed('/');
            },
          ),
          new ListTile(
            leading: Icon(
              Icons.account_circle,
              color: Colors.black54,
            ),
            title: Text(
              "Dashborad",
              style: TextStyle(
                color: Colors.black54,
                fontSize: 16,
              ),
            ),
            onTap: () {
              Navigator.of(context).pushNamed(DASHBORAD_ROUTE);
            },
          ),

          new ListTile(
            leading: Icon(
              Icons.message_outlined,
              color: Colors.black54,
            ),
            title: Text(
              "Message",
              style: TextStyle(
                color: Colors.black54,
                fontSize: 16,
              ),
            ),
            onTap: () {
              Navigator.of(context).pushNamed(MESS_ROUTE);
            },
          ),
          new ListTile(
            leading: Icon(
              Icons.stacked_bar_chart,
              color: Colors.black54,
            ),
            title: Text(
              "Logging",
              style: TextStyle(
                color: Colors.black54,
                fontSize: 16,
              ),
            ),
            onTap: () {
              Navigator.of(context).pushNamed(LOGGING_ROUTE);
            },
          ),
          // new ListTile(
          //   leading: Icon(
          //     Icons.stacked_bar_chart,
          //     color: Colors.blueAccent,
          //   ),
          //   title: Text(
          //     "testing",
          //     style: TextStyle(
          //       color: Colors.blueAccent,
          //       fontSize: 16,
          //     ),
          //   ),
          //   onTap: () {
          //     Navigator.of(context).pushNamed(Testing);
          //   },
          // ),
        ],
      ),
    ));
  }
}
///////////////////
///
///

/////////////
class BrokerScreen extends StatefulWidget {
  @override
  _BrokerScreenState createState() => _BrokerScreenState();
}

class _BrokerScreenState extends State<BrokerScreen> {
  DatabaseHelper _dbHelper = DatabaseHelper();

  final TextEditingController _messageTextController = TextEditingController();
  final TextEditingController _topicTextController = TextEditingController();
  final _controller = ScrollController();
  var _scaffoldKey = new GlobalKey<ScaffoldState>();
  MQTTManager _manager;

  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _messageTextController.dispose();
    _topicTextController.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool _dialVisible = true;
    final ThemeData theme = Theme.of(context);
    _manager = Provider.of<MQTTManager>(context);
    if (_controller.hasClients) {
      _controller.jumpTo(_controller.position.maxScrollExtent);
    }

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Color(0xFFF6F6F6),
      drawer: new AppDrawer(),
      // bottomNavigationBar: AppDraw(),
      appBar: _buildAppBar(context),
      body: SafeArea(
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          color: Color(0xFFF6F6F6),
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.only(
                      top: 32.0,
                      bottom: 32.0,
                    ),
                    /*child: Image(
                      image: AssetImage('assets/images/logo.png'),
                    ),*/
                  ),
                  Expanded(
                    child: FutureBuilder(
                      initialData: [],
                      future: _dbHelper.getTasks(),
                      builder: (context, snapshot) {
                        return ScrollConfiguration(
                          behavior: NoGlowBehaviour(),
                          child: ListView.builder(
                            itemCount: snapshot.data.length,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () {
                                  _manager.disconnect();

                                  if (snapshot.data[index].useSSL == 0 &&
                                      snapshot.data[index].useWS == 1) {
                                    _manager.initializeMQTTClientWS(
                                        host: snapshot.data[index].title,
                                        identifier:
                                            snapshot.data[index].clientid,
                                        port: snapshot.data[index].description,
                                        username: snapshot.data[index].username,
                                        password: snapshot.data[index].password,
                                        useWS: true);
                                    if (snapshot.data[index].username != null &&
                                        snapshot.data[index].password != null) {
                                      _manager.connect_Websocket();
                                    } else if (snapshot.data[index].username ==
                                            null &&
                                        snapshot.data[index].password == null) {
                                      _manager.connect_Websocket_WUP();
                                    } else {
                                      //_manager.connect1();
                                    }
                                  } else if (snapshot.data[index].useSSL == 1 &&
                                      snapshot.data[index].useWS == 0) {
                                    _manager.initializeMQTTClientSSL(
                                      host: snapshot.data[index].title,
                                      identifier: snapshot.data[index].clientid,
                                      port: snapshot.data[index].description,
                                      username: snapshot.data[index].username,
                                      password: snapshot.data[index].password,
                                    );
                                    if (snapshot.data[index].username != null &&
                                        snapshot.data[index].password != null) {
                                      _manager.connect_SSL();
                                    } else {
                                      _manager.connect_SSL_WUP();
                                    }
                                  } else if (snapshot.data[index].useSSL == 1 &&
                                      snapshot.data[index].useWS == 1) {
                                    print("you can't do it both");
                                  } else {
                                    _manager.initializeMQTTClient(
                                      host: snapshot.data[index].title,
                                      identifier: snapshot.data[index].clientid,
                                      port: snapshot.data[index].description,
                                      username: snapshot.data[index].username,
                                      password: snapshot.data[index].password,
                                    );

                                    if (snapshot.data[index].username != null &&
                                        snapshot.data[index].password != null) {
                                      _manager.connect();
                                    } else if (snapshot.data[index].username ==
                                            null &&
                                        snapshot.data[index].password == null) {
                                      _manager.connect_WUP();
                                    }
                                  }
                                },
                                onLongPress: () async {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => Taskpage(
                                        task: snapshot.data[index],
                                      ),
                                    ),
                                  ).then(
                                    (value) {
                                      setState(() {});
                                    },
                                  );
                                },
                                child: TaskCardWidget(
                                  title: snapshot.data[index].servername,
                                  desc: snapshot.data[index].description,
                                  index: index,
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
            ],
          ),
        ),
      ),
      floatingActionButton: SpeedDial(
        // both default to 16
        marginRight: 18,
        marginBottom: 20,
        animatedIcon: AnimatedIcons.menu_close,
        animatedIconTheme: IconThemeData(size: 22.0),
        // this is ignored if animatedIcon is non null
        // child: Icon(Icons.add),
        visible: _dialVisible,
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

  Widget _buildAppBar(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return AppBar(
        title: const Text('MQTT'),
        backgroundColor: Colors.blueAccent,
        leading: GestureDetector(
          onTap: () {
            _scaffoldKey.currentState.openDrawer();
          },
          child: Icon(
            Icons.menu, // add custom icons also
          ),
        ),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 15.0),
            child: GestureDetector(
              /*onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => LoginScreen()));
              },*/
              child: Ink(
                decoration: const ShapeDecoration(
                  shape: CircleBorder(),
                ),
                child: IconButton(
                  //Icons.add_circle_outline,
                  // size: 26.0,
                  icon: const Icon(Icons.add_circle_outline),
                  iconSize: 26.0,

                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => LoginScreen()));
                  },
                ),
              ),
            ),
          )
        ]);
  }
}
