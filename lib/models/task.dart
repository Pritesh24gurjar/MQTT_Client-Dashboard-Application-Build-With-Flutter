class Task {
  final int id;
  final String servername;
  final String title;
  final String description;
  final String clientid;
  final String username;
  final String password;
  final int useWS;
  final int useSSL;

  Task({
    this.id,
    this.servername,
    this.title,
    this.description,
    this.clientid,
    this.username,
    this.password,
    this.useWS,
    this.useSSL,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'servername' : servername,
      'title': title,
      'description': description,
      'clientid': clientid,
      'password': password,
      'username': username,
      'useWS' : useWS,
      'useSSL' : useSSL
    };
  }
}
