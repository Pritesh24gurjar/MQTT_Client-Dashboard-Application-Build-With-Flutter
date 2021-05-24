import 'package:flutter/material.dart';
import 'package:mqtt_app/models/room.dart';
import 'package:mqtt_app/modules/core/managers/MQTTManager.dart';
import 'package:mqtt_app/modules/dashborad/screen/updatePage/roomdevice_slider%20form.dart';
import 'package:provider/provider.dart';

class CustomSlider extends StatefulWidget {
  // final Room roomdivinfo;
  final String title;
  // final String image;
  final String pub;
  final int qos;
  final roomdivinfo;
  CustomSlider({
    this.title,
    // this.image,
    this.roomdivinfo,
    this.pub,
    this.qos,
  });

  // CustomSlider({@required this.roomdivinfo});
  @override
  _CustomSliderState createState() => _CustomSliderState();
}

class _CustomSliderState extends State<CustomSlider> {
  double value = 0;
  MQTTManager _manager;
  @override
  Widget build(BuildContext context) {
    _manager = Provider.of<MQTTManager>(context);
    return Container(
      child: Row(
        children: [
          Card(
            elevation: 3,
            shadowColor: Colors.grey[300],
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            // margin: EdgeInsets.all(20),
            child: Container(
              height: 80,
              width: 300,
              child: Column(
                children: [
                  SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      valueIndicatorColor: Colors.transparent,
                      activeTrackColor: Colors.black87,
                      inactiveTrackColor: Colors.grey[200],
                      //showValueIndicator: ShowValueIndicator.onlyForDiscrete,
                      valueIndicatorTextStyle: TextStyle(color: Colors.green),
                      trackShape: RectangularSliderTrackShape(),
                      trackHeight: 4.0,
                      thumbColor: Colors.white,
                      thumbShape:
                          RoundSliderThumbShape(enabledThumbRadius: 12.0),
                      overlayColor: Colors.white38,
                      overlayShape:
                          RoundSliderOverlayShape(overlayRadius: 18.0),
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
                        _manager.publish(value.toInt().toString(), widget.qos,
                            widget.pub, false);
                        setState(() {
                          // _manager.publish(
                          //     value.toString(), widget.qos, widget.pub, false);
                        });
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Off',
                          style: TextStyle(color: Colors.grey),
                        ),
                        Text(
                          '${widget.title}',
                          style: TextStyle(color: Colors.grey),
                        ),
                        Text(
                          '100%',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              //
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => RoomDivForm_slider(
                            // roomdivinfo: widget.room,
                            roomdevices: widget.roomdivinfo,
                          )));
            },
            alignment: Alignment.topRight,
          ),
        ],
      ),
    );
  }
}
