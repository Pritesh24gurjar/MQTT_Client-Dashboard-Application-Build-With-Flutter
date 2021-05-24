import 'package:flutter/material.dart';
import 'package:mqtt_app/widgets/widgets.dart';
import 'package:mqtt_app/helpers/database_helper.dart';
import 'package:provider/provider.dart';
import 'package:mqtt_app/widgets/choicelist_on_setup.dart';
import 'package:mqtt_app/models/devices.dart';

class choiceinside extends StatefulWidget {
  final devicesinfo;
  final String title;
  final String pub;
  final int qos;
  choiceinside({this.title, this.pub, this.qos,@required this.devicesinfo});

  @override
  choiceinsideState createState() => choiceinsideState();
}

class choiceinsideState extends State<choiceinside> {
  DatabaseHelper _dbHelper = DatabaseHelper();
  int _qosValue = 0;
  @override
  Widget build(BuildContext context) {
    double _height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Set option',
              textAlign: TextAlign.left,
            ),
            Container(
              child: FutureBuilder(
                initialData: [],
                future: _dbHelper.getDeviceschoice(widget.devicesinfo.id),
                builder: (context, snapshot) {
                  return Container(
                    height: _height * 0.3,
                    child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      itemCount: snapshot.data.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onLongPress: () async {

                          },
                            child: CustomSDisplayChoice(
                              payload: snapshot.data[index].payloads,
                              label: snapshot.data[index].label,
                              //divinfo: snapshot.data[index],
                            ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),

    );
  }
  /*Wrap _buildQosChoiceChips() {
    return Wrap(
      direction: Axis.vertical,
      spacing: 4.0,
      children: List<Widget>.generate(
        3,
            (int index) {
          return ChoiceChip(
            label: Text('QoS level $index'),
            selected: _qosValue == index,
            onSelected: (bool selected) {
              setState(() async {
                _qosValue = selected ? index : null;
                //await _dbHelper.updateDevicesqos(_taskId, _qosValue);
              });
            },
          );
        },
      ).toList(),
    );
  }*/
}