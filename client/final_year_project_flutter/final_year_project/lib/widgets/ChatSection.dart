import 'package:final_year_project/AiMessageBubble.dart';
import 'package:final_year_project/UserMessageBubble.dart';
import 'package:flutter/material.dart';

class Chatsection extends StatefulWidget {
  final List<Map<String, String>> messages;
  const Chatsection({Key? key, required this.messages}) : super(key: key);

  @override
  _ChatsectionState createState() => _ChatsectionState();
}

class _ChatsectionState extends State<Chatsection> {
  final ScrollController _scrollController = ScrollController();
  late int _prevMessageCount;

  @override
  void initState() {
    super.initState();
    _prevMessageCount = widget.messages.length;
    // Initial scroll to bottom
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
  }

  @override
  void didUpdateWidget(covariant Chatsection oldWidget) {
    super.didUpdateWidget(oldWidget);
    // If message count changed, scroll down
    if (widget.messages.length != _prevMessageCount) {
      _prevMessageCount = widget.messages.length;
      WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
    }
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        controller: _scrollController,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: widget.messages.length,
        itemBuilder: (context, index) {
          final msg = widget.messages[index];
          if (msg['type'] == 'user') {
            return UserMessageBubble(message: msg['content']!);
          }
          return AiMessageBubble(
            simplified: msg['simplified']!,
            analogy: msg['analogy']!,
            level: msg['level']!,
          );
        },
      ),
    );
  }
}
