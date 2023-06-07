import 'package:flutter/material.dart';

class LogoutScreen extends StatefulWidget {
  static const routeName = '/logout';

  @override
  State<LogoutScreen> createState() => _LogoutScreenState();
}

class _LogoutScreenState extends State<LogoutScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Logout')),
      body: Center(child: Text('Logout')),
    );
  }
}
