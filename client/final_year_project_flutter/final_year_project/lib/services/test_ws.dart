import 'dart:convert';
import 'package:web_socket_channel/io.dart';

void main() {
  final channel = IOWebSocketChannel.connect(
    'ws://127.0.0.1:8000/process_chunks_ws',
  );
  channel.sink.add(
    jsonEncode({
      'text': 'Consistency and patience win more games than bursts of speed.',
      'level': 'level_1', // e.g. "level_1", "level_2", "level_3"
      'model': 'llama3.2', // your LLM identifier
      'theme_name': 'classroom',
    }),
  );
  channel.stream.listen((raw) {
    final msg = jsonDecode(raw as String);
    print(msg); // or handle chunked types
  });
}
