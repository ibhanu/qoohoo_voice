import 'package:flutter/material.dart';
import 'package:qoohoo_voice/ui/chat_screen/chat_screen_view.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Qoohoo',
      theme: ThemeData(
        accentColor: Colors.green,
        primaryColor: Colors.green,
        backgroundColor: Color(0xFF0A0D22),
        scaffoldBackgroundColor: Color(0xFF10142F),
        appBarTheme: AppBarTheme(
          color: Colors.black,
          centerTitle: true,
          textTheme: TextTheme(
            headline6: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 30.0,
              color: Colors.green,
            ),
          ),
        ),
        fontFamily: 'SFPro',
      ),
      home: ChatScreenView(),
    );
  }
}
