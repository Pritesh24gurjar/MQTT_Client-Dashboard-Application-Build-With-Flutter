import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mqtt_app/helpers/database_helper.dart';
import 'package:mqtt_app/models/task.dart';
import 'package:mqtt_app/modules/core/managers/MQTTManager.dart';
import 'package:mqtt_app/modules/core/models/MQTTAppState.dart';
import 'package:mqtt_app/modules/core/widgets/status_bar.dart';
import 'package:mqtt_app/modules/helpers/status_info_message_utils.dart';
import 'package:mqtt_app/modules/message/screen/message_screen.dart';
import 'package:provider/provider.dart';
import 'package:ssl_pinning_plugin/ssl_pinning_plugin.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

// ssl connection vars

class _PiningSslData {
  String serverURL = '';
  HttpMethod httpMethod = HttpMethod.Get;
  Map<String, String> headerHttp = new Map();
  String allowedSHAFingerprint = '';
  int timeout = 20;
  SHA sha;
}

class _SettingsScreenState extends State<SettingsScreen> {
  DatabaseHelper _dbHelper = DatabaseHelper();
  int _taskId = 0;
  String _taskTitle = "";
  String _taskDescription = "";

  FocusNode _titleFocus;
  FocusNode _descriptionFocus;
  FocusNode _todoFocus;

  bool _contentVisile = false;
  bool isTLS = false;
  bool isWS = false;

  final TextEditingController _hostTextController = TextEditingController();
  final TextEditingController _identifierTextController =
      TextEditingController();
  final TextEditingController _portTextController = TextEditingController();
  final TextEditingController _usernameTextController = TextEditingController();
  final TextEditingController _passwordTextController = TextEditingController();

  MQTTManager _manager;

  @override
  void dispose() {
    _hostTextController.dispose();
    _identifierTextController.dispose();
    _passwordTextController.dispose();
    _usernameTextController.dispose();
    _portTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _manager = Provider.of<MQTTManager>(context);
    return Scaffold(
        appBar: _buildAppBar(context),
        drawer: new AppDrawer(),
        body: _manager.currentState == null
            ? CircularProgressIndicator()
            : SingleChildScrollView(child: _buildColumn(_manager)));
  }

