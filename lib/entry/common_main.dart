import 'package:danapaniexpress/config/flavor_config.dart';
import 'package:danapaniexpress/data/enums/enums.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Future<void> commonMain() async {


  runApp(const MyApp());
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent, // Status bar color
    statusBarBrightness: Brightness.dark,
    statusBarIconBrightness: Brightness.dark, // Light icons for status bar
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomeTest(),
    );
  }
}


class HomeTest extends StatelessWidget {
  const HomeTest({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flavor Testing'),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.amber,
        child: Center(child: Text('This is Flavor ${AppConfig.flavorName}')),
      ),
    );
  }
}
