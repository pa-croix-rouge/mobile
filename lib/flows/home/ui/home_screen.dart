import 'package:flutter/material.dart';
import 'package:pa_mobile/shared/sevices/secure_storage.dart';

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
        title: Text('WELCOME'),
      ),
      body: Center(
        // button to logout
        child: ElevatedButton(
          onPressed: () async {
            print(await SecureStorage().readJwtToken());
          },
          child: Text('see token'),
        ),
      ),
    );
  }
}