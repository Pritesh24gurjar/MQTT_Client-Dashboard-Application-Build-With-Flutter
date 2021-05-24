import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mqtt_app/helpers/database_helper.dart';
import 'package:mqtt_app/models/models.dart';
import 'package:mqtt_app/models/select_model.dart';
import 'package:mqtt_app/modules/dashborad/screen/dashborad.dart';
import 'package:mqtt_app/modules/dashborad/screen/updatePage/roomdevice_slider%20form.dart';
import 'package:mqtt_app/modules/dashborad/screen/updatePage/roomdivform.dart';
import 'package:mqtt_app/modules/dashborad/screen/roomdivset.dart';
import 'package:mqtt_app/widgets/cutom_dialog_roomdiv.dart';

import 'package:mqtt_app/widgets/lighting_card.dart';
import 'package:mqtt_app/widgets/widgets.dart';

class DetailScreen extends StatefulWidget {
  final room;
  final title;
  DetailScreen({@required this.room, this.title});

  @override
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  DatabaseHelper _dbHelper = DatabaseHelper();
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

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[300],
        elevation: 0.0,
        leading: IconButton(
            icon: Icon(
              Icons.keyboard_backspace_sharp,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => Dashborad()));
            }),
        title: Text(
          widget.room.title,
          style: TextStyle(color: Colors.black87),
        ),
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.grey),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.add_circle,
              size: 30.0,
              color: Colors.white,
            ),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) => CustomDialogroomdiv(
                  title: "Would you like to create Rooms and device tiles?",
                  description:
                      "By creating rooms you can access to other devices which cames under room",
                  primaryButtonText: "Create light",
                  primaryButtonRoute: "/Device",
                  secondaryButtonText: "Create slider",
                  secondaryButtonRoute: "/Room",
                  roomdivinfo: widget.room,
                ),
              );
            },
          ),
        ],
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
                    room: widget.room,
                  );
                },
              ),
            ),
            Container(
              child: FutureBuilder(
                initialData: [],
                future: _dbHelper.getRoomdiv(widget.room.id),
                builder: (context, snapshot) {
                  return Container(
                    height: _height * 0.3,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: snapshot.data.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onLongPress: () async {
                            //_dbHelper.getRoomdiv(widget.room.id)
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => RoomDivForm(
                                          // roomdivinfo: widget.room,
                                          roomdevices: snapshot.data[index],
                                        )));
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(
                                right: 8.0, top: 16, bottom: 16),
                            child: LightingCard(
                              title: snapshot.data[index].title,
                              image: 'assets/images/ceiling_lighting.png',
                              pub: snapshot.data[index].pub,
                              qos: snapshot.data[index].qos,
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: textCate(nameCate: 'Intensive'),
            ),
            SizedBox(
              height: 16,
            ),
            Container(
              child: FutureBuilder(
                initialData: [],
                future: _dbHelper.getRoomdiv_sl(widget.room.id),
                builder: (context, snapshot) {
                  return Container(
                    height: _height * 0.14,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: snapshot.data.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onLongPress: () async {
                            //_dbHelper.getRoomdiv(widget.room.id)
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => RoomDivForm_slider(
                                          // roomdivinfo: widget.room,
                                          roomdevices: snapshot.data[index],
                                        )));
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(
                                right: 8.0, top: 16, bottom: 16),
                            child: CustomSlider(
                              title: snapshot.data[index].title,
                              // image: 'assets/images/ceiling_lighting.png',
                              roomdivinfo: snapshot.data[index],
                              pub: snapshot.data[index].pub,
                              qos: snapshot.data[index].qos,
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
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
