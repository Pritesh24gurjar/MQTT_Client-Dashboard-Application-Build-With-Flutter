import 'package:flutter/material.dart';
import 'package:mqtt_app/homepage.dart';
import 'package:mqtt_app/modules/dashborad/light.dart';
import 'package:provider/provider.dart';

import 'modules/core/managers/MQTTManager.dart';
import 'modules/helpers/screen_route.dart';
import 'modules/helpers/service_locator.dart';
import 'modules/message/screen/message_screen.dart';
import 'modules/settings/screen/settings_screen.dart';
import 'modules/settings/screen/subscribe_screen.dart';
import 'modules/dashborad/screen/dashborad.dart';
import 'modules/log/screen/logs.dart';
import 'modules/dialogs/send_message.dart';

void main() {
  setupLocator();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<MQTTManager>(
      create: (context) => service_locator<MQTTManager>(),
      child: MaterialApp(
          title: 'Flutter APP',
          theme: ThemeData(
            // This is the theme of your application.
            //
            // Try running your application with "flutter run". You'll see the
            // application has a blue toolbar. Then, without quitting the app, try
            // changing the primarySwatch below to Colors.green and then invoke
            // "hot reload" (press "r" in the console where you ran "flutter run",
            // or simply save your changes to "hot reload" in a Flutter IDE).
            // Notice that the counter didn't reset back to zero; the application
            // is not restarted.
            primarySwatch: Colors.blue,
            // This makes the visual density adapt to the platform that you run
            // the app on. For desktop platforms, the controls will be smaller and
            // closer together (more dense) than on mobile platforms.
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          initialRoute: '/',
          routes: {
            // '/': (BuildContext context) => AppDraw(),
            '/': (BuildContext context) => MessageScreen(),
            SETTINGS_ROUTE: (BuildContext context) => SettingsScreen(),
            SUBSCRIBE_ROUTE: (BuildContext context) => SubscribeScreen(),
            DASHBORAD_ROUTE: (BuildContext context) => Dashborad(),
            MESS_ROUTE: (BuildContext context) => MessScreen(),
            LIGHT_ROUTE: (BuildContext context) => FlashLight(),
            LOGGING_ROUTE: (BuildContext context) => Logs(),
            // ignore: equal_keys_in_map
            // Testing: (BuildContext context) => Homepage(),
          }),
    );
  }
}

class AppDraw extends StatefulWidget {
  @override
  _AppDrawState createState() => _AppDrawState();
}

class _AppDrawState extends State<AppDraw> {
  PageController _pageController;
  int _page = 0;

  void navigationTapped(int page) {
    _pageController.animateToPage(page,
        duration: const Duration(milliseconds: 300), curve: Curves.ease);
  }

  void onPageChanged(int page) {
    setState(() {
      this._page = page;
    });
  }

  void initState() {
    _pageController = PageController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        onTap: navigationTapped,
        currentIndex: _page,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.cloud),
            label: ('Main '),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.playlist_add),
            label: ('Dashboard '),
          ),
        ],
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: onPageChanged,
        children: <Widget>[
          MessageScreen(),
          Dashborad(),
        ],
      ),
    );
  }
}
