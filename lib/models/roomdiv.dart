class Roomdev {
  final int id;
  final int roomId;
  final String title;
  final String message;
  final String sub;
  Roomdev({this.id, this.roomId, this.title, this.message, this.sub});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'roomId': roomId,
      'title': title,
      'message': message,
      'sub': sub,
    };
  }
}
