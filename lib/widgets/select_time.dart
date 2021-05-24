import 'package:flutter/material.dart';
import 'package:date_format/date_format.dart';
import 'package:intl/intl.dart';

class SelectTime extends StatefulWidget {
  @override
  _SelectTimeState createState() => _SelectTimeState();
}

class _SelectTimeState extends State<SelectTime> {
  double _height;
  double _width;

  String _setTime, _setDate;

  String _hour, _minute, _time,_hourEnd, _minuteEnd, _timeEnd;

  String dateTime;

  TimeOfDay selectedTime = TimeOfDay(hour: 00, minute: 00);

  TimeOfDay selectedTimeEnd = TimeOfDay(hour: 00, minute: 00);

  TextEditingController _timeController = TextEditingController();
  TextEditingController _timeControllerEnd = TextEditingController();

  Future<Null> _selectTime(BuildContext context) async {
    final TimeOfDay picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );
    if (picked != null)
      setState(() {
        selectedTime = picked;
        _hour = selectedTime.hour.toString();
        _minute = selectedTime.minute.toString();
        _time = _hour + ' : ' + _minute;
        _timeController.text = _time;
        _timeController.text = formatDate(
            DateTime(2019, 08, 1, selectedTime.hour, selectedTime.minute),
            [hh, ':', nn, " ", am]).toString();
      });}

  Future<Null> _selectTimeEnd(BuildContext context) async {
    final TimeOfDay picked = await showTimePicker(
      context: context,
      initialTime: selectedTimeEnd,
    );
    if (picked != null)
      setState(() {
        selectedTimeEnd = picked;
        _hourEnd = selectedTimeEnd.hour.toString();
        _minuteEnd = selectedTimeEnd.minute.toString();
        _timeEnd = _hourEnd + ' : ' + _minuteEnd;
        _timeControllerEnd.text = _timeEnd;
        _timeControllerEnd.text = formatDate(
            DateTime(2019, 08, 1, selectedTimeEnd.hour, selectedTimeEnd.minute),
            [hh, ':', nn, " ", am]).toString();
      });}

  @override
  void initState() {
    _timeController.text = formatDate(
        DateTime(2019, 08, 1, selectedTime.hour, selectedTime.minute),
        [hh, ':', nn, " ", am]).toString();
    super.initState();

    _timeControllerEnd.text = formatDate(
        DateTime(2019, 08, 1, selectedTimeEnd.hour, selectedTimeEnd.minute),
        [hh, ':', nn, " ", am]).toString();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;
    dateTime = DateFormat.yMd().format(DateTime.now());
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'From',
                style: TextStyle(color: Colors.grey),
              ),
              SizedBox(
                height: 8,
              ),
              SizedBox(
                height: 45,
                width: MediaQuery.of(context).size.width/2.52,
                child: OutlineButton(
                  onPressed: () {
                    _selectTime(context);
                  },
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(_timeController.text,style: TextStyle(color: Colors.grey),),
                      Icon(Icons.keyboard_arrow_down,color: Colors.grey),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'To',
                style: TextStyle(color: Colors.grey),
              ),
              SizedBox(
                height: 8,
              ),
              SizedBox(
                height: 45,
                width: MediaQuery.of(context).size.width/2.52,
                child: OutlineButton(
                  onPressed: () {
                    _selectTimeEnd(context);
                  },
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(_timeControllerEnd.text,style: TextStyle(color: Colors.grey),),
                      Icon(Icons.keyboard_arrow_down,color: Colors.grey),
                    ],
                  ),
                ),
              ),
              /*InkWell(
                onTap: () {
                  _selectTime(context);
                },
                child: Container(
                  margin: EdgeInsets.only(top: 30),
                  width: _width / 1.7,
                  height: _height / 9,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(color: Colors.grey[200]),
                  child: TextFormField(
                    style: TextStyle(fontSize: 40),
                    textAlign: TextAlign.center,
                    onSaved: (String val) {
                      _setTime = val;
                    },
                    enabled: false,
                    keyboardType: TextInputType.text,
                    controller: _timeController,
                    decoration: InputDecoration(
                        disabledBorder:
                        UnderlineInputBorder(borderSide: BorderSide.none),
                        // labelText: 'Time',
                        contentPadding: EdgeInsets.all(5)),
                  ),
                ),
              ),*/
            ],
          ),
        ],
      ),
    );
  }
}

