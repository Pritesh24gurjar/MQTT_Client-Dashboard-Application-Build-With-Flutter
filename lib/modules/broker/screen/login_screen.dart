import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mqtt_app/helpers/database_helper.dart';
import 'package:mqtt_app/models/task.dart';
import 'package:mqtt_app/modules/core/managers/MQTTManager.dart';
import 'package:mqtt_app/modules/core/models/MQTTAppState.dart';
import 'package:mqtt_app/modules/core/widgets/status_bar.dart';
import 'package:mqtt_app/modules/helpers/status_info_message_utils.dart';
import 'package:mqtt_app/modules/broker/screen/broker_screen.dart';
import 'package:provider/provider.dart';
import 'package:ssl_pinning_plugin/ssl_pinning_plugin.dart';
import 'package:flutter/services.dart';
import 'package:mqtt_app/utilities/constants.dart';
import 'package:fluttertoast/fluttertoast.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _ssl = false;
  int _sslint = 0;
  bool _ws = false;
  int _wsint = 0;

///////////

  DatabaseHelper _dbHelper = DatabaseHelper();
  int _taskId = 0;
  String _taskTitle = "";
  String _taskDescription = "";

  FocusNode _titleFocus;
  FocusNode _descriptionFocus;
  FocusNode _todoFocus;

  bool _contentVisile = false;

  final TextEditingController _serverTextController = TextEditingController();
  final TextEditingController _hostTextController = TextEditingController();
  final TextEditingController _identifierTextController = TextEditingController();
  final TextEditingController _portTextController = TextEditingController();
  final TextEditingController _usernameTextController = TextEditingController();
  final TextEditingController _passwordTextController = TextEditingController();

  MQTTManager _manager;

  @override
  void dispose() {
    _serverTextController.dispose();
    _hostTextController.dispose();
    _identifierTextController.dispose();
    _passwordTextController.dispose();
    _usernameTextController.dispose();
    _portTextController.dispose();
    super.dispose();
  }

