class Roomdevices {
  final int id;
  final int roomid;
  final String title;
  final int qos;
  final String pub;
  Roomdevices({this.id, this.roomid, this.title, this.pub, this.qos});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'roomid': roomid,
      'title': title,
      'pub': pub,
      'qos': qos,
    };
  }
}
