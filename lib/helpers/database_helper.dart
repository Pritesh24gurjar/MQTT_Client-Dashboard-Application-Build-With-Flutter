import 'package:mqtt_app/models/devicechoice.dart';
import 'package:mqtt_app/models/devicechoicetemp.dart';
import 'package:mqtt_app/models/devices.dart';
import 'package:mqtt_app/models/room.dart';
import 'package:mqtt_app/models/roomdevices.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'package:mqtt_app/models/todo.dart';
import 'package:mqtt_app/models/task.dart';

class DatabaseHelper {
  Future<Database> database() async {
    return openDatabase(
      join(await getDatabasesPath(), 'data20.db'),
      onCreate: (db, version) async {
        await db.execute(
            "CREATE TABLE broker(id INTEGER PRIMARY KEY, servername TEXT, title TEXT, description TEXT, clientid TEXT,username TEXT,password TEXT,useWS BOOLEAN NOT NULL CHECK (useWS IN (0, 1)),useSSL BOOLEAN NOT NULL CHECK (useSSL IN (0, 1)))");
        await db.execute(
            "CREATE TABLE todo(id INTEGER PRIMARY KEY, taskId INTEGER, title TEXT, isDone INTEGER)");
        await db.execute(
          "CREATE TABLE devices(id INTEGER PRIMARY KEY , title TEXT, sub TEXT , qos INTEGER , retain TEXT ,style TEXT,savetext TEXT,min REAL,max REAL, saveweb TEXT,savewebclick TEXT, saveRadio TEXT)");
        await db.execute(
        "CREATE TABLE devicechoice(id INTEGER PRIMARY KEY,deviceid INTEGER , payloads TEXT, label TEXT)");

        await db.execute(
            "CREATE TABLE devicechoicetemp(id INTEGER PRIMARY KEY,deviceid INTEGER , payloads TEXT, label TEXT)");
        await db.execute(
            "CREATE TABLE rooms(id INTEGER PRIMARY KEY , title TEXT, sub TEXT )");
        await db.execute(
            "CREATE TABLE roomdiv(id INTEGER PRIMARY KEY, roomid INTEGER, title TEXT, pub TEXT , qos INTEGER)");
        await db.execute(
            "CREATE TABLE roomdiv_sl(id INTEGER PRIMARY KEY, roomid INTEGER, title TEXT, pub TEXT , qos INTEGER)");
        return db;
      },
      version: 1,
    );
  }

///////////////// task -> broker /////////////////////////
  Future<int> insertTask(Task task) async {
    int taskId = 0;
    Database _db = await database();
    await _db
        .insert('broker', task.toMap(),
            conflictAlgorithm: ConflictAlgorithm.replace)
        .then((value) {
      taskId = value;
    });

    print('-------------\n\n\n\n\n\n\n\n----------------------');
    return taskId;
  }

  Future<void> updateTaskServername(int id, String servername) async {
    Database _db = await database();
    await _db.rawUpdate("UPDATE broker SET servername = '$servername' WHERE id = '$id'");
  }

  Future<void> updateTaskTitle(int id, String title) async {
    Database _db = await database();
    await _db.rawUpdate("UPDATE broker SET title = '$title' WHERE id = '$id'");
  }

  Future<void> updateTaskDescription(int id, String description) async {
    Database _db = await database();
    await _db.rawUpdate(
        "UPDATE broker SET description = '$description' WHERE id = '$id'");
  }

  Future<void> updateTaskclientId(int id, String clientId) async {
    Database _db = await database();
    await _db
        .rawUpdate("UPDATE broker SET clientId = '$clientId' WHERE id = '$id'");
  }

  Future<void> updateTaskusername(int id, String username) async {
    Database _db = await database();
    await _db
        .rawUpdate("UPDATE broker SET username = '$username' WHERE id = '$id'");
  }

  Future<void> updateTaskpassword(int id, String password) async {
    Database _db = await database();
    await _db
        .rawUpdate("UPDATE broker SET password = '$password' WHERE id = '$id'");
  }

  Future<void> updateTaskWS(int id, int WS) async {
    Database _db = await database();
    await _db
        .rawUpdate("UPDATE broker SET useWS = '$WS' WHERE id = '$id'");
  }

  Future<void> updateTaskSSL(int id, int SSL) async {
    Database _db = await database();
    await _db
        .rawUpdate("UPDATE broker SET useSSL = '$SSL' WHERE id = '$id'");
  }

