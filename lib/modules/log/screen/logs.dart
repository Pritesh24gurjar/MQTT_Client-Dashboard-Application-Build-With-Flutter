import 'package:flutter/material.dart';

import 'package:mqtt_app/modules/core/managers/MQTTManager.dart';
import 'package:mqtt_app/modules/core/models/MQTTAppState.dart';
import 'package:mqtt_app/modules/core/widgets/status_bar.dart';
import 'package:mqtt_app/modules/message/screen/message_screen.dart';
import 'package:mqtt_app/modules/helpers/screen_route.dart';
import 'package:mqtt_app/modules/helpers/status_info_message_utils.dart';

import 'package:provider/provider.dart';

class Logs extends StatefulWidget {
  _Logs createState() => _Logs();
}

class _Logs extends State<Logs> {
  @override
  MQTTManager _manager;
  var _scaffoldKey = new GlobalKey<ScaffoldState>();
  final _controller = ScrollController();

  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    _manager = Provider.of<MQTTManager>(context);
    if (_controller.hasClients) {
      _controller.jumpTo(_controller.position.maxScrollExtent);
    }

    return Scaffold(
      key: _scaffoldKey,
      drawer: new AppDrawer(),
      appBar: _buildAppBar(context),
      body: _buildColumn(_manager),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return AppBar(
        title: const Text('Logging'),
        backgroundColor: Colors.blueAccent,
        leading: GestureDetector(
          onTap: () {
            _scaffoldKey.currentState.openDrawer();
          },
          child: Icon(
            Icons.menu, // add custom icons also
          ),
        ));
  }

  Widget _buildColumn(MQTTManager manager) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          StatusBar(
              statusMessage: prepareStateMessageFrom(
                  manager.currentState.getAppConnectionState)),
          _buildEditableColumn(manager.currentState),
        ],
      ),
    );
  }

  Widget _buildEditableColumn(MQTTAppState currentAppState) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            // _buildTopicSubscribeRow(currentAppState),
            // const SizedBox(height: 10),
            const SizedBox(height: 15),
            _buildScrollableTextWith(currentAppState.getHistoryText)
          ],
        ),
      ),
    );
  }

  Widget _buildScrollableTextWith(String text) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Container(
        padding: const EdgeInsets.only(left: 10.0, right: 5.0),
        width: 400,
        height: 600,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.black12,
        ),
        child: SingleChildScrollView(
          controller: _controller,
          child: Text(text),
        ),
      ),
    );
  }
}

// class AppDrawer extends StatefulWidget {
//   @override
//   _AppDrawerState createState() => _AppDrawerState();
// }

// class _AppDrawerState extends State<AppDrawer> {
//   @override
//   Widget build(BuildContext context) {
//     return new Drawer(
//         child: new ListView(
//           children: <Widget>[
//             new DrawerHeader(
//               child: Text(
//                 "MQTT APP",
//                 style: TextStyle(
//                   color: Colors.white,
//                   fontSize: 24,
//                 ),
//               ),
//               decoration: BoxDecoration(
//                 color: Colors.blueAccent,
//               ),
//             ),
//             new ListTile(
//               leading: Icon(
//                 Icons.account_circle,
//                 color: Colors.blueAccent,
//               ),
//               title: Text(
//                 "Dashborad",
//                 style: TextStyle(
//                   color: Colors.blueAccent,
//                   fontSize: 16,
//                 ),
//               ),
//               onTap: () {
//                 Navigator.of(context).pushNamed(DASHBORAD_ROUTE);
//               },
//             ),
//             new ListTile(
//               leading: Icon(
//                 Icons.cloud_download,
//                 color: Colors.blueAccent,
//               ),
//               title: Text(
//                 "Main",
//                 style: TextStyle(
//                   color: Colors.blueAccent,
//                   fontSize: 16,
//                 ),
//               ),
//               onTap: () {
//                 Navigator.of(context).pushNamed('/');
//               },
//             ),
//             new ListTile(
//               leading: Icon(
//                 Icons.message_outlined,
//                 color: Colors.blueAccent,
//               ),
//               title: Text(
//                 "Message",
//                 style: TextStyle(
//                   color: Colors.blueAccent,
//                   fontSize: 16,
//                 ),
//               ),
//               onTap: () {
//                 Navigator.of(context).pushNamed(MESS_ROUTE);
//               },
//             ),
//             new ListTile(
//               leading: Icon(
//                 Icons.lightbulb,
//                 color: Colors.blueAccent,
//               ),
//               title: Text(
//                 "light on/off",
//                 style: TextStyle(
//                   color: Colors.blueAccent,
//                   fontSize: 16,
//                 ),
//               ),
//               onTap: () {
//                 Navigator.of(context).pushNamed(LIGHT_ROUTE);
//               },
//             ),
//           ],
//         ));
//   }
// }
