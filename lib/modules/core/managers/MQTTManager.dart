import 'dart:async';
import 'dart:io';
// hairdresser.cloudmqtt.com
// 	lhpibxbv
// lhpibxbv
// wCUaWT6VJfTp
// 25837
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:flutter/material.dart';
import '../models/MQTTAppState.dart';
// import 'package:event_bus/event_bus.dart';
import 'package:mqtt_app/modules/core/managers/eventbus.dart';

class MQTTManager extends ChangeNotifier {
  // Private instance of client
  var events;
  MQTTAppState _currentState = MQTTAppState();
  MqttServerClient _client;
  MqttServerClient _clientWS;
  MqttServerClient _clientSSL;
  String _identifier;
  String _host;
  String _topic = "";
  String _username;
  String _password;
  String _port;
  String _hostWS;
  bool _useWS;
  SecurityContext securityContext = SecurityContext.defaultContext;

  /// Callback function to handle bad certificate. if true, ignore the error.
  bool Function(X509Certificate certificate) onBadCertificate;

  /// If set use a websocket connection, otherwise use the default TCP one
  //bool useWebSocket = false;

  /// If set use the alternate websocket implementation
  //bool useAlternateWebSocketImplementation = false;

  /// If set use a secure connection, note TCP only, do not use for
  /// secure websockets(wss).
  //bool secure = false;

  /// Max connection attempts
  final int maxConnectionAttempts = 3;

  void initializeMQTTClient({
    @required String host,
    @required String identifier,
    @required String port,
    @required String username,
    @required String password,
  }) {
    _identifier = identifier;
    _host = host;
    _port = port;
    _username = username;
    _password = password;
    // _useWS = useWS;
    _client = MqttServerClient(_host, _identifier);
    _client.port = int.parse(_port);
    _client.keepAlivePeriod = 20;
    _client.onDisconnected = onDisconnected;
    _client.secure = false;
    _client.logging(on: true);
    _client.useWebSocket = false;

    /// Add the successful connection callback
    _client.onConnected = onConnected;
    _client.onSubscribed = onSubscribed;
    _client.onUnsubscribed = onUnsubscribed;

    final MqttConnectMessage connMess = MqttConnectMessage()
        .withClientIdentifier(_identifier)
        .withWillTopic(
        'willtopic') // If you set this you must set a will message
        .withWillMessage('My Will message')
        .startClean() // Non persistent session for testing
    //.authenticateAs(username, password)// Non persistent session for testing
        .withWillQos(MqttQos.atLeastOnce);
    print('EXAMPLE::Mosquitto client connecting....');
    _client.connectionMessage = connMess;
  }

  void initializeMQTTClientSSL({
    @required String host,
    @required String identifier,
    @required String port,
    @required String username,
    @required String password,
    // @required bool useWS,
  }) {
    _identifier = identifier;
    _host = host;
    _port = port;
    _username = username;
    _password = password;
    // _useWS = useWS;

    _clientSSL = MqttServerClient(_host, _identifier);
    _clientSSL.port = int.parse(_port);
    _clientSSL.keepAlivePeriod = 20;
    _clientSSL.onDisconnected = onDisconnected;
    _clientSSL.secure = true;
    _clientSSL.logging(on: true);
    _clientSSL.useWebSocket = false;

    //AsymmetricKeyPair keyPair = rsaGenerateKeyPair();
    /*securityContext.useCertificateChain('path/to/my_cert.pem');
    securityContext.usePrivateKey('path/to/my_key.pem', password: '336600');
    securityContext.setClientAuthorities('path/to/client.crt', password: '336600');*/

    _clientSSL.useAlternateWebSocketImplementation = false;
    _clientSSL.securityContext = securityContext;
    _clientSSL.onBadCertificate = onBadCertificate;

    /// Add the successful connection callback
    _clientSSL.onConnected = onConnected;
    _clientSSL.onSubscribed = onSubscribed;
    _clientSSL.onUnsubscribed = onUnsubscribed;

    final MqttConnectMessage connMess = MqttConnectMessage()
        .withClientIdentifier(_identifier)
        .withWillTopic(
        'willtopic') // If you set this you must set a will message
        .withWillMessage('My Will message')
        .startClean() // Non persistent session for testing
    //.authenticateAs(username, password)// Non persistent session for testing
        .withWillQos(MqttQos.atLeastOnce);
    print('EXAMPLE::Mosquitto client connecting....');
    _clientSSL.connectionMessage = connMess;
  }

