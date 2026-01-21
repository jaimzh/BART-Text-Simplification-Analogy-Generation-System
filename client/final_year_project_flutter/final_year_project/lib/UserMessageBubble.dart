import 'package:final_year_project/constants/colors.dart';
import 'package:flutter/material.dart';

class UserMessageBubble extends StatelessWidget {
  final String message;
  const UserMessageBubble({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    const Radius curve = Radius.circular(30);
    return Align(
      alignment: Alignment.centerRight,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
            width: 300,
            padding: const EdgeInsets.all(15),
            margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
            decoration: BoxDecoration(
              color: AppColors.userBubble,
              borderRadius: BorderRadius.only(
                topLeft: curve,
                topRight: curve,
                bottomLeft: curve,
              ),
            ),
            child: Text(
              message,
              style: const TextStyle(color: AppColors.userText),
            ),
          ),
          Column(children: [Icon(Icons.account_circle), SizedBox(height: 15)]),
        ],
      ),
    );
  }
}
