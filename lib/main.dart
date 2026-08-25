import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:wrant/widget_tree.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final dir = await getApplicationDocumentsDirectory();
  Hive.defaultDirectory = dir.path;

  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    systemNavigationBarColor: Colors.transparent, // Required for Edge-to-Edge
    systemNavigationBarIconBrightness: Brightness.dark, // Adjust for light/dark theme
    systemNavigationBarContrastEnforced: false, // Prevents Android from adding a grey tint
  ));

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: WidgetTree(),
      theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.pink.shade500)),
    );
  }
}