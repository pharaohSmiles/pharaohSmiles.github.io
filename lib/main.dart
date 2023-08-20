import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'pages/home_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pyramid Token',
      theme: ThemeData(
        primaryColor: const Color(0xffCD962C),
        backgroundColor: const Color(0xff0D1B28),
        textTheme: GoogleFonts.ebGaramondTextTheme(const TextTheme(
          bodyText2: TextStyle(color: Colors.white, fontSize: 18),
        )),
      ),
      debugShowCheckedModeBanner: false,
      home: const HomePage(0),
    );
  }
}
