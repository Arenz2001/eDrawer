import 'package:flutter/material.dart';
import 'package:edrawer/screens/home_screen.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutUsPage extends StatelessWidget {
  const AboutUsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pop(
          MaterialPageRoute(builder: (context) => const HomePage()),
        );
        return Future.value(true);
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            "eDrawer - À propos",
            style: TextStyle(fontSize: 17),
          ),
          centerTitle: true,
          elevation: 0,
          automaticallyImplyLeading: false,
          leading: IconButton(
            onPressed: () async {
              Navigator.of(context).pop(
                MaterialPageRoute(builder: (context) => const HomePage()),
              );
              return Future.value(true);
            },
            icon: const Icon(Icons.arrow_back),
          ),
        ),
        body: Column(
          children: [
            const SizedBox(
              height: 5,
            ),
            ElevatedButton(
              onPressed: _launchURL,
              child: const Text('Politique de confidentialité'),
            )
          ],
        ),
      ),
    );
  }

  _launchURL() async {
    const url = 'https://github.com/Arenz2001/eDrawer-privacy/blob/main/privacy-policy.md';
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Could not launch $url';
    }
  }
}
