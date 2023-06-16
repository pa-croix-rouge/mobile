import 'package:flutter/material.dart';
import 'package:pa_mobile/core/model/volonteer/volunteer_response_dto.dart';
import 'package:pa_mobile/flows/authentication/ui/login_screen.dart';
import 'package:pa_mobile/flows/event/ui/event_calendar_screen.dart';
import 'package:pa_mobile/flows/home/logic/home.dart';
import 'package:pa_mobile/shared/services/storage/jwt_secure_storage.dart';
import 'package:pa_mobile/shared/services/storage/stay_login_secure_storage.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  static const routeName = '/home';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<VolunteerResponseDto> volunteerInfo;

  int _screenIndex = 1;
  String title = "Profile";

  @override
  Widget build(BuildContext context) {
    //faire la requette pour recuperer les infos de l'utilisateur
    //si la requette echoue, on redirige vers la page de login + delete token + delete stay login

    Home.getVolunteerInfo();

    return Scaffold(
      appBar: AppBar(
        title: Text(title,
            style: Theme.of(context).textTheme.headlineLarge,),
      ),
      body: getBody(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _screenIndex,
        onTap: _onNavigationChanged,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Theme.of(context).colorScheme.tertiary,
        unselectedItemColor: Theme.of(context).colorScheme.secondary,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month),
            label: 'Evenements',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  Widget getBody() {
    if (_screenIndex == 0) {
      return const EventScreen();
    } else if (_screenIndex == 1) {
      return const Text('Not implemented yet');
    } else {
      return const Text('Error');
    }
  }

  void _onNavigationChanged(int index) {
    setState(() {
      _screenIndex = index;
      if (_screenIndex == 0) {
        title = 'Evenements';
      } else if (_screenIndex == 1) {
        title = 'Profile';
      } else {
        title = 'Error';
      }
    });
  }

  @override
  void initState() {
    getVolunteer();
    super.initState();
  }

  Future<void> getVolunteer() async {
    volunteerInfo = Home.getVolunteerInfo();
  }
}