  void initializeMQTTClientWS({
    @required String host,
    @required String identifier,
    @required String port,
    @required String username,
    @required String password,
    @required bool useWS,
  }) {
    _identifier = identifier;
    _host = host;
    _port = port;
    _username = username;
    _password = password;
    _useWS = useWS;
    _hostWS = 'ws://' + _host + ':' + _port + '/mqtt';
    _clientWS = MqttServerClient(_hostWS, _identifier);
    _clientWS.port = int.parse(_port);
    _clientWS.keepAlivePeriod = 20;
    _clientWS.onDisconnected = onDisconnected;
    _clientWS.secure = false;
    _clientWS.logging(on: true);
    //_clientWS.useWebSocket = true;
    _clientWS.useAlternateWebSocketImplementation = true;


    /// Add the successful connection callback
    _clientWS.onConnected = onConnected;
    _clientWS.onSubscribed = onSubscribed;
    _clientWS.onUnsubscribed = onUnsubscribed;

    final MqttConnectMessage connMess = MqttConnectMessage()
        .withClientIdentifier(_identifier)
        .withWillTopic(
        'willtopic') // If you set this you must set a will message
        .withWillMessage('My Will message')
        .startClean() // Non persistent session for testing
    //.authenticateAs(username, password)// Non persistent session for testing
        .withWillQos(MqttQos.atLeastOnce);
    print('EXAMPLE::Mosquitto client connecting....');
    _clientWS.connectionMessage = connMess;
  }

  String get host => _host;
  MQTTAppState get currentState => _currentState;
  // Connect to the host
  void connect() async {
    var instantiationCorrect = true;
    // var clientEventBus = streamController;
    // var connectionHandler = SynchronousMqttServerConnectionHandler(
    //   clientEventBus,
    //   maxConnectionAttempts: maxConnectionAttempts,
    // );

    /*if (_client.secure == secure) {
      print('Hello world');
      _client.secure = true;
      _client.useWebSocket = false;
      _client.useAlternateWebSocketImplementation = false;
      _client.securityContext = securityContext;
      _client.onBadCertificate = onBadCertificate;
    }*/
    assert(_client != null);
    try {
      print('EXAMPLE::Mosquitto start client connecting....');
      _currentState.setAppConnectionState(MQTTAppConnectionState.connecting);
      updateState();
      await _client.connect(_username, _password);
      print('heloooo\n\n\n\n\n----------');
    } on Exception catch (e) {
      print('EXAMPLE::client exception - $e');
      disconnect();
    }
  }

  void connect_WUP() async {
    assert(_client != null);
    try {
      print('EXAMPLE::Mosquitto start client connecting....');
      _currentState.setAppConnectionState(MQTTAppConnectionState.connecting);
      updateState();
      await _client.connect();
    } on Exception catch (e) {
      print('EXAMPLE::client exception - $e');
      disconnect();
    }
  }

  void connect_Websocket() async {
    assert(_clientWS != null);
    try {
      print('EXAMPLE::Mosquitto start client connecting....');
      _currentState.setAppConnectionState(MQTTAppConnectionState.connecting);
      updateState();
      await _clientWS.connect(_username, _password);
      print('COnnect to wssssssssssss\n\n\n\n\n----------');
    } on Exception catch (e) {
      print('EXAMPLE::client exception - $e');
      disconnect();
    }
  }

