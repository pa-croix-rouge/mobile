import 'package:flutter/material.dart';
import 'package:pa_mobile/flows/authentication/ui/login_screen.dart';
import 'package:pa_mobile/flows/inscription/ui/register_screen.dart';
import 'package:pa_mobile/shared/widget/xbutton.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const routeName = '/home';

  TextStyle textTitleStyle(Color color) {
    return TextStyle(
      fontSize: 50,
      fontWeight: FontWeight.bold,
      color: color,
    );
  }

  TextStyle textSubTitleStyle() {
    return const TextStyle(
      fontSize: 35,
      fontWeight: FontWeight.bold,
      color: Colors.black,
    );
  }

  TextStyle textDescriptionStyle() {
    return TextStyle(
      fontSize: 15,
      fontWeight: FontWeight.bold,
      color: Colors.black.withOpacity(0.5),
    );
  }

  Widget actionDecorator({required Widget child}) {
    return SafeArea(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: child,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Container(
        color: Colors.white,
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const CircleAvatar(
                      radius: 80,
                      backgroundColor: Colors.black,
                      child: CircleAvatar(
                        radius: 78,
                        backgroundImage: AssetImage('assets/images/drapeau.jpeg'),
                      ),
                    ),
                    Text(
                        'CROIX',
                        style: textTitleStyle(Colors.black)
                    ),
                    Text(
                      'ROUGE',
                      style: textTitleStyle(Colors.redAccent),
                    ),
                    const SizedBox(height: 50),
                    Text(
                      'Bienvenue',
                      style: textSubTitleStyle(),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: 200,
                      child: Text(
                        "Application dédiée aux bénéficiare de l'unité local du Val d'Orge.",
                        textAlign: TextAlign.center,
                        style: textDescriptionStyle(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            actionDecorator(
                child: Row(
                  children: [
                    Expanded(
                      child: XButton(
                        borderRadius: 0,
                        color: Colors.redAccent,
                        onPressed: () => onRegister(context),
                        child: const Text(
                          "S'inscrire",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    Expanded(
                      child: XButton(
                        borderRadius: 0,
                        color: Colors.white,
                        onPressed: () => onConnect(context),
                        child: const Text(
                          'Se connecter',
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ),
                  ],
                ),
            ),
          ],
        ),
      ),
    );
  }

  void onRegister(BuildContext context) {
    Navigator.pushNamed(
      context,
      RegisterScreen.routeName,
    );
  }

  void onConnect(BuildContext context) {
    Navigator.pushNamed(
      context,
      LoginScreen.routeName,
    );
  }
}