class Room {
  final int id;
  final String title;
  final String sub;
  Room({this.id, this.title, this.sub});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'sub': sub,
    };
  }
}