  void connect_Websocket_WUP() async {
    assert(_clientWS != null);
    try {
      print('EXAMPLE::Mosquitto start client connecting....');
      _currentState.setAppConnectionState(MQTTAppConnectionState.connecting);
      updateState();
      await _clientWS.connect();
      print('COnnect to wssssssssssss with user and pass\n\n\n\n\n----------');
    } on Exception catch (e) {
      print('EXAMPLE::client exception - $e');
      disconnect();
    }
  }

  void connect_SSL() async {
    assert(_clientSSL != null);
    //assert(await addSelfSignedCertificate());
    //eventBus.fire(eventBus);
    try {
      print('EXAMPLE::Mosquitto start client connecting....');
      _currentState.setAppConnectionState(MQTTAppConnectionState.connecting);
      updateState();
      await _clientSSL.connect(_username, _password);
      print('COnnect to ssssssssssslllllll\n\n\n\n\n----------');
    } on Exception catch (e) {
      print('EXAMPLE::client exception - $e');
      disconnect();
    }
  }

  void connect_SSL_WUP() async {
    assert(_clientSSL != null);
    //assert(await addSelfSignedCertificate());
    //eventBus.fire(eventBus);
    try {
      print('EXAMPLE::Mosquitto start client connecting....');
      _currentState.setAppConnectionState(MQTTAppConnectionState.connecting);
      updateState();
      await _clientSSL.connect();
      print('COnnect to ssssssssssslllllll\n\n\n\n\n----------');
    } on Exception catch (e) {
      print('EXAMPLE::client exception - $e');
      disconnect();
    }
  }

  void disconnect() {
    if(_client != null && _clientSSL == null && _clientWS == null)
    {
      print('Disconnected from if else');
      _client.disconnect();
      _client = null;
    }
    else if(_clientSSL != null && _client == null && _clientWS == null)
    {
      print('Disconnected from if else ssl');
      _clientSSL.disconnect();
      _clientSSL = null;
    }
    else if(_clientWS != null && _client == null && _clientSSL == null)
    {
      print('Disconnected from if else WS');
      _clientWS.disconnect();
      _clientWS = null;
    }
    else
    {
      print('error');
    }
    //_client.disconnect();
    //_clientWS.disconnect();
    //_clientSSL.disconnect();
  }

  // void publish(String message) {
  //   final MqttClientPayloadBuilder builder = MqttClientPayloadBuilder();
  //   builder.addString(message);
  //   _client.publishMessage(_topic, MqttQos.exactlyOnce, builder.payload);
  // }

  void publish(String message, int _qos, String topic, bool retain) {
    final MqttClientPayloadBuilder builder = MqttClientPayloadBuilder();
    builder.addString(message);
    if (topic.isEmpty) {
      topic = _topic;
    }
    if(_client != null && _clientSSL == null && _clientWS == null)
    {
      print('From nomal port');
      _client.publishMessage(topic, MqttQos.values[_qos], builder.payload,
          retain: retain);
    }
    else if(_clientSSL != null && _client == null && _clientWS == null)
    {
      print('From SSL port');
      _clientSSL.publishMessage(topic, MqttQos.values[_qos], builder.payload,
          retain: retain);
    }
    else if(_clientWS != null && _client == null && _clientSSL == null)
    {
      print('From Socket port');
      _clientWS.publishMessage(topic, MqttQos.values[_qos], builder.payload,
          retain: retain);
    }
    else
    {
      print('error or no coneection');
    }
    /*_client.publishMessage(topic, MqttQos.values[_qos], builder.payload,
        retain: retain);
    _clientSSL.publishMessage(topic, MqttQos.values[_qos], builder.payload,
        retain: retain);
    _clientWS.publishMessage(topic, MqttQos.values[_qos], builder.payload,
        retain: retain);*/
    // _currentState.setReceivedText(message);
    // _currentState.setReceivedOnlyText(message);
  }

