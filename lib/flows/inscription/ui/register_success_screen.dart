import 'package:flutter/material.dart';
import 'package:pa_mobile/flows/home/ui/home_screen.dart';
import 'package:pa_mobile/shared/widget/xbutton.dart';

class RegisterSuccessScreen extends StatelessWidget {
  const RegisterSuccessScreen({super.key});

  static const routeName = '/register-success';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.check_circle_outline_outlined,
            color: Colors.green,
            size: 150,
          ),
          const SizedBox(height: 50),
          const Text(
            'Votre compte a été créé avec succès.',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 60),
          const Text(
            'Veuillez consulter vos mails pour confirmer votre adresse email.',
            style: TextStyle(
              fontSize: 18,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 50),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            child: XButton(
              child: const Text('Se connecter'),
              onPressed: () {
                Navigator.of(context).pushNamedAndRemoveUntil(
                  HomeScreen.routeName,
                  (route) => false,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