////////
  Widget _buildServername() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Server Name',
          style: kLabelStyle,
        ),
        SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          height: 60.0,
          child: TextField(
            keyboardType: TextInputType.name,
            controller: _serverTextController,
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'OpenSans',
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(
                Icons.email,
                color: Colors.white,
              ),
              hintText: 'Enter your Server name',
              hintStyle: kHintTextStyle,
            ),
          ),
        ),
      ],
    );
  }


  Widget _buildUsername() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Username',
          style: kLabelStyle,
        ),
        SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          height: 60.0,
          child: TextField(
            keyboardType: TextInputType.emailAddress,
            controller: _usernameTextController,
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'OpenSans',
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(
                Icons.email,
                color: Colors.white,
              ),
              hintText: 'Enter your Username',
              hintStyle: kHintTextStyle,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPassword() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Password',
          style: kLabelStyle,
        ),
        SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          height: 60.0,
          child: TextField(
            obscureText: true,
            controller: _passwordTextController,
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'OpenSans',
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(
                Icons.lock,
                color: Colors.white,
              ),
              hintText: 'Enter your Password',
              hintStyle: kHintTextStyle,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildClientId() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Client ID',
          style: kLabelStyle,
        ),
        SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          height: 60.0,
          child: TextField(
            obscureText: false,
            controller: _identifierTextController,
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'OpenSans',
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(
                Icons.account_circle_sharp,
                color: Colors.white,
              ),
              hintText: 'Enter Client ID',
              hintStyle: kHintTextStyle,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPort() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Port',
          style: kLabelStyle,
        ),
        SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          height: 60.0,
          child: TextField(
            obscureText: false,
            controller: _portTextController,
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'OpenSans',
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(
                Icons.compare_arrows_sharp,
                color: Colors.white,
              ),
              hintText: 'Enter Port ',
              hintStyle: kHintTextStyle,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHost() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Broker',
          style: kLabelStyle,
        ),
        SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          height: 60.0,
          child: TextField(
            obscureText: false,
            controller: _hostTextController,
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'OpenSans',
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(
                Icons.home,
                color: Colors.white,
              ),
              hintText: 'Enter Broker',
              hintStyle: kHintTextStyle,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildForgotPasswordBtn() {
    return Container(
      alignment: Alignment.centerRight,
      child: FlatButton(
        onPressed: () => print('Forgot Password Button Pressed'),
        padding: EdgeInsets.only(right: 0.0),
        child: Text(
          'Forgot Password?',
          style: kLabelStyle,
        ),
      ),
    );
  }

  Widget _buildWebsocketsCheck() {
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

  Widget _buildSSLCheck() {
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
  }

  Widget _buildConnectBtn() {
    MQTTAppConnectionState state = _manager.currentState.getAppConnectionState;
    return Container(
      padding: EdgeInsets.symmetric(vertical: 25.0),
      width: double.infinity,
      child: RaisedButton(
        elevation: 5.0,
        onPressed: () async {
          if (state == MQTTAppConnectionState.disconnected) {
            _configureAndConnect();

            Task _newTask = Task(
              servername: _serverTextController.text,
              title: _hostTextController.text,
              description: _portTextController.text,
              clientid: _identifierTextController.text,
              username: _usernameTextController.text,
              password: _passwordTextController.text,
              useWS: _wsint,
              useSSL: _sslint,
            );

            _taskId = await _dbHelper.insertTask(_newTask);
            setState(() {
              _contentVisile = true;
              _taskTitle = _hostTextController.text;
            });
          } else {
            state = null;
          }
        },
        padding: EdgeInsets.all(10.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        color: Colors.white,
        child: Text(
          'Connect',
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

  Widget _buildDisconnectBtn() {
    MQTTAppConnectionState state = _manager.currentState.getAppConnectionState;
    return Container(
      padding: EdgeInsets.symmetric(vertical: 25.0),
      width: double.infinity,
      child: RaisedButton(
        elevation: 5.0,
        onPressed: state != MQTTAppConnectionState.disconnected
            ? _disconnect
            : null, //
        padding: EdgeInsets.all(10.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        color: Colors.white,
        child: Text(
          'Disconnect',
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

  Widget _buildSignInWithText() {
    return Column(
      children: <Widget>[
        Text(
          '- OR -',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w400,
          ),
        ),
        SizedBox(height: 20.0),
        Text(
          'Sign in with',
          style: kLabelStyle,
        ),
      ],
    );
  }

  Widget _buildSocialBtn(Function onTap, AssetImage logo) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 60.0,
        width: 60.0,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              offset: Offset(0, 2),
              blurRadius: 6.0,
            ),
          ],
          image: DecorationImage(
            image: logo,
          ),
        ),
      ),
    );
  }

  Widget _buildSocialBtnRow() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 30.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          _buildSocialBtn(
            () => print('Login with Facebook'),
            AssetImage(
              'assets/logos/facebook.jpg',
            ),
          ),
          _buildSocialBtn(
            () => print('Login with Google'),
            AssetImage(
              'assets/logos/google.jpg',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSignupBtn() {
    var st;
    if (_manager.currentState.getAppConnectionState ==
        MQTTAppConnectionState.disconnected) {
      st = _buildConnectBtn();
    } else {
      st = _buildDisconnectBtn();
    }
    return st;
  }

  @override
  Widget build(BuildContext context) {
    _manager = Provider.of<MQTTManager>(context);
    return Scaffold(
      body: _manager.currentState == null
          ? CircularProgressIndicator()
          : AnnotatedRegion<SystemUiOverlayStyle>(
              value: SystemUiOverlayStyle.light,
              child: GestureDetector(
                onTap: () => FocusScope.of(context).unfocus(),
                child: Stack(
                  children: <Widget>[
                    Container(
                      height: double.infinity,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Color(0xFF73AEF5),
                            Color(0xFF61A4F1),
                            Color(0xFF478DE0),
                            Color(0xFF398AE5),
                          ],
                          stops: [0.1, 0.4, 0.7, 0.9],
                        ),
                      ),
                    ),
                    Container(
                      height: double.infinity,
                      child: SingleChildScrollView(
                        physics: AlwaysScrollableScrollPhysics(),
                        padding: EdgeInsets.symmetric(
                          horizontal: 40.0,
                          vertical: 120.0,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              'Set Broker',
                              style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'OpenSans',
                                fontSize: 30.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 30.0),
                            _buildServername(),
                            SizedBox(height: 30.0),
                            _buildHost(),
                            SizedBox(
                              height: 30.0,
                            ),
                            _buildClientId(),
                            SizedBox(
                              height: 30.0,
                            ),
                            _buildPort(),
                            SizedBox(
                              height: 30.0,
                            ),
                            _buildUsername(),
                            SizedBox(
                              height: 30.0,
                            ),
                            _buildPassword(),
                            SizedBox(
                              height: 30.0,
                            ),
                            _buildWebsocketsCheck(),
                            SizedBox(
                              height: 30.0,
                            ),
                            _buildSSLCheck(),
                            SizedBox(
                              height: 30.0,
                            ),

                            _buildSignupBtn(),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
    );
  }

  void _configureAndConnect() {
    // TODO: Use UUID
    // String osPrefix = 'Flutter_iOS';
    // if (Platform.isAndroid) {
    //   osPrefix = 'Flutter_Android';
    // }
    if (_ssl == false && _ws == true) {
      _manager.initializeMQTTClientWS(
          host: _hostTextController.text, //_hostTextController.text,
          identifier: _identifierTextController.text,
          port: _portTextController.text,
          password: _passwordTextController.text,
          username: _usernameTextController.text,
          useWS: true);
      if(_passwordTextController.text.isEmpty == false &&
          _usernameTextController.text.isEmpty == false) {
        _manager.connect_Websocket();
      }
      else if (_passwordTextController.text.isEmpty == true&&
          _usernameTextController.text.isEmpty == true)
      {
        _manager.connect_Websocket_WUP();
      }
      else{
        //_manager.connect1();
      }

    }

    else if (_ssl == true && _ws == false) {
      _manager.initializeMQTTClientSSL(
          host: _hostTextController.text, //_hostTextController.text,
          identifier: _identifierTextController.text,
          port: _portTextController.text,
          password: _passwordTextController.text,
          username: _usernameTextController.text);
      if(_passwordTextController.text.isEmpty == false &&
          _usernameTextController.text.isEmpty == false) {
        _manager.connect_SSL();
      }
      else{
        _manager.connect_SSL_WUP();
      }
    }

    else if(_ssl == true && _ws == true)
    {
      print("you can't do it both");
    }

    else {
      _manager.initializeMQTTClient(
        host: _hostTextController.text,
        identifier: _identifierTextController.text,
        port: _portTextController.text,
        password: _passwordTextController.text,
        username: _usernameTextController.text,
        // useWS: false
      );

      if(_passwordTextController.text.isEmpty == false &&
          _usernameTextController.text.isEmpty == false) {
        _manager.connect();
      }

      else if (_passwordTextController.text.isEmpty == true&&
          _usernameTextController.text.isEmpty == true)
      {
        _manager.connect_WUP();
      }
    }
  }


  void _disconnect() {
    _manager.disconnect();
  }
}
