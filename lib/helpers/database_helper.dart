import 'package:mqtt_app/models/devices.dart';
import 'package:mqtt_app/models/room.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'package:mqtt_app/models/todo.dart';
import 'package:mqtt_app/models/task.dart';

class DatabaseHelper {
  Future<Database> database() async {
    return openDatabase(
      join(await getDatabasesPath(), 'xyz2.db'),
      onCreate: (db, version) async {
        await db.execute(
            "CREATE TABLE broker(id INTEGER PRIMARY KEY, title TEXT, description TEXT, clientid TEXT,username TEXT,password TEXT)");
        await db.execute(
            "CREATE TABLE todo(id INTEGER PRIMARY KEY, taskId INTEGER, title TEXT, isDone INTEGER)");
        await db.execute(
            "CREATE TABLE devices(id INTEGER PRIMARY KEY , title TEXT, sub TEXT , qos TEXT , retain TEXT )");
        await db.execute(
            "CREATE TABLE rooms(id INTEGER PRIMARY KEY , title TEXT, sub TEXT )");
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
        title: taskMap[index]['title'],
        description: taskMap[index]['description'],
        clientid: taskMap[index]['clientid'],
        username: taskMap[index]['username'],
        password: taskMap[index]['password'],
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

  Future<void> updateDevicesqos(int id, String qos) async {
    Database _db = await database();
    await _db.rawUpdate("UPDATE devices SET qos = '$qos' WHERE id = '$id'");
  }

  Future<void> updateDevicesretain(int id, String retain) async {
    Database _db = await database();
    await _db.rawUpdate("UPDATE devices SET qos = '$retain' WHERE id = '$id'");
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
          sub: deviceMap[index]['sub']);
    });
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
}