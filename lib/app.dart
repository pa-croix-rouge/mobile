import 'package:flutter/material.dart';
import 'package:pa_mobile/flows/authentication/ui/login_screen.dart';
import 'package:pa_mobile/flows/home/ui/home_screen.dart';
import 'package:pa_mobile/l10n/l10n.dart';
import 'package:pa_mobile/shared/services/jwt_secure_storage.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key, required this.isLogged});
  final bool isLogged;

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    final logged = isLogged();
    return MaterialApp(
      theme: ThemeData(
        appBarTheme: const AppBarTheme(color: Color(0xFF13B9FF)),
        colorScheme: ColorScheme.fromSwatch(
          accentColor: const Color(0xFF13B9FF),
        ),
      ),
      debugShowCheckedModeBanner: false,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      initialRoute:
           widget.isLogged ? HomeScreen.routeName : LoginScreen.routeName,
      routes: {
        HomeScreen.routeName: (context) => HomeScreen(),
        LoginScreen.routeName: (context) => LoginScreen(),
      },
    );
  }

  Future<bool> isLogged() async {
    final jwtToken = await JwtSecureStorage().readJwtToken();
    return jwtToken != null;
  }
}
