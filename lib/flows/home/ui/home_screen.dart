import 'package:flutter/material.dart';
import 'package:pa_mobile/shared/services/jwt_secure_storage.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = '/home';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Account'),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFF13B9FF),
                Color(0xFF2CA2FC),
              ],
            ),
          ),
        )
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            print(await JwtSecureStorage().readJwtToken());
          },
          child: const Text('see token'),
        ),
      ),
    );
  }
}
