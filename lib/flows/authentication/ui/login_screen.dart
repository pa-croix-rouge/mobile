import 'package:flutter/material.dart';
import 'package:pa_mobile/shared/validators/field_validators.dart';

class LoginScreen extends StatefulWidget {
  static const routeName = '/login';

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final List<FocusNode> _focusNodes = [
    FocusNode(),
    FocusNode(),
  ];
  ValueNotifier<bool> keepMeSignedCheckBox = ValueNotifier(false);

  final _loginKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Se connecter',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            const Spacer(),
            Form(
              child: Column(
                key: _loginKey,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextFormField(
                    decoration: const InputDecoration(
                      hintText: 'Email',
                      icon: Icon(Icons.email),
                      fillColor: Colors.white,
                    ),
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    controller: widget.emailController,
                    validator: FieldValidators.emailValidator,
                    focusNode: _focusNodes[0],
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                      hintText: 'Mot de passe',
                      icon: Icon(Icons.lock),
                      fillColor: Colors.white,
                    ),
                    obscureText: true,
                    textInputAction: TextInputAction.done,
                    controller: widget.passwordController,
                    validator: FieldValidators.passwordValidator,
                    focusNode: _focusNodes[1],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                        onPressed: onLoginPressed,
                        child: const Text('Se connected'),
                      ),
                      const Padding(
                        padding: EdgeInsets.all(10),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: const Text("S'inscrire"),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }

  void onLoginPressed() {
    _loginKey.currentState!.validate();
    login(emailController.text, passwordController.text);
  }

  void onRegisterPressed() {
    Navigator.pushNamed(context, '/register');
  }

  void login(String email, String password) {

  }
}
