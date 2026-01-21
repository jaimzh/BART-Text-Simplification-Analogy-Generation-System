import 'package:final_year_project/constants/colors.dart';
import 'package:flutter/material.dart';

class SettingsDialog extends StatefulWidget {
  final double initialLevel;
  final String initialTheme;
  final List<String> themes;

  const SettingsDialog({
    Key? key,
    required this.initialLevel,
    required this.initialTheme,
    required this.themes,
  }) : super(key: key);

  @override
  _SettingsDialogState createState() => _SettingsDialogState();
}

class _SettingsDialogState extends State<SettingsDialog> {
  late double _tempLevel;
  late String _tempTheme;

  @override
  void initState() {
    super.initState();
    _tempLevel = widget.initialLevel;
    _tempTheme = widget.initialTheme;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.background,
      title: const Row(
        children: [
          Icon(Icons.settings),
          SizedBox(width: 8),
          Text(
            'Settings',
            style: TextStyle(fontSize: 16, color: AppColors.white),
          ),
        ],
      ),
      content: Container(
        margin: EdgeInsets.only(top: 20),
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Select Level of simplification:',
              textAlign: TextAlign.start,
              style: TextStyle(color: AppColors.white),
            ),
            const SizedBox(height: 20),
            SliderTheme(
              data: SliderTheme.of(context).copyWith(
                trackHeight: 5,
                activeTrackColor: const Color.fromARGB(255, 0, 143, 119),
                inactiveTrackColor:
                    AppColors.darkgrey, // inactive portion color
                thumbColor: AppColors.cyan, // knob color
                overlayColor: Colors.tealAccent.withOpacity(0.2),
                valueIndicatorColor: Colors.tealAccent,
                thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 12),
                overlayShape: const RoundSliderOverlayShape(overlayRadius: 20),
                tickMarkShape: const RoundSliderTickMarkShape(
                  tickMarkRadius: 3,
                ),
                activeTickMarkColor: Colors.tealAccent,
                inactiveTickMarkColor: Colors.white,
              ),
              child: SizedBox(
                width: 300,
                child: Slider(
                  min: 1,
                  max: 3,
                  divisions: 2,
                  value: _tempLevel,
                  label: 'Level ${_tempLevel.round()}',

                  onChanged: (v) => setState(() => _tempLevel = v),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text('Level 1', style: TextStyle(color: AppColors.darkgrey2)),
                  Text('Level 2', style: TextStyle(color: AppColors.darkgrey2)),
                  Text('Level 3', style: TextStyle(color: AppColors.darkgrey2)),
                ],
              ),
            ),

            const SizedBox(height: 50),
            const Text('Select Analogy Theme:'),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.grey[850],
                borderRadius: BorderRadius.circular(8),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  isExpanded: true,
                  value: _tempTheme,
                  dropdownColor: Colors.grey[900],
                  icon: const Icon(
                    Icons.arrow_drop_down,
                    color: Colors.tealAccent,
                  ),
                  style: const TextStyle(
                    color: AppColors.darkgrey2,
                    fontSize: 16,
                  ),
                  items:
                      widget.themes.map((t) {
                        return DropdownMenuItem(value: t, child: Text(t));
                      }).toList(),
                  onChanged: (v) {
                    if (v != null) setState(() => _tempTheme = v);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          style: TextButton.styleFrom(
            // backgroundColor: Colors.grey[700],
            foregroundColor: Colors.white,
          ),
          onPressed: () => Navigator.of(context).pop(null),
          child: const Text('Cancel'),
        ),
        TextButton(
          style: TextButton.styleFrom(
            // backgroundColor: Colors.tealAccent,
            foregroundColor: AppColors.white,
          ),
          onPressed:
              () => Navigator.of(
                context,
              ).pop({'level': _tempLevel, 'theme': _tempTheme}),
          child: const Text('Save'),
        ),
      ],
    );
  }
}
