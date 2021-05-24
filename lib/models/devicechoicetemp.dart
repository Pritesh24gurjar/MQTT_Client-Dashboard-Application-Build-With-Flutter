class DeviceschoiceTemp {
  final int id;
  final int deviceId;
  final String payloads;
  final String label;
  DeviceschoiceTemp({this.id, this.deviceId, this.payloads, this.label});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'deviceId': deviceId,
      'payloads': payloads,
      'label': label,
    };
  }
}
