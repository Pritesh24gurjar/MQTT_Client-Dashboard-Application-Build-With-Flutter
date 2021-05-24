import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:mqtt_app/modules/core/managers/MQTTManager.dart';
import 'package:provider/provider.dart';

class temperatureinside extends StatefulWidget {
  final devices;
  final String title;
  final String pub;
  final int qos;
  final double min;
  final double max;
  temperatureinside({@required this.devices,this.title, this.pub, this.qos,this.min,this.max});
  @override
  temperatureinsideState createState() => temperatureinsideState();
}

class temperatureinsideState extends State<temperatureinside> {
  MQTTManager _manager;
  double _value = 0.0;
  //void _setValue(double value) => setState(() => _value = value);
  static double minValue;
  static double maxValue;

  static double minAngle;
  static double maxAngle;
  static double sweepAngle = maxAngle - minAngle;

  void initState() {

      minValue = widget.min;
      maxValue = widget.max;
      minAngle = -(maxValue+10);
      maxAngle = maxValue+10;
      sweepAngle = maxAngle - minAngle;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //double _normalisedValue = (_value - minValue)/(maxValue - minValue);
    //double _angle = (minAngle + _normalisedValue * sweepAngle) * 2 * pi / 360;
    _manager = Provider.of<MQTTManager>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SfRadialGauge(
            axes: <RadialAxis>[
                RadialAxis(minimum:  minValue, maximum: maxValue,
                ranges: <GaugeRange>[
                  GaugeRange(startValue: minValue, endValue:  50, color:Colors.green),
                  GaugeRange(startValue: 50,endValue: 100,color: Colors.orange),
                  GaugeRange(startValue: 100,endValue: maxValue,color: Colors.red)],
                pointers: <GaugePointer>[
                  NeedlePointer(value: _value)],
                annotations: <GaugeAnnotation>[
                  GaugeAnnotation(widget: Container(child:
                  Text(_value.toStringAsFixed(_value.truncateToDouble() == _value ? 0 : 2),style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold))),
                      angle: 90, positionFactor: 0.5
                  )]
            )]),
            Slider(
                value: _value,
                onChanged: (double newValue) {
                  setState(() {
                    _value = newValue;
                  });
                  _manager.publish(newValue.toString(), widget.qos, widget.pub, false);
                },
                //_manager.publish(value.toString(), widget.qos, widget.pub, false);
                min: minValue,
                max: maxValue),

          ],
        ),
      ),
    );
  }
}