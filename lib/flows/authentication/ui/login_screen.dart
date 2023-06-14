import 'package:flutter/material.dart';
import 'package:pa_mobile/core/model/authentication/login_request_dto.dart';
import 'package:pa_mobile/flows/authentication/logic/authentication.dart';
import 'package:pa_mobile/shared/sevices/secure_storage.dart';
import 'package:pa_mobile/shared/validators/field_validators.dart';

class LoginScreen extends StatefulWidget {
  static const routeName = '/login';

  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
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
          style: Theme
              .of(context)
              .textTheme
              .headlineSmall,
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            const Spacer(),
            Form(
              key: _loginKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextFormField(
                    decoration: const InputDecoration(
                      hintText: 'Username',
                      icon: Icon(Icons.account_circle),
                      fillColor: Colors.white,
                    ),
                    keyboardType: TextInputType.name,
                    textInputAction: TextInputAction.next,
                    controller: widget.usernameController,
                    validator: FieldValidators.usernameValidator,
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
                      const Padding(
                        padding: EdgeInsets.all(10),
                      ),
                      TextButton(
                        onPressed: () async {print(await SecureStorage().readJwtToken());},
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


  Future<void> onLoginPressed() async {
    if (_loginKey.currentState!.validate()) {
      try {
        if (await Authentication.login(LoginRequestDto(
            username: widget.usernameController.text,
            password: widget.passwordController.text,
          ),)) {
          Navigator.pushNamed(context, '/home');
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Wrong username and password combination'),
              backgroundColor: Theme.of(context)
                  .colorScheme
                  .error,
            ),
          );
        }

      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('server inaccessible'),
            backgroundColor: Theme
                .of(context)
                .colorScheme
                .error,
          ),
        );
      }
    }
  }

  void onRegisterPressed() {
    Navigator.pushNamed(context, '/register');
  }
}
