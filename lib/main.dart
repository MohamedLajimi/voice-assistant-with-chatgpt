import 'package:flutter/material.dart';
import 'package:voice_assistant/core/theme/app_palette.dart';
import 'package:voice_assistant/pages/home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(useMaterial3: true).copyWith(
          scaffoldBackgroundColor: AppPallete.whiteColor,
          appBarTheme:
              const AppBarTheme(backgroundColor: AppPallete.whiteColor)),
      home: const HomePage(),
    );
  }
}