  Widget _buildAppBar(BuildContext context) {
    return AppBar(
      title: const Text('Settings'),
      backgroundColor: Colors.blueAccent,
    );
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
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            _buildTextFieldWith(_hostTextController, 'Broker address',
                currentAppState.getAppConnectionState),
            const SizedBox(height: 10),
            _buildTextFieldWith(_identifierTextController, 'Client identity',
                currentAppState.getAppConnectionState),
            const SizedBox(height: 10),
            _buildTextFieldWith(_portTextController, 'Port',
                currentAppState.getAppConnectionState),
            const SizedBox(height: 10),
            _buildTextFieldWith(_usernameTextController, 'Username',
                currentAppState.getAppConnectionState),
            const SizedBox(height: 10),
            _buildTextFieldWith(_passwordTextController, 'Password',
                currentAppState.getAppConnectionState),
            const SizedBox(height: 10),
            _buildConnecteButtonFrom(currentAppState.getAppConnectionState),
            const SizedBox(height: 10),
            _buildEditableColumnChoiceTLS(
                currentAppState.getAppConnectionState),
            const SizedBox(height: 10),
            _buildEditableColumnChoiceWS(currentAppState.getAppConnectionState)
          ],
        ),
      ),
    );
  }

  Widget _buildTextFieldWith(TextEditingController controller, String hintText,
      MQTTAppConnectionState state) {
    bool shouldEnable = false;
    if ((controller == _hostTextController &&
            state == MQTTAppConnectionState.disconnected) ||
        (controller == _identifierTextController &&
            state == MQTTAppConnectionState.disconnected) ||
        (controller == _passwordTextController &&
            state == MQTTAppConnectionState.disconnected) ||
        (controller == _usernameTextController &&
            state == MQTTAppConnectionState.disconnected) ||
        (controller == _portTextController &&
            state == MQTTAppConnectionState.disconnected)) {
      shouldEnable = true;
    } else if (controller == _hostTextController && _manager.host != null) {
      _hostTextController.text = _manager.host;
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

  Widget _buildEditableColumnChoiceTLS(MQTTAppConnectionState state) {
    return Row(children: <Widget>[
      Checkbox(
        value: isTLS,
        onChanged: (newVal) {
          setState(() {
            isTLS = newVal;
          });
        },
      ),
      Text(
        'Enable connection encryption (TLS/SSL).',
        style: getStyle(isTLS, false),
      )
    ]);
  }

  Widget _buildEditableColumnChoiceWS(MQTTAppConnectionState state) {
    return Row(children: <Widget>[
      Checkbox(
        value: isWS,
        onChanged: (newVal) {
          setState(() {
            isWS = newVal;
          });
        },
      ),
      Text(
        'Websocket Connection.',
        style: getStyle(isWS, false),
      ),
    ]);
  }

  Widget _buildConnecteButtonFrom(MQTTAppConnectionState state) {
    return Row(
      children: <Widget>[
        Expanded(
          child: RaisedButton(
              color: Colors.blueAccent,
              child: const Text('Connect'),
              onPressed: () async {
                if (state == MQTTAppConnectionState.disconnected) {
                  _configureAndConnect();

                  Task _newTask = Task(
                    title: _hostTextController.text,
                    description: _portTextController.text,
                    clientid: _identifierTextController.text,
                    username: _usernameTextController.text,
                    password: _passwordTextController.text,
                  );

                  _taskId = await _dbHelper.insertTask(_newTask);
                  setState(() {
                    _contentVisile = true;
                    _taskTitle = _hostTextController.text;
                  });
                } else {
                  state = null;
                }
              }),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: RaisedButton(
            color: Colors.redAccent,
            child: const Text('Disconnect'),
            onPressed: state != MQTTAppConnectionState.disconnected
                ? _disconnect
                : null, //
          ),
        ),
      ],
    );
  }

  // check(String url, String fingerprint, HttpMethod httpMethod, SHA sha,
  //     Map<String, String> headerHttp, int timeout) async {
  //   List<String> allowedShA1FingerprintList = new List();
  //   allowedShA1FingerprintList.add(fingerprint);

  //   try {
  //     // Platform messages may fail, so we use a try/catch PlatformException.
  //     String checkMsg = await SslPinningPlugin.check(
  //         serverURL: url,
  //         headerHttp: headerHttp,
  //         httpMethod: httpMethod,
  //         sha: sha,
  //         allowedSHAFingerprints: allowedShA1FingerprintList,
  //         timeout: timeout);

  //     print('{$checkMsg}');
  //     if (!mounted) return;
  //   } catch (e) {
  //     print("error : {$e}");
  //   }
  // }
  TextStyle getStyle([bool isTLS = false, bool isWS = false]) {
    return TextStyle(
      fontSize: 18,
      fontWeight: isTLS ? FontWeight.bold : FontWeight.normal,
      fontStyle: isWS ? FontStyle.italic : FontStyle.normal,
    );
  }

  void _configureAndConnect() {
    // TODO: Use UUID
    // String osPrefix = 'Flutter_iOS';
    // if (Platform.isAndroid) {
    //   osPrefix = 'Flutter_Android';
    // }
    _manager.initializeMQTTClient(
      host: _hostTextController.text,
      identifier: _identifierTextController.text,
      port: _portTextController.text,
      password: _passwordTextController.text,
      username: _usernameTextController.text,
      // useWS: false
    );
    if (_passwordTextController.text.isEmpty == true &&
        _usernameTextController.text.isEmpty == true) {
      _manager.connect1();
    } else if (isTLS == false &&
        isWS == true &&
        _passwordTextController.text.isEmpty == false &&
        _usernameTextController.text.isEmpty == false) {
      _manager.initializeMQTTClientWS(
          host: _hostTextController.text, //_hostTextController.text,
          identifier: _identifierTextController.text,
          port: _portTextController.text,
          password: _passwordTextController.text,
          username: _usernameTextController.text,
          useWS: true);
      _manager.connect1();
    } else {
      _manager.connect();
    }
    // _manager.connect();
  }

  void _disconnect() {
    _manager.disconnect();
  }
}
