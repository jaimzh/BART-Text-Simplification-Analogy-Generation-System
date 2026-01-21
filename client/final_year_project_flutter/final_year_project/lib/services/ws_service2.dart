import 'dart:convert';
import 'package:web_socket_channel/io.dart';

class WsService {
  late IOWebSocketChannel _channel;

  /// Kick off the WS connection and send your payload.
  void connect({
    required String text,
    String level      = 'level_2',
    String model      = 'llama3.2',
    String theme      = 'sports',
    String url        = 'ws://127.0.0.1:8000/process_chunks_ws',
  }) {
    // close old socket if it exists
    try { _channel.sink.close(); } catch (_) {}

    _channel = IOWebSocketChannel.connect(Uri.parse(url));

    final payload = {
      'text':       text,
      'level':      level,
      'model':      model,
      'theme_name': theme,
    };
    _channel.sink.add(jsonEncode(payload));
  }

  /// Stream of JSON‐decoded messages from your FastAPI.
  Stream<Map<String, dynamic>> get stream =>
    _channel.stream.map((raw) => jsonDecode(raw as String));

  /// Tear it down.
  void disconnect() => _channel.sink.close();
}
