import 'package:flutter/material.dart';
import 'page_first.dart';
import 'page_second.dart';
import 'page_third.dart';
import 'components/bottom_nav.dart';
import 'package:flutter/services.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int pageIndex = 0;
  final pages = [
    const PageFirst(),
    PageSecond(),
    PageThird(),
  ];

  void myCustomCallback(int nextPage) {
    setState(() {
      print('Hola this is Alex');
      pageIndex = nextPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      systemStatusBarContrastEnforced: false,
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarDividerColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.dark,
      statusBarColor: Colors.transparent,
      statusBarBrightness: Brightness.dark,
      statusBarIconBrightness: Brightness.dark,
    ));

    //Setting SystmeUIMode
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge,
        overlays: [SystemUiOverlay.top]);

    return Scaffold(
      extendBody: true,
      body: pages[pageIndex],
      bottomNavigationBar: BottomNavBar(
        pageIndex: pageIndex,
        changePageCallback: myCustomCallback,
      ),
    );
  }
}
