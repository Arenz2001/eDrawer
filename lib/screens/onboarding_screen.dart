import 'package:edrawer/constants/theme.dart';
import 'package:edrawer/screens/home_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnBoardingPage extends StatefulWidget {
  const OnBoardingPage({Key? key}) : super(key: key);

  @override
  OnBoardingPageState createState() => OnBoardingPageState();
}

class OnBoardingPageState extends State<OnBoardingPage> {
  final introKey = GlobalKey<IntroductionScreenState>();

  void _onIntroEnd(context) {
    onboardLoad();
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const HomePage()),
    );
  }

  Widget _buildFullscreenImage() {
    return Image.asset(
      'assets/onboarding/drawer.png',
      fit: BoxFit.cover,
      height: double.infinity,
      width: double.infinity,
      alignment: Alignment.center,
    );
  }

  Widget _buildImage(String assetName, [double width = 350]) {
    return Image.asset(
      'assets/onboarding/$assetName',
      width: width,
      height: 150,
      //colorBlendMode: BlendMode.darken,
    );
  }

  onboardLoad() async {
    SharedPreferences onBoard = await SharedPreferences.getInstance();
    onBoard.setBool('boolValue', true);
  }

  @override
  Widget build(BuildContext context) {
    const bodyStyle = TextStyle(fontSize: 19.0);

    const pageDecoration = PageDecoration(
      titleTextStyle: TextStyle(color: AppTheme.mainColor, fontWeight: FontWeight.w700, fontSize: 40.0),
      bodyTextStyle: TextStyle(color: AppTheme.mainColor, fontWeight: FontWeight.w200, fontSize: 20.0),
      bodyPadding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
      pageColor: Colors.white,
      imagePadding: EdgeInsets.zero,
    );

    return IntroductionScreen(
      key: introKey,
      globalBackgroundColor: Colors.white,
      allowImplicitScrolling: true,
      autoScrollDuration: 10000,
      /*
      globalHeader: Align(
        alignment: Alignment.topRight,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(top: 16, right: 16),
            child: _buildImage('drawer.png', 100),
          ),
        ),
      ),
    */
      globalFooter: SizedBox(
        width: double.infinity,
        height: 60,
        child: ElevatedButton(
          child: const Text(
            'Passer',
            style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
          ),
          onPressed: () => _onIntroEnd(context),
        ),
      ),

      pages: [
        PageViewModel(
          title: "Présentation",
          body: "Bienvenue sur eDrawer, votre porte-documents numérique. \n\nNous allons faire un petit tour des fonctionnalitées de l'application",
          image: _buildImage('drawer.png'),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "Dossier et document",
          body: "Vous pouvez créer des dossiers pour y ranger des documents. \nChaques dossiers et documents peut être personnalisé par une couleur.",
          image: _buildImage('dossier.png'),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "Ajout de document",
          body: "Il vous suffit de cliquer sur le petit plus en bas à droite de l'écran et le tour est joué.",
          image: _buildImage('add.png'),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "Suppression",
          body: "Pour supprimer une dossier ou un document, rien de plus simple. \n Un simple swipe vers la gauche sur celui-ci et il disparaitra.",
          image: _buildImage('delete.png'),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "À vous de jouer",
          body: "Pour toutes questions supplémentaires, n'hésitez pas à vous rendre dans l'onglet  'À propos'.",
          image: _buildImage('smartphone.png'),
          decoration: pageDecoration,
        ),
      ],
      onDone: () => _onIntroEnd(context),
      //onSkip: () => _onIntroEnd(context), // You can override onSkip callback
      showSkipButton: false,
      skipOrBackFlex: 0,
      nextFlex: 0,
      showBackButton: true,
      //rtl: true, // Display as right-to-left
      back: const Icon(Icons.arrow_back),
      skip: const Text('Passer', style: TextStyle(fontWeight: FontWeight.w600)),
      next: const Icon(Icons.arrow_forward),
      done: const Text('Compris', style: TextStyle(fontWeight: FontWeight.w600)),
      curve: Curves.fastLinearToSlowEaseIn,
      controlsMargin: const EdgeInsets.all(16),
      controlsPadding: kIsWeb ? const EdgeInsets.all(12.0) : const EdgeInsets.fromLTRB(8.0, 4.0, 8.0, 4.0),
      dotsDecorator: const DotsDecorator(
        size: Size(10.0, 10.0),
        color: Color(0xFFBDBDBD),
        activeSize: Size(22.0, 10.0),
        activeColor: Colors.blue,
        activeShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(25.0)),
        ),
      ),
      dotsContainerDecorator: const ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
        ),
      ),
    );
  }
}
