// lib/screens/HomePage.dart

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:final_year_project/widgets/ChatSection.dart';
import 'package:final_year_project/widgets/SearchBox.dart';
import 'package:final_year_project/widgets/SettingsDialog.dart';
import 'package:final_year_project/widgets/TitleSection.dart';
import 'package:final_year_project/services/ws_service2.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final WsService _wsService = WsService();
  StreamSubscription<Map<String, dynamic>>? _wsSub;

  final List<Map<String, String>> _messages = [];
  bool _hasSentMessage = false;
  double _level = 2;
  String _theme = 'sports';
  final List<String> _themes = ['sports', 'classroom', 'movies', 'anime'];

  @override
  void dispose() {
    _wsSub?.cancel();
    _wsService.disconnect();
    super.dispose();
  }

  Future<void> _openSettingsDialog() async {
    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (_) => SettingsDialog(
        initialLevel: _level,
        initialTheme: _theme,
        themes: _themes,
      ),
    );
    if (result != null) {
      setState(() {
        _level = result['level'];
        _theme = result['theme'];
      });
    }
  }

  void _handleSend(String text) {
    if (text.trim().isEmpty) return;

    // 1) Immediately add user message
    // 2) Immediately add placeholder AI message (empty fields → loading spinners)
    final levelStr = 'level_${_level.toInt()}';
    setState(() {
      _hasSentMessage = true;
      _messages.add({
        'type': 'user',
        'content': text,
      });
      _messages.add({
        'type':       'ai',
        'simplified': '',
        'analogy':    '',
        'level':      levelStr,   // carry the selected level
      });
    });

    // 3) Connect via WebSocket with chosen level & theme
    _wsService.connect(
      text:  text,
      level: levelStr,
      model: 'llama3.2',
      theme: _theme.toLowerCase(),
    );

    // 4) Subscribe to incoming chunks and fill placeholder
    _wsSub?.cancel();
    _wsSub = _wsService.stream.listen((msg) {
      final type = msg['type'];
      final chunk = msg.containsKey('chunk') ? msg['chunk'] as String : null;

      if (type == 'simplification_chunk' && chunk != null) {
        setState(() {
          final slot = _messages.last;
          slot['simplified'] = slot['simplified']! + chunk;
        });
      }
      else if ((type == 'analogy_chunk' || type == 'analogy') && chunk != null) {
        setState(() {
          final slot = _messages.last;
          slot['analogy'] = slot['analogy']! + chunk;
        });
      }
      // other control messages can be ignored or used for status
    }, onError: (e) {
      print('❌ WS error: $e');
    }, onDone: () {
      print('🔌 WS closed');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                setState(() {
                  _hasSentMessage = false;
                  _messages.clear();
                });
              },
            ),

            if (!_hasSentMessage)
              const Titlesection()
            else
              Chatsection(messages: _messages),

            Searchbox(
              onSend:     _handleSend,
              onSettings: _openSettingsDialog,
            ),
          ],
        ),
      ),
    );
  }
}
