// bin/test_ws_service3.dart

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:final_year_project/services/ws_service.dart';
import 'package:final_year_project/services/ws_service2.dart';

Future<void> main() async {
  print('▶️ Starting WsService test (test3)');

  final ws = WsService();

  // 1) Connect and send your test payload
  ws.connect(
    text:  'Consistency and patience win more games than bursts of speed.',
    level: 'level_1',
    model: 'llama3.2',
    theme: 'sports',
  );
  print('→ Payload sent, listening for chunks...');

  // 2) Subscribe to the stream of messages
  late StreamSubscription<Map<String, dynamic>> sub;
  sub = ws.stream.listen(
    (msg) {
      final type = msg['type'];
      if (msg.containsKey('chunk')) {
        // Word-by-word chunks
        stdout.write(msg['chunk']);
      } else {
        // Non-chunk messages (metadata, start/end, errors)
        print('[$type] $msg');
      }
      // 3) Automatically close when analogy ends
      if (type == 'analogy_end') {
        print('\n→ Analogy complete, closing test...');
        sub.cancel();
        ws.disconnect();
      }
    },
    onError: (e) => print('❌ Socket error: $e'),
    onDone: () => print('\n🔌 WebSocket closed by server'),
  );
}
