import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mqtt_app/models/models.dart';
import 'package:mqtt_app/models/select_model.dart';

import 'package:flutter_thermometer/label.dart';
import 'package:flutter_thermometer/scale.dart';
import 'package:flutter_thermometer/setpoint.dart';
import 'package:flutter_thermometer/thermometer.dart';
import 'package:flutter_thermometer/thermometer_paint.dart';
import 'package:flutter_thermometer/thermometer_widget.dart';
import 'package:mqtt_app/modules/core/managers/MQTTManager.dart';

import 'package:mqtt_app/widgets/lighting_card.dart';
import 'package:mqtt_app/widgets/widgets.dart';
import 'package:neuomorphic_container/neuomorphic_container.dart';
import 'package:provider/provider.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';

class DetailScreen_heater extends StatefulWidget {
  final String title;
  final room;
  DetailScreen_heater({@required this.title, @required this.room});

  @override
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen_heater> {
  var isTurnon = false;
  var col = Color(0XFF26282B);
  var value = 0.0;
  double minValue = 0.0;
  double maxValue = 150.0;
  var thermoWidth = 150.0;
  var thermoHeight = 150.0;

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
  List<LightingModel> _listLighting = [
    LightingModel(
      name: 'Ceiling\nLighting',
      image: 'assets/images/ceiling_lighting.png',
    ),
    LightingModel(
      name: 'Table\nLamp',
      image: 'assets/images/table_lamp.png',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.height;
    MQTTManager _manager;
    _manager = Provider.of<MQTTManager>(context);
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

            /*Center(
          child: SizedBox(
              width: thermoWidth,
              height: thermoHeight,
              child: Thermometer(
                  value: _test,
                  minValue: minValue,
                  maxValue: maxValue,
              ),
          ),
        ),*/

            Padding(
              padding: const EdgeInsets.only(right: 8.0, top: 16, bottom: 16),
              child: SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  activeTrackColor: Colors.red[700],
                  inactiveTrackColor: Colors.red[100],
                  trackShape: RectangularSliderTrackShape(),
                  trackHeight: 4.0,
                  thumbColor: Colors.redAccent,
                  thumbShape: RoundSliderThumbShape(enabledThumbRadius: 12.0),
                  overlayColor: Colors.red.withAlpha(32),
                  overlayShape: RoundSliderOverlayShape(overlayRadius: 28.0),
                ),
                child: Slider(
                  value: value,
                  min: 0,
                  max: 100,
                  label: '${value.toInt()}%',
                  divisions: 100,
                  //inactiveColor: Colors.grey[300],
                  onChanged: (val) {
                    value = val;
                    print(val);
                    _manager.publish(
                        value.toInt().toString(), 1, widget.room.sub, false);
                    setState(() {
                      // _manager.publish(
                      //     value.toString(), widget.qos, widget.pub, false);
                    });
                  },
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
                      String sub = widget.room.sub.toString();
                      print("tap");
                      if (isTurnon) {
                        print("turnoff");
                        //if light is on, then turn off
                        // Flashlight.lightOff();
                        _manager.publish('off', 1, sub, false);
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
                        _manager.publish('off', 1, sub, false);
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
