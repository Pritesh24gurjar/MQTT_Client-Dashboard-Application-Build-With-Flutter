import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mqtt_app/helpers/database_helper.dart';
import 'package:mqtt_app/modules/core/managers/MQTTManager.dart';
import 'package:mqtt_app/modules/core/models/MQTTAppState.dart';
import 'package:mqtt_app/modules/core/widgets/status_bar.dart';
import 'package:mqtt_app/modules/dashborad/screen/dashborad.dart';
import 'package:mqtt_app/modules/helpers/screen_route.dart';
import 'package:mqtt_app/modules/helpers/status_info_message_utils.dart';
import 'package:mqtt_app/screens/login_screen.dart';
import 'package:mqtt_app/screens/taskpage.dart';
import 'package:mqtt_app/widgets.dart';
import 'package:provider/provider.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

import '../../../main.dart';

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
              Icons.cloud_download,
              color: Colors.black54,
            ),
            title: Text(
              "Main",
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
              Icons.lightbulb,
              color: Colors.black54,
            ),
            title: Text(
              "light on/off",
              style: TextStyle(
                color: Colors.black54,
                fontSize: 16,
              ),
            ),
            onTap: () {
              Navigator.of(context).pushNamed(LIGHT_ROUTE);
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
class MessageScreen extends StatefulWidget {
  @override
  _MessageScreenState createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  DatabaseHelper _dbHelper = DatabaseHelper();

  final TextEditingController _messageTextController = TextEditingController();
  final TextEditingController _topicTextController = TextEditingController();
  final _controller = ScrollController();
  var _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool _hasMessage = false;
  bool _hasTopic = false;
  // bool _retainValue = false;
  bool _saveNeeded = false;
  int _qosValue = 0;
  // String _messageContent;
  // String _topicContent;
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
                    child: Image(
                      image: AssetImage('assets/images/logo.png'),
                    ),
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
                                  // Navigator.push(
                                  //   context,
                                  //   MaterialPageRoute(
                                  //     builder: (context) => Taskpage(
                                  //       task: snapshot.data[index],
                                  //     ),
                                  //   ),
                                  // ).then(
                                  //   (value) {
                                  //     setState(() {});
                                  //   },
                                  // );
                                  _manager.initializeMQTTClient(
                                    host: snapshot.data[index].title,
                                    identifier: snapshot.data[index].clientid,
                                    port: snapshot.data[index].description,
                                    username: snapshot.data[index].username,
                                    password: snapshot.data[index].password,
                                    // useWS: false,
                                  );
                                  if (snapshot.data[index].username == null &&
                                      snapshot.data[index].password == null) {
                                    _manager.connect1();
                                  } else {
                                    _manager.connect();
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
                                  title: snapshot.data[index].title,
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

              // Positioned(
              //   bottom: 24.0,
              //   right: 0.0,
              //   child: GestureDetector(
              //     onTap: () {
              //       Navigator.push(
              //         context,
              //         MaterialPageRoute(
              //             builder: (context) => Taskpage(
              //                   task: null,
              //                 )),
              //       ).then((value) {
              //         setState(() {});
              //       });
              //     },
              //     child: Container(
              //       width: 60.0,
              //       height: 60.0,
              //       decoration: BoxDecoration(
              //         gradient: LinearGradient(
              //             colors: [Color(0xFF7349FE), Color(0xFF643FDB)],
              //             begin: Alignment(0.0, -1.0),
              //             end: Alignment(0.0, 1.0)),
              //         borderRadius: BorderRadius.circular(20.0),
              //       ),
              //       child: Image(
              //         image: AssetImage(
              //           "assets/images/add_icon.png",
              //         ),
              //       ),
              //     ),
              //   ),
              // ),
              SpeedDial(
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
                overlayColor: Color(0xFFF6F6F6),
                overlayOpacity: 0.5,
                onOpen: () => print('OPENING DIAL'),
                onClose: () => print('DIAL CLOSED'),
                tooltip: 'Speed Dial',
                heroTag: 'speed-dial-hero-tag',
                backgroundColor: Color(0xFFF6F6F6),
                foregroundColor: Colors.black,
                elevation: 8.0,
                shape: CircleBorder(),
                children: [
                  SpeedDialChild(
                    child: Icon(Icons.accessibility),
                    backgroundColor: Colors.red,
                    label: 'Subscribe',
                    labelStyle: TextStyle(fontSize: 18.0),
                    onTap: () =>
                        Navigator.of(context).pushNamed(SUBSCRIBE_ROUTE),
                  ),
                  SpeedDialChild(
                    child: Icon(Icons.flash_auto),
                    backgroundColor: Colors.blue,
                    label: 'Light on/off',
                    labelStyle: TextStyle(fontSize: 18.0),
                    onTap: () => Navigator.of(context).pushNamed(LIGHT_ROUTE),
                  ),
                  SpeedDialChild(
                    child: Icon(Icons.thermostat_rounded),
                    backgroundColor: Colors.amberAccent,
                    label: 'Thermostat',
                    labelStyle: TextStyle(fontSize: 18.0),
                    onTap: () => Navigator.of(context).pushNamed(MESS_ROUTE),
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
            ],
          ),
        ),
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
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => LoginScreen()));
              },
              child: Icon(
                Icons.settings_display,
                size: 26.0,
              ),
            ),
          ),
          // FlatButton(
          //     child: Text('SEND',
          //         style:
          //             theme.textTheme.bodyText1.copyWith(color: Colors.white)),
          //     onPressed: () {
          //       if (_formKey.currentState.validate()) {
          //         _formKey.currentState.save();
          //         _manager.publish(
          //             _messageContent, _qosValue, _topicContent, _retainValue);
          //       }
          //     })
        ]);
  }

  Widget _buildColumn(MQTTManager manager) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          StatusBar(
              statusMessage: prepareStateMessageFrom(
                  manager.currentState.getAppConnectionState)),
        ],
      ),
    );
  }

  // Widget _buildPublishMessageRow(MQTTAppState currentAppState) {
  //   final ThemeData theme = Theme.of(context);
  //   return Form(
  //     key: _formKey,
  //     onWillPop: _onWillPop,
  //     child: ListView(
  //       padding: const EdgeInsets.all(16.0),
  //       children: <Widget>[
  //         Container(
  //           padding: const EdgeInsets.symmetric(vertical: 8.0),
  //           alignment: Alignment.bottomLeft,
  //           child: TextFormField(
  //             decoration:
  //                 const InputDecoration(labelText: 'Message', filled: true),
  //             style: theme.textTheme.headline2,
  //             maxLines: 2,
  //             validator: (value) {
  //               if (value.isEmpty) {
  //                 return 'Please enter some text';
  //               }
  //             },
  //             onSaved: (String value) {
  //               setState(() {
  //                 _hasMessage = value.isNotEmpty;
  //                 if (_hasMessage) {
  //                   _messageContent = value;
  //                 }
  //               });
  //             },
  //           ),
  //         ),
  //         Container(
  //           padding: const EdgeInsets.symmetric(vertical: 8.0),
  //           alignment: Alignment.bottomLeft,
  //           child: TextFormField(
  //             decoration:
  //                 const InputDecoration(labelText: 'Topic', filled: true),
  //             validator: (value) {
  //               if (value.isEmpty) {
  //                 return 'Please enter some text';
  //               }
  //             },
  //             onSaved: (String value) {
  //               setState(() {
  //                 _hasTopic = value.isNotEmpty;
  //               });
  //               if (_hasTopic) {
  //                 _topicContent = value;
  //               }
  //             },
  //           ),
  //         ),
  //         _buildQosChoiceChips(),
  //         Container(
  //           decoration: BoxDecoration(
  //               border: Border(bottom: BorderSide(color: theme.dividerColor))),
  //           child: Row(
  //             children: <Widget>[
  //               Checkbox(
  //                   value: _retainValue,
  //                   onChanged: (bool value) {
  //                     setState(() {
  //                       _retainValue = value;
  //                       _saveNeeded = true;
  //                     });
  //                   }),
  //               const Text('Retained'),
  //             ],
  //           ),
  //         )
  //       ],
  //     ),
  //   );
  // }

  // Widget _buildTextFieldWith(TextEditingController controller, String hintText,
  //     MQTTAppConnectionState state) {
  //   bool shouldEnable = false;
  //   if (controller == _messageTextController &&
  //       state == MQTTAppConnectionState.connectedSubscribed) {
  //     shouldEnable = true;
  //   } else if ((controller == _topicTextController &&
  //       (state == MQTTAppConnectionState.connected ||
  //           state == MQTTAppConnectionState.connectedUnSubscribed))) {
  //     shouldEnable = true;
  //   }
  //   return TextField(
  //       enabled: shouldEnable,
  //       controller: controller,
  //       decoration: InputDecoration(
  //         contentPadding:
  //             const EdgeInsets.only(left: 0, bottom: 0, top: 0, right: 0),
  //         labelText: hintText,
  //       ));
  // }

  // Widget _buildSendButtonFrom(MQTTAppConnectionState state) {
  //   return RaisedButton(
  //     color: Colors.green,
  //     disabledColor: Colors.grey,
  //     textColor: Colors.white,
  //     disabledTextColor: Colors.black38,
  //     child: const Text('Send'),
  //     onPressed: state == MQTTAppConnectionState.connectedSubscribed
  //         ? () {
  //             _publishMessage(_messageTextController.text);
  //           }
  //         : null, //
  //   );
  // }

  // Widget _buildTopicSubscribeRow(MQTTAppState currentAppState) {
  //   return Row(
  //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //     children: <Widget>[
  //       Expanded(
  //         child: _buildTextFieldWith(
  //             _topicTextController,
  //             'Enter a topic to subscribe or listen',
  //             currentAppState.getAppConnectionState),
  //       ),
  //       _buildSubscribeButtonFrom(currentAppState.getAppConnectionState)
  //     ],
  //   );
  // }

  // Widget _buildSubscribeButtonFrom(MQTTAppConnectionState state) {
  //   return RaisedButton(
  //     color: Colors.green,
  //     disabledColor: Colors.grey,
  //     textColor: Colors.white,
  //     disabledTextColor: Colors.black38,
  //     child: state == MQTTAppConnectionState.connectedSubscribed
  //         ? const Text('Unsubscribe')
  //         : const Text('Subscribe'),
  //     onPressed: (state == MQTTAppConnectionState.connectedSubscribed) ||
  //             (state == MQTTAppConnectionState.connectedUnSubscribed) ||
  //             (state == MQTTAppConnectionState.connected)
  //         ? () {
  //             _handleSubscribePress(state);
  //           }
  //         : null, //
  //   );
  // }

  Widget _buildScrollableTextWith(String text) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Container(
          padding: const EdgeInsets.only(left: 10.0, right: 5.0),
          width: 400,
          height: 300,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.black12,
          ),
          child: SingleChildScrollView(
            controller: _controller,
            child: Text(text),
          ),
        ),
      ),
    );
  }

  // void _handleSubscribePress(MQTTAppConnectionState state) {
  //   if (state == MQTTAppConnectionState.connectedSubscribed) {
  //     _manager.unSubscribeFromCurrentTopic();
  //   } else {
  //     String enteredText = _topicTextController.text;
  //     if (enteredText != null && enteredText.isNotEmpty) {
  //       _manager.subScribeTo(_topicTextController.text);
  //     } else {
  //       _showDialog("Please enter a topic.");
  //     }
  //   }
  // }

  // void _publishMessage(String text) {
  //   // String osPrefix = 'Flutter_iOS';
  //   // if (Platform.isAndroid) {
  //   //   osPrefix = 'Flutter_Android';
  //   // }
  //   final String message = text;
  //   // _manager.publish(message);
  //   _messageTextController.clear();
  // }

  // void _showDialog(String message) {
  //   // flutter defined function
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         title: Text("Error"),
  //         content: Text(message),
  //         actions: <Widget>[
  //           FlatButton(
  //             child: Text("Close"),
  //             onPressed: () {
  //               Navigator.of(context).pop();
  //             },
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }

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

  Future<bool> _onWillPop() async {
    _saveNeeded = _hasTopic || _hasMessage || _saveNeeded;

    if (!_saveNeeded) return true;

    final ThemeData theme = Theme.of(context);
    final TextStyle dialogTextStyle = theme.textTheme.subtitle1
        .copyWith(color: theme.textTheme.caption.color);

    return await showDialog<bool>(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              content: Text('Discard message?', style: dialogTextStyle),
              actions: <Widget>[
                FlatButton(
                    child: const Text('CANCEL'),
                    onPressed: () {
                      Navigator.of(context).pop(
                          false); // Pops the confirmation dialog but not the page.
                    }),
                FlatButton(
                    child: const Text('DISCARD'),
                    onPressed: () {
                      Navigator.of(context).pop(
                          true); // Returning true to _onWillPop will pop again.
                    })
              ],
            );
          },
        ) ??
        false;
  }
}
