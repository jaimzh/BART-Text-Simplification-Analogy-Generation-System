// // bin/test_ws_service.dart

// import 'dart:async';
// import 'dart:convert';
// import 'package:final_year_project/services/ws_service.dart';

// Future<void> main() async {
//   print('▶️ Starting WebSocket test…');

//   final ws = WsService();

//   print('→ Calling ws.connect() with explicit theme = sports');
//   ws.connect(
//     text:  'Consistency and patience win more games than bursts of speed.',
//     level: 'level_1',     // override default if you want
//     model: 'llama3.2',    // override default if you want
//     theme: 'sports',      // force sports theme
//   );
//   print('→ Payload sent, now listening for messages...');

//   final sub = ws.stream.listen(
//     (msg) {
//       final type = msg['type'];
//       if (msg.containsKey('chunk')) {
//         print('[$type] ${msg['chunk']}');
//       } else {
//         print('[$type] $msg');
//       }
//     },
//     onError: (err) => print('❌ Socket error: $err'),
//     onDone:   ()  => print('🔌 WebSocket closed'),
//   );

//   // Keep the script alive long enough to collect all chunks
//   await Future.delayed(const Duration(seconds: 10));

//   print('→ Cancelling subscription and closing socket...');
//   await sub.cancel();
//   ws.disconnect();
//   print('▶️ Test complete.');
// }
