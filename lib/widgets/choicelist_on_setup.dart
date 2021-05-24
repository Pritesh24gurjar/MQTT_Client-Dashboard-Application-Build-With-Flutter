import 'package:flutter/material.dart';
import 'package:mqtt_app/models/room.dart';
import 'package:mqtt_app/modules/core/managers/MQTTManager.dart';
import 'package:provider/provider.dart';
import 'package:mqtt_app/helpers/database_helper.dart';

class CustomSDisplayChoice extends StatefulWidget {
  // final Room roomdivinfo;
  // final String image;
  final String payload;
  final String label;
  final divinfo;
  CustomSDisplayChoice({
    this.payload,
    this.label,
    this.divinfo,
  });

  // CustomSlider({@required this.roomdivinfo});
  @override
  _CustomSDisplayChoiceState createState() => _CustomSDisplayChoiceState();
}

class _CustomSDisplayChoiceState extends State<CustomSDisplayChoice> {
  DatabaseHelper _dbHelper = DatabaseHelper();
  double value = 0;
  MQTTManager _manager;

  @override
  /*Widget build(BuildContext context) {
    _manager = Provider.of<MQTTManager>(context);
    double _height = MediaQuery.of(context).size.height;
    return Container(
      height: _height * 0.3,
      child: FutureBuilder(
        initialData: [],
        future: _dbHelper.getDeviceschoice(),
        builder: (context, snapshot) {
          return Container(
            //height: _height * 0.3,
            child: ListView.builder(
              scrollDirection: Axis.vertical,
              itemCount: snapshot.data.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onLongPress: () async {

                  },
                  child:SimpleDialogOption(
                      child: Text(widget.label),
                      onPressed: () {
                        print(widget.payload);
                      },
                    ),
                );
              },
            ),
          );
        },
      ),
    );
  }*/
  Widget build(BuildContext context) {
    _manager = Provider.of<MQTTManager>(context);
    return SimpleDialogOption(
        child: Text(widget.label),
        onPressed: () {
          print(widget.payload);
        }
    );
    /*return ListTile(
      title: const Text('Lafayette'),
      leading: Radio<SingingCharacter>(
        //value: SingingCharacter.lafayette,
        //groupValue: _character,
        onChanged: (SingingCharacter? value) {
          setState(() {
            _character = value;
          });
        },
      ),
    );
  }*/

    /*showAlertDialog(BuildContext context) {
    // set up the list options
    Widget optionOne = SimpleDialogOption(
      child: const Text('Text'),
      onPressed: () {
        print('Text');
      },
    );


    // set up the SimpleDialog
    SimpleDialog dialog = SimpleDialog(
      title: const Text('Set option'),
      children: <Widget>[
        optionOne,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return dialog;
      },
    );
  }*/

  }
}
