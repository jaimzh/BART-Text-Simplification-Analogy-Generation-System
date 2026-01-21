import 'package:final_year_project/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';

class Titlesection extends StatelessWidget {
  const Titlesection({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('From complexity to ', style: TextStyle(fontSize: 40)),
                GradientText(
                  'clarity',
                  style: TextStyle(fontSize: 40),
                  colors: [AppColors.cyan, AppColors.green],
                ),
                SvgPicture.asset('assets/images/star.svg'),
              ],
            ),
            SizedBox(height: 50),
            SvgPicture.asset('assets/images/image.svg', width: 600),
            // Text(
            //   'Simply Copy and paste text below to get started.',
            //   style: TextStyle(
            //     fontSize: 16,
            //     color: const Color.fromARGB(136, 255, 255, 255),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
