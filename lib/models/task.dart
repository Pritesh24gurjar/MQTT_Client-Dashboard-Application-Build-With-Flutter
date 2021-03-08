class Task {
  final int id;
  final String title;
  final String description;
  final String clientid;
  final String username;
  final String password;
  Task({
    this.id,
    this.title,
    this.description,
    this.clientid,
    this.username,
    this.password,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'clientid': clientid,
      'password': password,
      'username': username,
    };
  }
}
