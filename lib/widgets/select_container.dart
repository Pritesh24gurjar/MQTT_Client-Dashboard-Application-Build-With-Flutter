import 'package:flutter/material.dart';
import 'package:mqtt_app/screens/detail_screen.dart';
import 'package:mqtt_app/screens/detail_screen_fan.dart';

class SelectContainer extends StatelessWidget {
  final String icon;
  final String name;

  SelectContainer({
    @required this.icon,
    @required this.name,
  });

  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.height;

    return Padding(
      padding: const EdgeInsets.only(left: 16.0, top: 24),
      child: Column(
        children: [
          GestureDetector(
            onTap: () async {
              if (name == "Light") {
                // Navigator.pop(context);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => DetailScreen(title: name)));
              } else if (name == "Fan") {
                // Navigator.pop(context);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => DetailScreen_fan(title: name)));
              } else if (name == "Sound") {
                //
              } else if (name == "Heater") {
                //
              }
            },
            child: Container(
              height: _height * 0.08,
              width: _width / 5.8,
              padding: EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(15),
              ),
              child: Opacity(
                opacity: 0.5,
                child: Image.asset(icon),
              ),
            ),
          ),
          SizedBox(
            height: 8,
          ),
          Text(
            name,
            style: TextStyle(color: Colors.grey[400]),
          ),
        ],
      ),
    );
  }
}
