import 'package:flutter/material.dart';
import 'package:myappflutter/components/forget_password.dart';
import 'package:myappflutter/components/image_send.dart';
import 'package:myappflutter/components/login.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'FloralAI',
      theme: ThemeData(
        colorScheme:
            ColorScheme.fromSwatch().copyWith(secondary: Colors.deepPurple),
      ),
      home: const MyHomePage(title: ''),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  _MyHomePageState();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Login(), // Remove the extra positional argument
    );
  }
}