  Future<void> deleteTask(int id) async {
    Database _db = await database();
    await _db.rawDelete("DELETE FROM broker WHERE id = '$id'");
    await _db.rawDelete("DELETE FROM todo WHERE taskId = '$id'");
  }

//////////////// todo - null///////////////////////
  Future<void> insertTodo(Todo todo) async {
    Database _db = await database();
    await _db.insert('todo', todo.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Task>> getTasks() async {
    Database _db = await database();
    List<Map<String, dynamic>> taskMap = await _db.query('broker');
    return List.generate(taskMap.length, (index) {
      return Task(
        id: taskMap[index]['id'],
        servername: taskMap[index]['servername'],
        title: taskMap[index]['title'],
        description: taskMap[index]['description'],
        clientid: taskMap[index]['clientid'],
        username: taskMap[index]['username'],
        password: taskMap[index]['password'],
        useWS: taskMap[index]['useWS'],
          useSSL: taskMap[index]['useSSL']
      );
    });
  }

  Future<List<Todo>> getTodo(int taskId) async {
    Database _db = await database();
    List<Map<String, dynamic>> todoMap =
        await _db.rawQuery("SELECT * FROM todo WHERE taskId = $taskId");
    return List.generate(todoMap.length, (index) {
      return Todo(
          id: todoMap[index]['id'],
          title: todoMap[index]['title'],
          taskId: todoMap[index]['taskId'],
          isDone: todoMap[index]['isDone']);
    });
  }

  Future<void> updateTodoDone(int id, int isDone) async {
    Database _db = await database();
    await _db.rawUpdate("UPDATE todo SET isDone = '$isDone' WHERE id = '$id'");
  }

  //////////////////////////devices////////////////////////////

  Future<int> insertDevices(Devices devices) async {
    int deviceId = 0;
    Database _db = await database();
    await _db
        .insert('devices', devices.toMap(),
            conflictAlgorithm: ConflictAlgorithm.replace)
        .then((value) {
      deviceId = value;
    });

    print('-------------\n\n\n\n\n\n\n\n----------------------');
    return deviceId;
  }

  Future<void> updateDeviceTitle(int id, String title) async {
    Database _db = await database();
    await _db.rawUpdate("UPDATE devices SET title = '$title' WHERE id = '$id'");
  }

  Future<void> updateDevicesSub(int id, String sub) async {
    Database _db = await database();
    await _db.rawUpdate("UPDATE devices SET sub = '$sub' WHERE id = '$id'");
  }

  Future<void> updateDevicesqos(int id, int qos) async {
    Database _db = await database();
    await _db.rawUpdate("UPDATE devices SET qos = '$qos' WHERE id = '$id'");
  }

  Future<void> updateDevicesretain(int id, String retain) async {
    Database _db = await database();
    await _db.rawUpdate("UPDATE devices SET qos = '$retain' WHERE id = '$id'");
  }

  Future<void> updateDevicesstyle(int id, String style) async {
    Database _db = await database();
    await _db.rawUpdate("UPDATE devices SET style = '$style' WHERE id = '$id'");
  }

  Future<void> updateDevicesText(int id, String saveTEXT) async {
    Database _db = await database();
    await _db.rawUpdate("UPDATE devices SET savetext = '$saveTEXT' WHERE id = '$id'");
  }

  Future<void> updateDevicesMin(int id, double min) async {
    Database _db = await database();
    await _db.rawUpdate("UPDATE devices SET min = '$min' WHERE id = '$id'");
  }

  Future<void> updateDevicesMax(int id, double max) async {
    Database _db = await database();
    await _db.rawUpdate("UPDATE devices SET max = '$max' WHERE id = '$id'");
  }

  Future<void> updateDevicessaveurl(int id, String saveweb) async {
    Database _db = await database();
    await _db.rawUpdate("UPDATE devices SET saveweb = '$saveweb' WHERE id = '$id'");
  }

  Future<void> updateDevicessaveradio(int id, String saveRadio) async {
    Database _db = await database();
    await _db.rawUpdate("UPDATE devices SET saveRadio = '$saveRadio' WHERE id = '$id'");
  }

  Future<void> updateDevicessavewebclick(int id, String savewebclick) async {
    Database _db = await database();
    await _db.rawUpdate("UPDATE devices SET savewebclick = '$savewebclick' WHERE id = '$id'");
  }

  Future<List<Devices>> getDevices() async {
    Database _db = await database();
    List<Map<String, dynamic>> deviceMap = await _db.query('devices');
    return List.generate(deviceMap.length, (index) {
      return Devices(
          id: deviceMap[index]['id'],
          title: deviceMap[index]['title'],
          qos: deviceMap[index]['qos'],
          retain: deviceMap[index]['retain'],
          sub: deviceMap[index]['sub'],
          style: deviceMap[index]['style'],
          savetext: deviceMap[index]['savetext'],
          min: deviceMap[index]['min'],
          max: deviceMap[index]['max'],
          saveweb: deviceMap[index]['saveweb'],
          saveRadio: deviceMap[index]['saveRadio'],
          savewebclick: deviceMap[index]['savewebclick']);
    });
  }

  Future<void> delete_device(int id) async {
    Database _db = await database();
    await _db.rawDelete("DELETE FROM devices WHERE id = '$id'");
  }

  //////////////////////////devices choice////////////////////////////

  Future<int> insertDeviceschoice(Deviceschoice devices) async {
    int deviceId = 0;
    Database _db = await database();
    await _db
        .insert('devicechoice', devices.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace)
        .then((value) {
      deviceId = value;
    });

    print('-------------\n\n\n\n\n\n\n\n----------------------');
    return deviceId;
  }

  Future<void> updateDevicePayload(int id, String payload) async {
    Database _db = await database();
    await _db.rawUpdate("UPDATE devicechoice SET payloads = '$payload' WHERE id = '$id'");
  }

  Future<void> updateDevicesLabel(int id, String label) async {
    Database _db = await database();
    await _db.rawUpdate("UPDATE devicechoice SET label = '$label' WHERE id = '$id'");
  }

  Future<List<Deviceschoice>> getDeviceschoice(int deviceid) async {
    Database _db = await database();
    List<Map<String, dynamic>> deviceMap = await _db.rawQuery("SELECT * FROM devicechoice WHERE deviceid = $deviceid");
    return List.generate(deviceMap.length, (index) {
      return Deviceschoice(
          id: deviceMap[index]['id'],
          deviceId: deviceMap[index]['deviceId'],
          payloads: deviceMap[index]['payloads'],
          label: deviceMap[index]['label']);
    });
  }

  /*Future<List<Deviceschoice>> getDeviceschoice() async {
    Database _db = await database();
    List<Map<String, dynamic>> deviceMap = await _db.query("devicechoice");
    return List.generate(deviceMap.length, (index) {
      return Deviceschoice(
          id: deviceMap[index]['id'],
          deviceId: deviceMap[index]['deviceId'],
          payloads: deviceMap[index]['payloads'],
          label: deviceMap[index]['label']);
    });
  }*/

  Future<void> delete_devicechoice(int id) async {
    Database _db = await database();
    await _db.rawDelete("DELETE FROM devicechoice WHERE id = '$id'");
  }

  //////////////////////////devices choice temp////////////////////////////

  Future<int> insertDeviceschoiceTemp(DeviceschoiceTemp devices) async {
    int deviceId = 0;
    Database _db = await database();
    await _db
        .insert('devicechoicetemp', devices.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace)
        .then((value) {
      deviceId = value;
    });

    print('-------------\n\n\n\n\n\n\n\n----------------------');
    return deviceId;
  }

  Future<void> updateDevicePayloadTemp(int id, String payload) async {
    Database _db = await database();
    await _db.rawUpdate("UPDATE devicechoicetemp SET payloads = '$payload' WHERE id = '$id'");
  }

  Future<void> updateDevicesLabelTemp(int id, String label) async {
    Database _db = await database();
    await _db.rawUpdate("UPDATE devicechoicetemp SET label = '$label' WHERE id = '$id'");
  }

  Future<List<DeviceschoiceTemp>> getDeviceschoiceTemp() async {
    Database _db = await database();
    List<Map<String, dynamic>> deviceMap = await _db.query("devicechoicetemp");
    return List.generate(deviceMap.length, (index) {
      return DeviceschoiceTemp(
          id: deviceMap[index]['id'],
          deviceId: deviceMap[index]['deviceId'],
          payloads: deviceMap[index]['payloads'],
          label: deviceMap[index]['label']);
    });
  }

  Future<void> delete_devicechoiceTemp(int id) async {
    Database _db = await database();
    await _db.rawDelete("DELETE FROM devicechoicetemp WHERE id = '$id'");
  }

  Future<void> plaacedevice_devicechoice(int id) async {
    Database _db = await database();
    await _db.execute("UPDATE devicechoice SET deviceId = '$id' WHERE deviceId = 0");
  }

  /*Future<void> copy_devicechoiceTempAll() async {
    Database _db = await database();
    await _db.execute("INSERT INTO devicechoice SELECT * FROM devicechoicetemp");
  }*/

  Future<void> delete_devicechoiceTempAll() async {
    Database _db = await database();
    await _db.rawDelete("DELETE FROM devicechoicetemp");
  }


///////////////////////////// rooms //////////////////////

  Future<int> insertrooms(Room rooms) async {
    int deviceId = 0;
    Database _db = await database();
    await _db
        .insert('rooms', rooms.toMap(),
            conflictAlgorithm: ConflictAlgorithm.replace)
        .then((value) {
      deviceId = value;
    });

    print('-------------\n\n\n\n\n\n\n\n----------------------');
    return deviceId;
  }

  Future<void> updateRoomTitle(int id, String title) async {
    Database _db = await database();
    await _db.rawUpdate("UPDATE rooms SET title = '$title' WHERE id = '$id'");
  }

  Future<void> updateRoomSub(int id, String sub) async {
    Database _db = await database();
    await _db.rawUpdate("UPDATE rooms SET sub = '$sub' WHERE id = '$id'");
  }

  Future<List<Room>> getrooms() async {
    Database _db = await database();
    List<Map<String, dynamic>> roomMap = await _db.query('rooms');
    return List.generate(roomMap.length, (index) {
      return Room(
          id: roomMap[index]['id'],
          title: roomMap[index]['title'],
          sub: roomMap[index]['sub']);
    });
  }

  Future<void> delete_room(int id) async {
    Database _db = await database();
    await _db.rawDelete("DELETE FROM rooms WHERE id = '$id'");
    await _db.rawDelete("DELETE FROM roomdiv WHERE roomid = '$id'");
  }

  ///////////////////  Room devices ///////////////////
  Future<int> insertRoomdiv(Roomdevices roomdevices) async {
    int roomDivId = 0;
    Database _db = await database();
    await _db
        .insert('roomdiv', roomdevices.toMap(),
            conflictAlgorithm: ConflictAlgorithm.replace)
        .then((value) {
      roomDivId = value;
    });
    print('-------------\n\n\n\n rrom device \n\n\n\n----------------------');
    return roomDivId;
  }

  Future<List<Roomdevices>> getRoomdiv(int roomid) async {
    Database _db = await database();
    List<Map<String, dynamic>> roomMap =
        await _db.rawQuery("SELECT * FROM roomdiv WHERE roomid = $roomid");
    return List.generate(roomMap.length, (index) {
      return Roomdevices(
          id: roomMap[index]['id'],
          title: roomMap[index]['title'],
          roomid: roomMap[index]['roomid'],
          qos: roomMap[index]['qos'],
          pub: roomMap[index]['pub']);
    });
  }

  Future<void> updateRoomdivTitle(int id, String title) async {
    Database _db = await database();
    await _db.rawUpdate("UPDATE roomdiv SET title = '$title' WHERE id = '$id'");
  }

  Future<void> updateRoomdivPub(int id, String pub) async {
    Database _db = await database();
    await _db.rawUpdate("UPDATE roomdiv SET pub = '$pub' WHERE id = '$id'");
  }

  Future<void> updateRoomdivQos(int id, int qos) async {
    Database _db = await database();
    await _db.rawUpdate("UPDATE roomdiv SET qos = '$qos' WHERE id = '$id'");
  }

  Future<void> delete_room_div(int id) async {
    Database _db = await database();
    await _db.rawDelete("DELETE FROM roomdiv WHERE id = '$id'");
  }

  //////////// room device slider  ////////////////
  Future<int> insertRoomdiv_sl(Roomdevices roomdevices) async {
    int roomDivId = 0;
    Database _db = await database();
    await _db
        .insert('roomdiv_sl', roomdevices.toMap(),
            conflictAlgorithm: ConflictAlgorithm.replace)
        .then((value) {
      roomDivId = value;
    });
    print(
        '-------------\n\n\n\n rrom device slider \n\n\n\n----------------------');
    return roomDivId;
  }

  Future<List<Roomdevices>> getRoomdiv_sl(int roomid) async {
    Database _db = await database();
    List<Map<String, dynamic>> roomMap =
        await _db.rawQuery("SELECT * FROM roomdiv_sl WHERE roomid = $roomid");
    return List.generate(roomMap.length, (index) {
      return Roomdevices(
          id: roomMap[index]['id'],
          title: roomMap[index]['title'],
          roomid: roomMap[index]['roomid'],
          qos: roomMap[index]['qos'],
          pub: roomMap[index]['pub']);
    });
  }

  Future<void> updateRoomdivTitle_sl(int id, String title) async {
    Database _db = await database();
    await _db
        .rawUpdate("UPDATE roomdiv_sl SET title = '$title' WHERE id = '$id'");
  }

  Future<void> updateRoomdivPub_sl(int id, String pub) async {
    Database _db = await database();
    await _db.rawUpdate("UPDATE roomdiv_sl SET pub = '$pub' WHERE id = '$id'");
  }

  Future<void> updateRoomdivQos_sl(int id, int qos) async {
    Database _db = await database();
    await _db.rawUpdate("UPDATE roomdiv_sl SET qos = '$qos' WHERE id = '$id'");
  }

  Future<void> delete_room_div_sl(int id) async {
    Database _db = await database();
    await _db.rawDelete("DELETE FROM roomdiv_sl WHERE id = '$id'");
  }
}
