import 'package:final_year_project/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Searchbox extends StatefulWidget {
  final Function(String) onSend;
  final VoidCallback onSettings;
  const Searchbox({super.key, required this.onSend, required this.onSettings});

  @override
  State<Searchbox> createState() => _SearchboxState();
}

class _SearchboxState extends State<Searchbox> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void dispose() {
    // TODO: implement dispose

    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _handleSend() {
    final text = _controller.text.trim();
    if (text.isNotEmpty) {
      widget.onSend(text);
      _controller.clear();
      _focusNode.requestFocus(); // Re-focus after sending
    }
  }

  Future<void> _pasteText() async {
    final data = await Clipboard.getData(Clipboard.kTextPlain);
    final text = data?.text ?? '';
    if (text.isNotEmpty) {
      _controller.text = text;
      _controller.selection = TextSelection.fromPosition(
        TextPosition(offset: _controller.text.length),
      );
      _focusNode.requestFocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 20.0),
        padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
        constraints: BoxConstraints(maxWidth: 830),
        decoration: BoxDecoration(
          color: Colors.grey[900],
          borderRadius: BorderRadius.circular(25),
          border: Border.all(color: AppColors.darkgrey), // Border color
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 30),
              child: TextField(
                focusNode: _focusNode,
                controller: _controller,
                style: TextStyle(
                  color: AppColors.white,
                  fontSize: 14,
                ), // Text color
                decoration: InputDecoration(
                  hintText:
                      'Input complex text to generate a simplification and analogy...',
                  hintStyle: TextStyle(
                    color: AppColors.darkgrey,
                  ), // Hint text color
                  border: InputBorder.none,
                ),

                minLines: 1,
                maxLines: 4,
                textInputAction: TextInputAction.send,
                onSubmitted: (_) => _handleSend(),
              ),
            ),
            SizedBox(height: 5),
            Row(
              children: [
                // Paste button
                TextButton.icon(
                  onPressed: _pasteText,
                  icon: Icon(Icons.paste, color: AppColors.white),
                  label: Text(
                    'Paste',
                    style: TextStyle(color: AppColors.white),
                  ),
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 12),
                  ),
                ),

                Spacer(),
                TextButton.icon(
                  onPressed: widget.onSettings,
                  icon: Icon(Icons.settings, color: AppColors.white),
                  label: Text(
                    'Settings',
                    style: TextStyle(color: AppColors.white),
                  ),
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 12),
                  ),
                ),

                // Send button
                TextButton.icon(
                  onPressed: () {
                    final text = _controller.text.trim();
                    if (text.isNotEmpty) {
                      widget.onSend(text);
                      _controller.clear();
                    }
                  },
                  icon: Icon(Icons.send, color: AppColors.white),
                  label: Text('Send', style: TextStyle(color: AppColors.white)),
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 12),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
