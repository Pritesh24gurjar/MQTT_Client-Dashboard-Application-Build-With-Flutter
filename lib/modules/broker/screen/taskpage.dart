import 'package:flutter/material.dart';
import 'package:mqtt_app/helpers/database_helper.dart';
import 'package:mqtt_app/models/task.dart';
import 'package:mqtt_app/modules/core/managers/MQTTManager.dart';
import 'package:mqtt_app/modules/core/models/MQTTAppState.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import 'package:mqtt_app/utilities/constants.dart';

class Taskpage extends StatefulWidget {
  final Task task;

  Taskpage({@required this.task});

  @override
  _TaskScreenState createState() => _TaskScreenState();
}

class _TaskScreenState extends State<Taskpage> {
  bool _ssl = false;
  bool _ws = false;
  int _sslint = 0;
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
  void initState() {
    if (widget.task != null) {
      // Set visibility to true
      _contentVisile = true;

      _serverTextController.text = widget.task.servername;
      _hostTextController.text = widget.task.title;
      _portTextController.text = widget.task.description;
      _identifierTextController.text = widget.task.clientid;
      _usernameTextController.text = widget.task.username;
      _passwordTextController.text = widget.task.password;
      _wsint = widget.task.useWS;
      _sslint = widget.task.useSSL;
      _taskId = widget.task.id;
    }
    print(_wsint);
    print(_sslint);
    if(_wsint == 1)
      _ws =  true;
    if(_sslint == 1)
      _ssl = true;

    _titleFocus = FocusNode();
    _descriptionFocus = FocusNode();
    _todoFocus = FocusNode();

    super.initState();
  }

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
            keyboardType: TextInputType.text,
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
            onTap: () {
              _serverTextController.clear();
            },
            onChanged: (value) async {
              if (value != "") {
                if (_taskId != 0) {
                  await _dbHelper.updateTaskServername(_taskId, value);
                  // _usernameTextController.text = value;
                }
              }
              _todoFocus.requestFocus();
            },
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
            keyboardType: TextInputType.text,
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
            onTap: () {
              _usernameTextController.clear();
            },
            onChanged: (value) async {
              if (value != "") {
                if (_taskId != 0) {
                  await _dbHelper.updateTaskusername(_taskId, value);
                  // _usernameTextController.text = value;
                }
              }
              _todoFocus.requestFocus();
            },
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
            onTap: () {
              _passwordTextController.clear();
            },
            onChanged: (value) async {
              if (value != "") {
                if (_taskId != 0) {
                  await _dbHelper.updateTaskpassword(_taskId, value);
                  // _passwordTextController.text = value;
                }
              }
              _todoFocus.requestFocus();
            },
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
            onTap: () {
              _identifierTextController.clear();
            },
            onChanged: (value) async {
              if (value != "") {
                if (_taskId != 0) {
                  await _dbHelper.updateTaskclientId(_taskId, value);
                  _taskDescription = value;
                }
              }
              _todoFocus.requestFocus();
            },
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
              hintText: 'Enter Port',
              hintStyle: kHintTextStyle,
            ),
            onTap: () {
              _portTextController.clear();
            },
            onChanged: (value) async {
              if (value != "") {
                if (_taskId != 0) {
                  await _dbHelper.updateTaskDescription(_taskId, value);
                  // _portTextController.text = value;
                }
              }
              _todoFocus.requestFocus();
            },
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
            onTap: () {
              _hostTextController.clear();
            },
            onChanged: (value) async {
              if (value != null) {
                if (_taskId != 0) {
                  await _dbHelper.updateTaskTitle(_taskId, value);
                  // _hostTextController.text = value;
                }
              }
              _todoFocus.requestFocus();
            },
          ),
        ),
      ],
    );
  }

  Widget _buildWebsocketsCheck(bool valuedb) {
    return Container(
      height: 20.0,
      child: Row(
        children: <Widget>[
          Theme(
            data: ThemeData(unselectedWidgetColor: Colors.white),
            child: Checkbox(
              value: valuedb,
              checkColor: Colors.green,
              activeColor: Colors.white,
              onChanged: (value) async {
                _ws = value;
                if(value == true)
                  _wsint = 1;
                else
                  _wsint = 0;
                setState(() async {
                  await _dbHelper.updateTaskWS(_taskId, _wsint);
                });
                _todoFocus.requestFocus();
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

  Widget _buildSSLCheck(bool valuedb) {
    return Container(
      height: 20.0,
      child: Row(
        children: <Widget>[
          Theme(
            data: ThemeData(unselectedWidgetColor: Colors.white),
            child: Checkbox(
              value: valuedb,
              checkColor: Colors.green,
              activeColor: Colors.white,
              onChanged: (value) async {
                  _ssl = value;
                  if(value == true)
                    _sslint = 1;
                  else
                    _sslint = 0;
                  setState(() async {
                    await _dbHelper.updateTaskSSL(_taskId, _sslint);
                  });
                  _todoFocus.requestFocus();
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
          await _dbHelper.updateTaskServername(_taskId, _serverTextController.text);
          await _dbHelper.updateTaskTitle(_taskId, _hostTextController.text);
          await _dbHelper.updateTaskDescription(
              _taskId, _portTextController.text);
          await _dbHelper.updateTaskclientId(
              _taskId, _identifierTextController.text);
          await _dbHelper.updateTaskusername(
              _taskId, _usernameTextController.text);
          await _dbHelper.updateTaskpassword(
              _taskId, _passwordTextController.text);
          await _dbHelper.updateTaskWS(_taskId, _wsint);
          await _dbHelper.updateTaskSSL(_taskId, _sslint);

          Navigator.of(context).pop();
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
    );
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
                              'Edit Broker',
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
                            _buildWebsocketsCheck(_ws),
                            SizedBox(
                              height: 30.0,
                            ),
                            _buildSSLCheck(_ssl),
                            SizedBox(
                              height: 30.0,
                            ),
                            _buildConnectBtn(),
                          ],
                        ),
                      ),
                    ),
                    Visibility(
                      visible: _contentVisile,
                      child: Positioned(
                        bottom: 24.0,
                        right: 24.0,
                        child: GestureDetector(
                          onTap: () async {
                            if (_taskId != 0) {
                              await _dbHelper.deleteTask(_taskId);
                              Navigator.pop(context);
                            }
                          },
                          child: Container(
                            width: 60.0,
                            height: 60.0,
                            decoration: BoxDecoration(
                              color: Color(0xFFFE3577),
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            child: Image(
                              image: AssetImage(
                                "assets/images/delete_icon.png",
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
    );
  }
}
