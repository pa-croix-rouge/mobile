import 'package:flutter/material.dart';
import 'package:pa_mobile/core/model/authentication/login_request_dto.dart';
import 'package:pa_mobile/flows/account/ui/account_detail_screen.dart';
import 'package:pa_mobile/flows/authentication/logic/authentication.dart';
import 'package:pa_mobile/flows/inscription/ui/inscription_screen.dart';
import 'package:pa_mobile/flows/event/ui/event_calendar_screen.dart';
import 'package:pa_mobile/flows/home/ui/home_screen.dart';
import 'package:pa_mobile/shared/services/storage/jwt_secure_storage.dart';
import 'package:pa_mobile/shared/services/storage/stay_login_secure_storage.dart';
import 'package:pa_mobile/shared/validators/field_validators.dart';
import 'package:pa_mobile/shared/widget/cr_checkbox.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({super.key});

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
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Row(
          children: [
            Spacer(),
            CircleAvatar(
              radius: 25,
              backgroundColor: Colors.black,
              child: CircleAvatar(
                radius: 23,
                backgroundImage: NetworkImage(
                    'https://www.larousse.fr/encyclopedie/data/images/1009656-Drapeau_de_la_Croix-Rouge.jpg'),
              ),
            ),
            Spacer()
          ],
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            const Spacer(),
            Form(
              key: _loginKey,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Theme(
                  data: Theme.of(context)
                      .copyWith(primaryColor: Colors.redAccent,),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          decoration: const InputDecoration(
                            labelText: 'Email',
                            border: OutlineInputBorder(),
                            icon: Icon(Icons.account_circle),
                            fillColor: Color(0xfff3f3f4),
                            filled: true,
                          ),
                          keyboardType: TextInputType.name,
                          textInputAction: TextInputAction.next,
                          controller: widget.usernameController,
                          validator: FieldValidators.emailValidator,
                          focusNode: _focusNodes[0],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          decoration: const InputDecoration(
                            labelText: 'Mot de passe',
                            icon: Icon(Icons.lock),
                            border: OutlineInputBorder(),
                            fillColor: Color(0xfff3f3f4),
                            filled: true,
                          ),
                          obscureText: true,
                          textInputAction: TextInputAction.done,
                          controller: widget.passwordController,
                          validator: FieldValidators.passwordValidator,
                          focusNode: _focusNodes[1],
                        ),
                      ),
                      ValueListenableBuilder<bool>(
                        valueListenable: keepMeSignedCheckBox,
                        builder: (context, value, _) {
                          return CrCheckBox(
                            text: 'Rester connecté',
                            isChecked: value,
                            onChanged: onCheckBoxChange,
                          );
                        },
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextButton(
                            onPressed: onLoginPressed,
                            child: const Text('Se connecter'),
                          ),
                          const Padding(
                            padding: EdgeInsets.all(10),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pushNamed(
                                context,
                                InscriptionScreen.routeName,
                              );
                            },
                            child: const Text("S'inscrire"),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }

  void onCheckBoxChange(bool? value) {
    if (value != null) {
      keepMeSignedCheckBox
        ..value = value
        ..notifyListeners();
    }
  }

  Future<void> onLoginPressed() async {
    if (_loginKey.currentState!.validate()) {
      try {
        if (await Authentication.login(
          LoginRequestDto(
            username: widget.usernameController.text,
            password: widget.passwordController.text,
          ),
        )) {
          if (keepMeSignedCheckBox.value) {
            await StayLoginSecureStorage().stayLogin();
          } else {
            await StayLoginSecureStorage().notStayLogin();
          }
          await Navigator.of(context)
              .pushNamedAndRemoveUntil(HomeScreen.routeName, (route) => false);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Wrong username and password combination'),
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }

  void onRegisterPressed() {
    Navigator.pushNamed(context, '/register');
  }
}
