import 'package:intl/intl.dart';

enum MQTTAppConnectionState {
  connected,
  disconnected,
  connecting,
  connectedSubscribed,
  connectedUnSubscribed
}

class MQTTAppState {
  MQTTAppConnectionState _appConnectionState =
      MQTTAppConnectionState.disconnected;
  String _receivedText = '';
  String _historyText = '';
  String _receivedOnlyText = '';
  String _receivedOnlyColor = '';
  String _temp = '';
  String formattedDate =
      DateFormat('yyyy-MM-dd – kk:mm     ').format(DateTime.now());

  void setReceivedText(String text) {
    _receivedText = text;
    _temp = formattedDate + _receivedText;
    _historyText = _historyText + '\n' + _temp;
  }

  void setReceivedOnlyText(String text) {
    _receivedOnlyText = text;
  }

  void setReceivedOnlyColor(String text) {
    _receivedOnlyColor = text;
  }

  void setAppConnectionState(MQTTAppConnectionState state) {
    _appConnectionState = state;
  }

  void clearText() {
    _historyText = "";
    _receivedText = "";
  }

  String get getReceivedText => _receivedText;
  String get getHistoryText => _historyText;
  String get getTempText => _temp;
  String get getReceivedOnlyText => _receivedOnlyText;
  String get getReceivedOnlyColor => _receivedOnlyColor;
  MQTTAppConnectionState get getAppConnectionState => _appConnectionState;
}
