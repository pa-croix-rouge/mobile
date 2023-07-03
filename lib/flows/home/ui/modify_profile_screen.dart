import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ModifyProfileScreen extends StatefulWidget {
  static const routeName = '/modify_profile';

  const ModifyProfileScreen({Key? key}) : super(key: key);

  @override
  State<ModifyProfileScreen> createState() => _ModifyProfileScreenState();
}

class _ModifyProfileScreenState extends State<ModifyProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(
          'Modify Profile',
          style: Theme.of(context).textTheme.headlineLarge,
        ),
      ),
      body: getBody(),
    );
  }

  Widget getBody() {
    return Center(
      child: ElevatedButton(
        onPressed: () {
          Navigator.pop(context);
        },
        child: const Text('Go back!'),
      ),
    );
  }
}
