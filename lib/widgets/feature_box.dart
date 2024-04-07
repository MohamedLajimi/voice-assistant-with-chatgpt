import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:voice_assistant/core/theme/app_palette.dart';

class FeatureBox extends StatelessWidget {
  final Color color;
  final String headerText;
  final String descriptionText;
  const FeatureBox(
      {required this.headerText,
      required this.descriptionText,
      required this.color,
      super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 35, vertical: 10),
      decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(15)),
          color: color),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20).copyWith(left: 15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                headerText,
                style: const TextStyle(
                    fontFamily: 'Cera Pro',
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppPallete.blackColor),
              ),
            ),
            const SizedBox(
              height: 3,
            ),
            Padding(
              padding: const EdgeInsets.only(right: 20.0),
              child: Text(
                descriptionText,
                style: const TextStyle(
                    fontFamily: 'Cera Pro',
                    fontSize: 14,
                    color: AppPallete.blackColor),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
