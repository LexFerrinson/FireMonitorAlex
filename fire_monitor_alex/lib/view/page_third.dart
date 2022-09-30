import 'dart:ffi';
import 'dart:typed_data';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';

class PageThird extends StatefulWidget {
  const PageThird({Key? key}) : super(key: key);

  @override
  State<PageThird> createState() => _PageThirdState();
}

class _PageThirdState extends State<PageThird> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Text('Acknowledges', style: TextStyle(fontSize: 35)),
        const SizedBox(
          height: 30,
        ),
        const Text(
          'App fully developed by Alex Ferré Janer',
          style: TextStyle(fontStyle: FontStyle.italic),
        ),
        const SizedBox(
          height: 5,
        ),
        const Text(
          '2022, Barcelona, Spain',
          style: TextStyle(fontStyle: FontStyle.italic),
        ),
        const SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/git.png',
              height: 20,
              width: 20,
              fit: BoxFit.fitWidth,
            ),
            TextButton(
              onPressed: (() async {
                final uri = Uri.parse("https://github.com/LexFerrinson");
                if (await canLaunchUrl(uri)) {
                  await launchUrl(uri, mode: LaunchMode.externalApplication);
                } else {
                  // can't launch url
                }
              }),
              child: const Text('@LexFerrinson'),
            ),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/linkedin.png',
              height: 20,
              width: 20,
              fit: BoxFit.fitWidth,
            ),
            TextButton(
              onPressed: (() async {
                final uri =
                    Uri.parse("https://www.linkedin.com/in/alexferrejaner/");
                if (await canLaunchUrl(uri)) {
                  await launchUrl(uri, mode: LaunchMode.externalApplication);
                } else {
                  // can't launch url
                }
              }),
              child: const Text('@alexferrejaner'),
            ),
          ],
        ),
      ],
    );
  }
}