  void publishColor(String message, int _qos, String topic, bool retain) {
    final MqttClientPayloadBuilder builder = MqttClientPayloadBuilder();
    builder.addString(message);
    if (topic.isEmpty) {
      topic = _topic;
    }
    if(_client != null && _clientSSL == null && _clientWS == null)
    {
      print('From nomal port');
      _client.publishMessage(topic, MqttQos.values[_qos], builder.payload,
          retain: retain);
    }
    else if(_clientSSL != null && _client == null && _clientWS == null)
    {
      print('From SSL port');
      _clientSSL.publishMessage(topic, MqttQos.values[_qos], builder.payload,
          retain: retain);
    }
    else if(_clientWS != null && _client == null && _clientSSL == null)
    {
      print('From Socket port');
      _clientWS.publishMessage(topic, MqttQos.values[_qos], builder.payload,
          retain: retain);
    }
    else
    {
      print('error');
    }
    /*_client.publishMessage(topic, MqttQos.values[_qos], builder.payload,
        retain: retain);
    _clientSSL.publishMessage(topic, MqttQos.values[_qos], builder.payload,
        retain: retain);
    _clientWS.publishMessage(topic, MqttQos.values[_qos], builder.payload,
        retain: retain);*/
    // _currentState.setReceivedText(message);
    // _currentState.setReceivedOnlyText(message);
    // _currentState.setReceivedOnlyColor(message);
  }

  /// The subscribed callback
  void onSubscribed(String topic) {
    print('EXAMPLE::Subscription confirmed for topic $topic');
    _currentState
        .setAppConnectionState(MQTTAppConnectionState.connectedSubscribed);
    updateState();
  }

  void onUnsubscribed(String topic) {
    print('EXAMPLE::onUnsubscribed confirmed for topic $topic');
    _currentState.clearText();
    _currentState
        .setAppConnectionState(MQTTAppConnectionState.connectedUnSubscribed);
    updateState();
  }

  /// The unsolicited disconnect callback
  void onDisconnected() {
    print('EXAMPLE::OnDisconnected client callback - Client disconnection');
    /*if (_client.connectionStatus.returnCode ==
        MqttConnectReturnCode.noneSpecified) {
      print('EXAMPLE::OnDisconnected on normal callback is solicited, this is correct');
    }
    else if (_clientSSL.connectionStatus.returnCode ==
        MqttConnectReturnCode.noneSpecified) {
      print('EXAMPLE::OnDisconnected on SSL callback is solicited, this is correct');
    }
    else if (_clientWS.connectionStatus.returnCode ==
        MqttConnectReturnCode.noneSpecified) {
      print('EXAMPLE::OnDisconnected on WS callback is solicited, this is correct');
    }*/
    if(_client != null && _clientSSL == null && _clientWS == null) {
      if (_client.connectionStatus.returnCode ==
          MqttConnectReturnCode.noneSpecified) {
        print(
            'EXAMPLE::OnDisconnected on normal callback is solicited, this is correct');
      }
    }

    else if(_clientSSL != null && _client == null && _clientWS == null) {
      if (_clientSSL.connectionStatus.returnCode ==
          MqttConnectReturnCode.noneSpecified) {
        print(
            'EXAMPLE::OnDisconnected on SSL callback is solicited, this is correct');
      }
    }

    else if(_clientWS != null && _client == null && _clientSSL == null) {
      if (_clientWS.connectionStatus.returnCode ==
          MqttConnectReturnCode.noneSpecified) {
        print(
            'EXAMPLE::OnDisconnected on WS callback is solicited, this is correct');
      }
    }

    _currentState.clearText();
    _currentState.setAppConnectionState(MQTTAppConnectionState.disconnected);
    updateState();
  }

  /// The successful connect callback
  void onConnected() {
    _currentState.setAppConnectionState(MQTTAppConnectionState.connected);
    updateState();
    print('EXAMPLE::client connected....');
//    _client.subscribe(_topic, MqttQos.atLeastOnce);
//    _client.updates.listen((List<MqttReceivedMessage<MqttMessage>> c) {
//      final MqttPublishMessage recMess = c[0].payload;
//      final String pt =
//      MqttPublishPayload.bytesToStringAsString(recMess.payload.message);
//      _currentState.setReceivedText(pt);
//      print(
//          'EXAMPLE::Change notification:: topic is <${c[0].topic}>, payload is <-- $pt -->');
//      print('');
//    });
    print(
        'EXAMPLE::OnConnected client callback - Client connection was sucessful');
  }

