import 'dart:convert';
import 'dart:io';
import 'package:web_socket_channel/io.dart';

// class WsService {
//   late IOWebSocketChannel _channel;

//   /// Open (or re-open) the WebSocket and immediately send the request payload.
//   void connect({
//     required String text,
//     String level = 'level_2',
//     String model = 'llama3.2',
//     String theme = 'sports',
//   }) {
//     // If there’s an existing open channel, close it first
//     try {
//       _channel.sink.close();
//     } catch (_) {}

//     _channel = IOWebSocketChannel.connect(
//       Uri.parse('ws://127.0.0.1:8000/process_chunks_ws'),
//     );

//     // Build and send your JSON payload
//     final payload = {
//       'text': text,
//       'level': level,
//       'model': model,
//       'theme_name': theme,
//     };
//     _channel.sink.add(jsonEncode(payload));
//   }

//   /// Stream of parsed JSON messages coming back from the server.
//   Stream<Map<String, dynamic>> get stream =>
//       _channel.stream.map((raw) => jsonDecode(raw as String));

//   /// Gracefully close the WebSocket.
//   void disconnect() => _channel.sink.close();
// }

//this is my code 
void main() async {
  final channel = IOWebSocketChannel.connect(
    Uri.parse('ws://127.0.0.1:8000/process_chunks_ws'),
  );

  // Send just the text—defaults will apply
  channel.sink.add(
    jsonEncode({
      'text': 'Consistency and patience win more games than bursts of speed.',
    }),
  );

  // Listen to all streamed messages
  channel.stream.listen(
    (raw) {
      final msg = jsonDecode(raw as String) as Map<String, dynamic>;
      switch (msg['type']) {
        case 'metadata':
          print('BART output: ${msg['bart_output']}');
          break;
        case 'simplification_chunk':
          stdout.write(msg['chunk']);
          break;
        case 'analogy_metadata':
          print('\nFeasibility score: ${msg['feasibility_score']}');
          break;
        case 'analogy_chunk':
          stdout.write(msg['chunk']);
          break;
        case 'analogy_error':
          print('\nError: ${msg['message']}');
          break;
      }
    },
    onDone: () {
      print('\nWebSocket closed');
    },
  );
}
