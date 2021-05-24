import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mqtt_app/modules/core/managers/MQTTManager.dart';
import 'package:mqtt_app/modules/core/models/MQTTAppState.dart';

import 'package:mqtt_app/modules/helpers/screen_route.dart';

import 'package:provider/provider.dart';
import 'package:mqtt_app/modules/broker/screen/broker_screen.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

class MessScreen extends StatefulWidget {
  @override
  _MessageScreenState createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessScreen> {
  final TextEditingController _messageTextController = TextEditingController();
  final TextEditingController _topicTextController = TextEditingController();
  final _controller = ScrollController();
  var _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool _hasMessage = false;
  bool _hasTopic = false;
  bool _retainValue = false;
  bool _saveNeeded = false;
  int _qosValue = 0;
  String _messageContent;
  String _topicContent;
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
      drawer: new AppDrawer(),
      appBar: _buildAppBar(context),
      body: Form(
        key: _formKey,
        onWillPop: _onWillPop,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: <Widget>[
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              alignment: Alignment.bottomLeft,
              child: TextFormField(
                decoration:
                    const InputDecoration(labelText: 'Message', filled: true),
                style: theme.textTheme.headline4,
                maxLines: 2,
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter some text';
                  }
                },
                onSaved: (String value) {
                  setState(() {
                    _hasMessage = value.isNotEmpty;
                    if (_hasMessage) {
                      _messageContent = value;
                    }
                  });
                },
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              alignment: Alignment.bottomLeft,
              child: TextFormField(
                decoration:
                    const InputDecoration(labelText: 'Topic', filled: true),
                // validator: (value) {
                //   if (value.isEmpty) {
                //     return 'Please enter some text';
                //   }
                // },
                onSaved: (String value) {
                  setState(() {
                    //   _hasTopic = value.isNotEmpty;
                    // });
                    // if (_hasTopic) {
                    _topicContent = value;
                  });
                },
              ),
            ),
            _buildQosChoiceChips(),
            Container(
              decoration: BoxDecoration(
                  border:
                      Border(bottom: BorderSide(color: theme.dividerColor))),
              child: Row(
                children: <Widget>[
                  Checkbox(
                      value: _retainValue,
                      onChanged: (bool value) {
                        setState(() {
                          _retainValue = value;
                          _saveNeeded = true;
                        });
                      }),
                  const Text('Retained'),
                ],
              ),
            ),

            RaisedButton(
              child: Text('SEND',
                  style:
                      theme.textTheme.bodyText1.copyWith(color: Colors.black)),
              onPressed: () {
                if (_formKey.currentState.validate()) {
                  _formKey.currentState.save();
                  _manager.publish(
                      _messageContent, _qosValue, _topicContent, _retainValue);
                }
              },
              color: Colors.blueAccent,
              // minWidth:
            ),
            // _manager.currentState == null
            //     ? CircularProgressIndicator()
            //     : _buildColumn(_manager),
          ],
        ),
      ),
      // _manager.currentState == null
      //     ? CircularProgressIndicator()
      //     : _buildColumn(_manager),
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
          // Padding(
          //   padding: const EdgeInsets.only(right: 15.0),
          //   child: GestureDetector(
          //     onTap: () {
          //       Navigator.of(context).pushNamed(SETTINGS_ROUTE);
          //     },
          //     child: Icon(
          //       Icons.settings_display,
          //       size: 26.0,
          //     ),
          //   ),
          // ),
          FlatButton(
              child: Text('SEND',
                  style:
                      theme.textTheme.bodyText1.copyWith(color: Colors.white)),
              onPressed: () {
                if (_formKey.currentState.validate()) {
                  _formKey.currentState.save();
                  _manager.publish(
                      _messageContent, _qosValue, _topicContent, _retainValue);
                }
              })
        ]);
  }

  // Widget _buildColumn(MQTTManager manager) {
  //   return SingleChildScrollView(
  //     child: Column(
  //       children: <Widget>[
  //         StatusBar(
  //             statusMessage: prepareStateMessageFrom(
  //                 manager.currentState.getAppConnectionState)),
  //         _buildEditableColumn(manager.currentState),
  //       ],
  //     ),
  //   );
  // }

  // Widget _buildEditableColumn(MQTTAppState currentAppState) {
  //   return Padding(
  //     padding: const EdgeInsets.all(20.0),
  //     child: SingleChildScrollView(
  //       child: Column(
  //         children: <Widget>[
  //           // _buildTopicSubscribeRow(currentAppState),
  //           // const SizedBox(height: 10),
  //           // _buildPublishMessageRow(currentAppState),
  //           const SizedBox(height: 20),
  //           _buildScrollableTextWith(currentAppState.getHistoryText)
  //         ],
  //       ),
  //     ),
  //   );
  // }

  Widget _buildPublishMessageRow(MQTTAppState currentAppState) {
    final ThemeData theme = Theme.of(context);
    // return Form(
    //   key: _formKey,
    //   onWillPop: _onWillPop,
    //   child: ListView(
    //     padding: const EdgeInsets.all(16.0),
    //     children: <Widget>[
    //       Container(
    //         padding: const EdgeInsets.symmetric(vertical: 8.0),
    //         alignment: Alignment.bottomLeft,
    //         child: TextFormField(
    //           decoration:
    //               const InputDecoration(labelText: 'Message', filled: true),
    //           style: theme.textTheme.headline2,
    //           maxLines: 2,
    //           validator: (value) {
    //             if (value.isEmpty) {
    //               return 'Please enter some text';
    //             }
    //           },
    //           onSaved: (String value) {
    //             setState(() {
    //               _hasMessage = value.isNotEmpty;
    //               if (_hasMessage) {
    //                 _messageContent = value;
    //               }
    //             });
    //           },
    //         ),
    //       ),
    //       Container(
    //         padding: const EdgeInsets.symmetric(vertical: 8.0),
    //         alignment: Alignment.bottomLeft,
    //         child: TextFormField(
    //           decoration:
    //               const InputDecoration(labelText: 'Topic', filled: true),
    //           validator: (value) {
    //             if (value.isEmpty) {
    //               return 'Please enter some text';
    //             }
    //           },
    //           onSaved: (String value) {
    //             setState(() {
    //               _hasTopic = value.isNotEmpty;
    //             });
    //             if (_hasTopic) {
    //               _topicContent = value;
    //             }
    //           },
    //         ),
    //       ),
    //       _buildQosChoiceChips(),
    //       Container(
    //         decoration: BoxDecoration(
    //             border: Border(bottom: BorderSide(color: theme.dividerColor))),
    //         child: Row(
    //           children: <Widget>[
    //             Checkbox(
    //                 value: _retainValue,
    //                 onChanged: (bool value) {
    //                   setState(() {
    //                     _retainValue = value;
    //                     _saveNeeded = true;
    //                   });
    //                 }),
    //             const Text('Retained'),
    //           ],
    //         ),
    //       )
    //     ],
    //   ),
    // );
  }

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

  // Widget _buildScrollableTextWith(String text) {
  //   return Padding(
  //     padding: const EdgeInsets.all(5.0),
  //     child: Container(
  //       padding: const EdgeInsets.only(left: 10.0, right: 5.0),
  //       width: 400,
  //       height: 300,
  //       decoration: BoxDecoration(
  //         borderRadius: BorderRadius.circular(10),
  //         color: Colors.black12,
  //       ),
  //       child: SingleChildScrollView(
  //         controller: _controller,
  //         child: Text(text),
  //       ),
  //     ),
  //   );
  // }

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

  void _showDialog(String message) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Error"),
          content: Text(message),
          actions: <Widget>[
            FlatButton(
              child: Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
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