  void subScribeTo(String topic) {
    // Save topic for future use
    _topic = topic;
    /*_client.subscribe(topic, MqttQos.atLeastOnce);
    _client.updates.listen((List<MqttReceivedMessage<MqttMessage>> c) {
      final MqttPublishMessage recMess = c[0].payload;
      final String pt =
          MqttPublishPayload.bytesToStringAsString(recMess.payload.message);
      _currentState.setReceivedText(pt);
      updateState();
      print(
          'EXAMPLE::Change notification:: topic is <${c[0].topic}>, payload is <-- $pt -->');
      print('');
    });*/
    if(_client != null && _clientSSL == null && _clientWS == null) {
      _client.subscribe(topic, MqttQos.atLeastOnce);
      _client.updates.listen((List<MqttReceivedMessage<MqttMessage>> c) {
        final MqttPublishMessage recMess = c[0].payload;
        final String pt =
        MqttPublishPayload.bytesToStringAsString(recMess.payload.message);
        _currentState.setReceivedText(pt);
        updateState();
        print(
            'EXAMPLE::Change notification:: topic is <${c[0].topic}>, payload is <-- $pt -->');
        print('');
      });
    }

    else if(_clientSSL != null && _client == null && _clientWS == null) {
      _clientSSL.subscribe(topic, MqttQos.atLeastOnce);
      _clientSSL.updates.listen((List<MqttReceivedMessage<MqttMessage>> c) {
        final MqttPublishMessage recMess = c[0].payload;
        final String pt =
        MqttPublishPayload.bytesToStringAsString(recMess.payload.message);
        _currentState.setReceivedText(pt);
        updateState();
        print(
            'EXAMPLE::Change notification:: topic is <${c[0].topic}>, payload is <-- $pt -->');
        print('');
      });
    }

    else if(_clientWS != null && _client == null && _clientSSL == null) {
      _clientWS.subscribe(topic, MqttQos.atLeastOnce);
      _clientWS.updates.listen((List<MqttReceivedMessage<MqttMessage>> c) {
        final MqttPublishMessage recMess = c[0].payload;
        final String pt =
        MqttPublishPayload.bytesToStringAsString(recMess.payload.message);
        _currentState.setReceivedText(pt);
        updateState();
        print(
            'EXAMPLE::Change notification:: topic is <${c[0].topic}>, payload is <-- $pt -->');
        print('');
      });
    }
    else
    {
      print('error');
    }
  }

  /// Unsubscribe from a topic
  void unSubscribe(String topic) {
    //_client.unsubscribe(topic);
    //_clientWS.unsubscribe(topic);
    // _clientSSL.unsubscribe(topic);
    if(_client != null && _clientSSL == null && _clientWS == null)
    {
      print('port nomal');
      _client.unsubscribe(topic);
    }
    else if(_clientSSL != null && _client == null && _clientWS == null)
    {
      print('port SSL');
      _clientSSL.unsubscribe(topic);
    }
    else if(_clientWS != null && _client == null && _clientSSL == null)
    {
      print('port WS');
      _clientWS.unsubscribe(topic);
    }
    else
    {
      print('error');
    }
  }

  /// Unsubscribe from a topic
  void unSubscribeFromCurrentTopic() {
    //_client.unsubscribe(_topic);
    //_clientWS.unsubscribe(_topic);
    //_clientSSL.unsubscribe(_topic);
    if(_client != null && _clientSSL == null && _clientWS == null)
    {
      print('port nomal');
      _client.unsubscribe(_topic);
    }
    else if(_clientSSL != null && _client == null && _clientWS == null)
    {
      print('port SSL');
      _clientSSL.unsubscribe(_topic);
    }
    else if(_clientWS != null && _client == null && _clientSSL == null)
    {
      print('port WS');
      _clientWS.unsubscribe(_topic);
    }
    else
    {
      print('error');
    }
  }

