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
        body: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 5,
              ),
              Container(
                padding: const EdgeInsets.all(10),
                child: const Text("eDrawer est une application open source. Vous pouvez visiter le github à l'adresse suivante : "),
              ),
              const SizedBox(
                height: 10,
              ),
              ElevatedButton(
                onPressed: () => _launchURL2(),
                child: const Text('eDrawer GitHub'),
              ),
              const SizedBox(
                height: 15,
              ),
              ElevatedButton(
                onPressed: () => _launchURL(),
                child: const Text('Politique de confidentialité'),
              ),
              const SizedBox(
                height: 55,
              ),
              Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(10),
                child: const Text(
                  "Si vous rencontrez un bug ou que vous voulez faire remonter une ou plusieurs suggestions. Vous pouvez le faire sur le github ou par mail : if.arenz@gmail.com",
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _launchURL() async {
    final Uri uri = Uri(scheme: 'https', host: 'www.github.com', path: 'Arenz2001/eDrawer-privacy/blob/main/privacy-policy.md');
    if (!await launchUrl(
      uri,
      mode: LaunchMode.externalApplication,
    )) {
      throw "Impossible d'aller vers le site";
    }
  }

  Future<void> _launchURL2() async {
    final Uri uri = Uri(scheme: 'https', host: 'www.github.com', path: 'Arenz2001/eDrawer');
    if (!await launchUrl(
      uri,
      mode: LaunchMode.externalApplication,
    )) {
      throw "Impossible d'aller vers le site";
    }
  }
}
