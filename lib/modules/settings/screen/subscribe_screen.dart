import 'dart:async';
import 'dart:io';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:flutter/material.dart';
import 'package:mqtt_app/modules/core/managers/MQTTManager.dart';
import 'package:mqtt_app/modules/core/models/MQTTAppState.dart';
import 'package:mqtt_app/modules/core/widgets/status_bar.dart';
import 'package:mqtt_app/modules/helpers/screen_route.dart';
import 'package:mqtt_app/modules/helpers/status_info_message_utils.dart';
import 'package:provider/provider.dart';

class SubscribeScreen extends StatefulWidget {
  @override
  _SubscribeScreenState createState() => _SubscribeScreenState();
}

class _SubscribeScreenState extends State<SubscribeScreen> {
  final TextEditingController _messageTextController = TextEditingController();
  final TextEditingController _topicTextController = TextEditingController();
  final _controller = ScrollController();

  MQTTManager _manager;

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
    _manager = Provider.of<MQTTManager>(context);
    if (_controller.hasClients) {
      _controller.jumpTo(_controller.position.maxScrollExtent);
    }

    return Scaffold(
      appBar: _buildAppBar(context),
      body: _manager.currentState == null
          ? CircularProgressIndicator()
          : _buildColumn(_manager),
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
    return AppBar(
        title: const Text('Subscribe'),
        backgroundColor: Colors.blueAccent,
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 15.0),
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).pushNamed(SETTINGS_ROUTE);
              },
              child: Icon(
                Icons.settings_display,
                size: 26.0,
              ),
            ),
          )
        ]);
  }

  Widget _buildColumn(MQTTManager manager) {
    return Column(
      children: <Widget>[
        StatusBar(
            statusMessage: prepareStateMessageFrom(
                manager.currentState.getAppConnectionState)),
        _buildEditableColumn(manager.currentState),
      ],
    );
  }

  Widget _buildEditableColumn(MQTTAppState currentAppState) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: <Widget>[
          _buildTopicSubscribeRow(currentAppState),
          // const SizedBox(height: 10),
          // _buildPublishMessageRow(currentAppState),
          // const SizedBox(height: 10),
          // _buildScrollableTextWith(currentAppState.getHistoryText)
        ],
      ),
    );
  }

  // Widget _buildPublishMessageRow(MQTTAppState currentAppState) {
  //   return Row(
  //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //     children: <Widget>[
  //       Expanded(
  //         child: _buildTextFieldWith(_messageTextController, 'Enter a message',
  //             currentAppState.getAppConnectionState),
  //       ),
  //       _buildSendButtonFrom(currentAppState.getAppConnectionState)
  //     ],
  //   );
  // }

  Widget _buildTextFieldWith(TextEditingController controller, String hintText,
      MQTTAppConnectionState state) {
    bool shouldEnable = false;
    if (controller == _messageTextController &&
        state == MQTTAppConnectionState.connectedSubscribed) {
      shouldEnable = true;
    } else if ((controller == _topicTextController &&
        (state == MQTTAppConnectionState.connected ||
            state == MQTTAppConnectionState.connectedUnSubscribed))) {
      shouldEnable = true;
    }
    return TextField(
        enabled: shouldEnable,
        controller: controller,
        decoration: InputDecoration(
          contentPadding:
              const EdgeInsets.only(left: 0, bottom: 0, top: 0, right: 0),
          labelText: hintText,
        ));
  }

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

  Widget _buildTopicSubscribeRow(MQTTAppState currentAppState) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Expanded(
          child: _buildTextFieldWith(
              _topicTextController,
              'Enter a topic to subscribe or listen',
              currentAppState.getAppConnectionState),
        ),
        _buildSubscribeButtonFrom(currentAppState.getAppConnectionState)
      ],
    );
  }

  Widget _buildSubscribeButtonFrom(MQTTAppConnectionState state) {
    return RaisedButton(
      color: Colors.green,
      disabledColor: Colors.grey,
      textColor: Colors.white,
      disabledTextColor: Colors.black38,
      child: state == MQTTAppConnectionState.connectedSubscribed
          ? const Text('Unsubscribe')
          : const Text('Subscribe'),
      onPressed: (state == MQTTAppConnectionState.connectedSubscribed) ||
              (state == MQTTAppConnectionState.connectedUnSubscribed) ||
              (state == MQTTAppConnectionState.connected)
          ? () {
              _handleSubscribePress(state);
            }
          : null, //
    );
  }

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

  void _handleSubscribePress(MQTTAppConnectionState state) {
    if (state == MQTTAppConnectionState.connectedSubscribed) {
      _manager.unSubscribeFromCurrentTopic();
    } else {
      String enteredText = _topicTextController.text;
      if (enteredText != null && enteredText.isNotEmpty) {
        _manager.subScribeTo(_topicTextController.text);
      } else {
        _showDialog("Please enter a topic.");
      }
    }
  }

  // void _publishMessage(String text) {
  //   // String osPrefix = 'Flutter_iOS';
  //   // if (Platform.isAndroid) {
  //   //   osPrefix = 'Flutter_Android';
  //   // }
  //   final String message = text;
  //   _manager.publish(message);
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
}