  void updateState() {
    //controller.add(_currentState);
    notifyListeners();
  }

  StreamController _streamController;

  /// Controller for the event bus stream.
  StreamController get streamController => _streamController;

  /// Creates an [EventBus
  ///
  /// If [sync is true, events are passed directly to the stream's listeners
  /// during a [fire call. If false (the default), the event will be passed to
  /// the listeners at a later time, after the code creating the event has
  /// completed.
  MQTTManager({bool sync = false})
      : _streamController = StreamController.broadcast(sync: sync);

  /// Instead of using the default [StreamController you can use this constructor
  /// to pass your own controller.
  ///
  /// An example would be to use an RxDart Subject as the controller.
  MQTTManager.customController(StreamController controller)
      : _streamController = controller;

  /// Listens for events of Type [T and its subtypes.
  ///
  /// The method is called like this: myEventBus.on<MyType>();
  ///
  /// If the method is called without a type parameter, the [Streamcontains every
  /// event of this [EventBus.
  ///
  /// The returned [Stream is a broadcast stream so multiple subscriptions are
  /// allowed.
  ///
  /// Each listener is handled independently, and if they pause, only the pausing
  /// listener is affected. A paused listener will buffer events internally until
  /// unpaused or canceled. So it's usually better to just cancel and later
  /// subscribe again (avoids memory leak).
  ///
  Stream<T> on<T>() {
    if (T == dynamic) {
      return streamController.stream as Stream<T>;
    } else {
      return streamController.stream.where((event) => event is T).cast<T>();
    }
  }

  /// Fires a new event on the event bus with the specified [event.
  ///
  void fire(event) {
    return streamController.add(event);
  }

  /// Destroy this [EventBus. This is generally only in a testing context.
  ///
  void destroy() {
    _streamController.close();
  }
}
// import 'dart:async';

/// Dispatches events to listeners using the Dart [Stream API. The [EventBus
/// enables decoupled applications. It allows objects to interact without
/// requiring to explicitly define listeners and keeping track of them.
///
/// Not all events should be broadcasted through the [EventBus but only those of
/// general interest.
///
/// Events are normal Dart objects. By specifying a class, listeners can
/// filter events.
///
// class EventBus {
//   StreamController _streamController;

//   /// Controller for the event bus stream.
//   StreamController get streamController => _streamController;

//   /// Creates an [EventBus
//   ///
//   /// If [sync is true, events are passed directly to the stream's listeners
//   /// during a [fire call. If false (the default), the event will be passed to
//   /// the listeners at a later time, after the code creating the event has
//   /// completed.
//   EventBus({bool sync = false})
//       : _streamController = StreamController.broadcast(sync: sync);

//   /// Instead of using the default [StreamController you can use this constructor
//   /// to pass your own controller.
//   ///
//   /// An example would be to use an RxDart Subject as the controller.
//   EventBus.customController(StreamController controller)
//       : _streamController = controller;

//   /// Listens for events of Type [T and its subtypes.
//   ///
//   /// The method is called like this: myEventBus.on<MyType>();
//   ///
//   /// If the method is called without a type parameter, the [Streamcontains every
//   /// event of this [EventBus.
//   ///
//   /// The returned [Stream is a broadcast stream so multiple subscriptions are
//   /// allowed.
//   ///
//   /// Each listener is handled independently, and if they pause, only the pausing
//   /// listener is affected. A paused listener will buffer events internally until
//   /// unpaused or canceled. So it's usually better to just cancel and later
//   /// subscribe again (avoids memory leak).
//   ///
//   Stream<T> on<T>() {
//     if (T == dynamic) {
//       return streamController.stream as Stream<T>;
//     } else {
//       return streamController.stream.where((event) => event is T).cast<T>();
//     }
//   }

//   /// Fires a new event on the event bus with the specified [event.
//   ///
//   void fire(event) {
//     return streamController.add(event);
//   }

//   /// Destroy this [EventBus. This is generally only in a testing context.
//   ///
//   void destroy() {
//     _streamController.close();
//   }
// }
