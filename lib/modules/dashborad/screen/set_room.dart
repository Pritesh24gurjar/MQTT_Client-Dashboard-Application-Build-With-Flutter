import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mqtt_app/helpers/database_helper.dart';
import 'package:mqtt_app/models/devices.dart';
import 'package:mqtt_app/models/room.dart';

class Set_room extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<Set_room> {
  final TextEditingController _title = TextEditingController();
  final TextEditingController _topic = TextEditingController();
  DatabaseHelper _dbHelper = DatabaseHelper();
  var selectedCurrency, selectedType;
  final GlobalKey<FormState> _formKeyValue = new GlobalKey<FormState>();
  // List<String> _accountType = <String>[
  //   'Savings',
  //   'Deposit',
  //   'Checking',
  //   'Brokerage'
  // ];
  int _deviceId;
  int _qosValue = 0;
  bool _retainValue = false;
  bool _saveNeeded = false;
  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Scaffold(
        appBar: AppBar(
          // leading: IconButton(
          //     icon: Icon(
          //       FontAwesomeIcons.bars,
          //       color: Colors.white,
          //     ),
          //     onPressed: () {}),
          title: Container(
            alignment: Alignment.centerLeft,
            child: Text("Add device",
                style: TextStyle(
                  color: Colors.white,
                )),
          ),
          // actions: <Widget>[
          //   IconButton(
          //     icon: Icon(
          //       FontAwesomeIcons.coins,
          //       size: 20.0,
          //       color: Colors.white,
          //     ),
          //     onPressed: null,
          //   ),
          // ],
        ),
        body: Form(
          key: _formKeyValue,
          // autovalidateMode: true,
          child: new ListView(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            children: <Widget>[
              SizedBox(height: 20.0),
              new TextFormField(
                  controller: _title,
                  decoration: const InputDecoration(
                    icon: const Icon(
                      Icons.airplay_rounded,
                      color: Colors.blueAccent,
                    ),
                    hintText: 'Enter your device name',
                    labelText: 'Room name ',
                  ),
                  keyboardType: TextInputType.text),
              new TextFormField(
                controller: _topic,
                decoration: const InputDecoration(
                  icon: const Icon(
                    Icons.topic,
                    color: Colors.blueAccent,
                  ),
                  hintText: 'Enter Topic to Subscribe',
                  labelText: 'Topic',
                ),
              ),

              // new TextFormField(
              //   decoration: const InputDecoration(
              //     icon: const Icon(
              //       Icons.account_tree,
              //       color: Colors.blueAccent,
              //     ),
              //     hintText: 'Enter your Email Address',
              //     labelText: 'Email',
              //   ),
              //   keyboardType: TextInputType.emailAddress,
              // ),
              // SizedBox(height: 20.0),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.center,
              //   children: <Widget>[
              //     Icon(
              //       FontAwesomeIcons.moneyBill,
              //       size: 25.0,
              //       color: Colors.blueAccent,
              //     ),
              //     SizedBox(width: 50.0),
              //     // DropdownButton(
              //     //   items: _accountType
              //     //       .map((value) => DropdownMenuItem(
              //     //             child: Text(
              //     //               value,
              //     //               style: TextStyle(color: Color(0xff11b719)),
              //     //             ),
              //     //             value: value,
              //     //           ))
              //     //       .toList(),
              //     //   onChanged: (selectedAccountType) {
              //     //     print('$selectedAccountType');
              //     //     setState(() {
              //     //       selectedType = selectedAccountType;
              //     //     });
              //     //   },
              //     //   value: selectedType,
              //     //   isExpanded: false,
              //     //   hint: Text(
              //     //     'Choose Account Type',
              //     //     style: TextStyle(color: Color(0xff11b719)),
              //     //   ),
              //     // )
              //   ],
              // ),
              SizedBox(height: 40.0),
              // _buildQosChoiceChips(),
              // StreamBuilder<QuerySnapshot>(
              //     // stream: Firestore.instance.collection("currency").snapshots(),
              //     builder: (context, snapshot) {
              //       if (!snapshot.hasData)
              //         const Text("Loading.....");
              //       else {
              //         List<DropdownMenuItem> currencyItems = [];
              //         for (int i = 0; i < snapshot.data.documents.length; i++) {
              //           DocumentSnapshot snap = snapshot.data.documents[i];
              //           currencyItems.add(
              //             DropdownMenuItem(
              //               child: Text(
              //                 snap.documentID,
              //                 style: TextStyle(color: Color(0xff11b719)),
              //               ),
              //               value: "${snap.documentID}",
              //             ),
              //           );
              //         }
              //         return Row(
              //           mainAxisAlignment: MainAxisAlignment.center,
              //           children: <Widget>[
              //             Icon(FontAwesomeIcons.coins,
              //                 size: 25.0, color: Color(0xff11b719)),
              //             SizedBox(width: 50.0),
              //             DropdownButton(
              //               items: currencyItems,
              //               onChanged: (currencyValue) {
              //                 final snackBar = SnackBar(
              //                   content: Text(
              //                     'Selected Currency value is $currencyValue',
              //                     style: TextStyle(color: Color(0xff11b719)),
              //                   ),
              //                 );
              //                 Scaffold.of(context).showSnackBar(snackBar);
              //                 setState(() {
              //                   selectedCurrency = currencyValue;
              //                 });
              //               },
              //               value: selectedCurrency,
              //               isExpanded: false,
              //               hint: new Text(
              //                 "Choose Currency Type",
              //                 style: TextStyle(color: Color(0xff11b719)),
              //               ),
              //             ),
              //           ],
              //         );
              //       }
              //     }),
              // SizedBox(
              //   height: 5.0,
              // ),
              // Container(
              //   decoration: BoxDecoration(
              //       border:
              //           Border(bottom: BorderSide(color: theme.dividerColor))),
              //   child: Row(children: <Widget>[
              //     Checkbox(
              //         value: _retainValue,
              //         onChanged: (bool value) {
              //           setState(() {
              //             _retainValue = value;
              //             _saveNeeded = true;
              //           });
              //         }),
              //     const Text('Retain message'),
              //     SizedBox(
              //       height: 15.0,
              //     ),
              //   ]),
              // ),
              // SizedBox(
              //   height: 15.0,
              // ),
              _buildConnectBtn(),
            ],
          ),
        ));
  }

  Widget _buildConnectBtn() {
    // MQTTAppConnectionState state = _manager.currentState.getAppConnectionState;
    return Container(
      padding: EdgeInsets.symmetric(vertical: 25.0),
      width: double.infinity,
      child: RaisedButton(
        elevation: 5.0,
        onPressed: () async {
          Room _newRoom = Room(
            title: _title.text,
            sub: _topic.text,
            // qos: _qosValue.toString(),
            // retain: _retainValue.toString(),
            // qos: _qosValue,
          );

          _deviceId = await _dbHelper.insertrooms(_newRoom);
        },
        padding: EdgeInsets.all(10.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        color: Colors.white,
        child: Text(
          'Save',
          style: TextStyle(
            color: Color(0xFF527DAA),
            letterSpacing: 1.5,
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
            fontFamily: 'OpenSans',
          ),
        ),
      ),
    );
  }

  Wrap _buildQosChoiceChips() {
    return Wrap(
      spacing: 4.0,
      children: List<Widget>.generate(
        3,
        (int index) {
          return ChoiceChip(
            label: Text('QoS level $index'),
            selected: _qosValue == index,
            onSelected: (bool selected) {
              setState(() {
                _qosValue = selected ? index : null;
              });
            },
          );
        },
      ).toList(),
    );
  }
}
