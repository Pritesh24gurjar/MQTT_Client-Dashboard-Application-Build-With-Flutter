class Devices {
  final int id;
  final String title;
  // final String image;
  final String sub;
  final String qos;
  final String retain;
  Devices({this.id, this.title, this.qos, this.retain, this.sub});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'sub': sub,
      'qos': qos,
      'retain': retain,
    };
  }
}
