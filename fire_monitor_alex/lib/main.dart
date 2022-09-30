import 'package:fire_monitor_alex/view/home_page.dart';
import 'package:flutter/material.dart';
import 'view/map.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'view/loging.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: const LogInView(),
    );
  }
}
