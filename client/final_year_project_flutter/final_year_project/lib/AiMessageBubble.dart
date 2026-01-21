import 'dart:ffi';

import 'package:final_year_project/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class AiMessageBubble extends StatelessWidget {
  final String simplified; // Simplified text
  final String analogy;    // Analogy text
  final String level;      // Selected simplification level, e.g. "level_2"

  const AiMessageBubble({
    super.key,
    required this.simplified,
    required this.analogy,
    required this.level,
  });

  @override
  Widget build(BuildContext context) {
    const Radius curve = Radius.circular(30);

    // Extract numeric level for display
    final displayLevel = level.split('_').last;

    return Align(
      alignment: Alignment.centerLeft,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // Star icon
          Column(
            children: [
              SvgPicture.asset('assets/images/star.svg', width: 30),
              const SizedBox(height: 15),
            ],
          ),
          const SizedBox(width: 10),
          Container(
            width: 450,
            padding: const EdgeInsets.all(15),
            margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
            decoration: BoxDecoration(
              color: AppColors.aiBubble,
              borderRadius: const BorderRadius.only(
                topLeft: curve,
                topRight: curve,
                bottomRight: curve,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Simplified section or loading indicator
                AiSimplifyOutput(simplified: simplified),
                const SizedBox(height: 20),
                // Analogy section or loading indicator
                AiAnalogyOutput(analogy: analogy),
                const SizedBox(height: 12),
                // Display dynamic level
                Text(
                  'Level $displayLevel',
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.lightgrey,
                  ),
                  textAlign: TextAlign.start,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class AiSimplifyOutput extends StatelessWidget {
  const AiSimplifyOutput({super.key, required this.simplified});
  final String simplified;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 15),
      decoration: BoxDecoration(
        border: Border(left: BorderSide(color: AppColors.green, width: 4.0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Simplified:',
            style: TextStyle(
              color: AppColors.green,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          if (simplified.isEmpty) ...[
            Row(
              children: [
                const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation(AppColors.green),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  'Loading simplification...',
                  style: TextStyle(color: AppColors.lightgrey),
                ),
              ],
            )
          ] else ...[
            Text(
              simplified,
              style: const TextStyle(fontSize: 14, color: AppColors.white),
            ),
          ],
        ],
      ),
    );
  }
}

class AiAnalogyOutput extends StatelessWidget {
  const AiAnalogyOutput({super.key, required this.analogy});
  final String analogy;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 15),
      decoration: BoxDecoration(
        border: Border(left: BorderSide(color: AppColors.cyan, width: 4.0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Analogy:',
            style: TextStyle(
              color: AppColors.cyan,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          if (analogy.isEmpty) ...[
            Row(
              children: [
                const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation(AppColors.cyan),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  'Loading analogy...',
                  style: TextStyle(color: AppColors.lightgrey),
                ),
              ],
            )
          ] else ...[
            Text(
              analogy,
              style: const TextStyle(fontSize: 14, color: AppColors.white),
            ),
          ],
        ],
      ),
    );
  }
}
