import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mqtt_app/models/models.dart';
import 'package:mqtt_app/models/select_model.dart';

import 'package:mqtt_app/widgets/widgets.dart';
import 'package:neuomorphic_container/neuomorphic_container.dart';

class DetailScreen_sound extends StatefulWidget {
  final String title;
  final room;
  var pressed = false;
  DetailScreen_sound({@required this.title, @required this.room});

  @override
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen_sound> {
  var pressed = false;
  var isTurnon = false;
  var col = Color(0XFF26282B);
  List<SelectModel> _listSelect = [
    SelectModel(
      icon: 'assets/images/light.png',
      name: 'Light',
    ),
    SelectModel(
      icon: 'assets/images/fan.png',
      name: 'Fan',
    ),
    SelectModel(
      icon: 'assets/images/sound.png',
      name: 'Sound',
    ),
    SelectModel(
      icon: 'assets/images/heater.png',
      name: 'Heater',
    ),
    SelectModel(
      icon: 'assets/images/humidity.png',
      name: 'Humidity',
    ),
  ];
  List<Color> colors = [Colors.black, Colors.black45, Colors.black54];

  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[300],
        elevation: 0.0,
        title: Text(
          widget.title,
          style: TextStyle(color: Colors.black87),
        ),
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.grey),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: _height * 0.2,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _listSelect.length,
                itemBuilder: (context, index) {
                  return SelectContainer(
                      icon: _listSelect[index].icon,
                      name: _listSelect[index].name,
                      room: widget.room);
                },
              ),
            ),
            Center(
              child: Container(
                height: 250,

                width: 250,
                color: Colors.grey[50],
                // borderRadius: 200,
                child: Padding(
                  padding: EdgeInsets.all(12),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: IconButton(
                          icon: const Icon(Icons.skip_previous),
                          onPressed: () {},
                        ),
                      ),
                      Expanded(
                        child: IconButton(
                          iconSize: 30.0,
                          icon: pressed == true
                              ? Icon(Icons.play_arrow)
                              : Icon(Icons.pause),
                          onPressed: () {
                            setState(() {
                              pressed = !pressed;
                            });
                          },
                        ),
                      ),
                      Expanded(
                        child: IconButton(
                          icon: const Icon(Icons.skip_next),
                          onPressed: () {},
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: textCate(nameCate: 'Turn On/Off'),
            ),
            SizedBox(
              height: 16,
            ),
            // CustomSlider(),

            Center(
              child: NeuomorphicContainer(
                height: MediaQuery.of(context).size.width * 0.4,
                width: MediaQuery.of(context).size.width * 0.4,
                // color: primaryColor,
                borderRadius: BorderRadius.circular(200),
                color: Colors.grey[50],

                child: Center(
                  child: GestureDetector(
                    onTap: () {
                      print("tap");
                      if (isTurnon) {
                        print("turnoff");
                        //if light is on, then turn off
                        // Flashlight.lightOff();

                        setState(() {
                          // _manager.publish('off', 1, _topicContent, _retainValue);
                          isTurnon = false;
                          // flashicon = Icons.flash_off;
                          col = Colors.grey;
                        });
                      } else {
                        print("turnon");
                        //if light is off, then turn on.
                        // Flashlight.lightOn();
                        // _manager.publish('on', 1, _topicContent, _retainValue);
                        setState(() {
                          isTurnon = true;
                          // flashicon = Icons.flash_on;
                          col = Colors.blue[200];
                        });
                      }
                    },
                    child: Center(
                      child:
                          Icon(Icons.power_settings_new, color: col, size: 80),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 16,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 30.0, left: 16),
              child: textCate(nameCate: 'Timer'),
            ),
            SizedBox(
              height: 8,
            ),
            SelectTime(),
          ],
        ),
      ),
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
}
