import 'package:flutter/material.dart';
import 'package:pa_mobile/core/model/volonteer/volunteer_response_dto.dart';
import 'package:pa_mobile/flows/authentication/ui/login_screen.dart';
import 'package:pa_mobile/flows/home/logic/home.dart';
import 'package:pa_mobile/shared/services/storage/jwt_secure_storage.dart';
import 'package:pa_mobile/shared/services/storage/stay_login_secure_storage.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = '/home';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<VolunteerResponseDto> volunteerInfo;

  @override
  Widget build(BuildContext context) {
    //faire la requette pour recuperer les infos de l'utilisateur
    //si la requette echoue, on redirige vers la page de login + delete token + delete stay login

    Home.getVolunteerInfo();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Account'),
        leading: IconButton(
          icon: const Icon(Icons.logout),
          onPressed: () async {
            await JwtSecureStorage().deleteJwtToken();
            await StayLoginSecureStorage().notStayLogin();
            await Navigator.of(context).pushNamedAndRemoveUntil(
                LoginScreen.routeName, (route) => false);
          },
        ),
      ),
      body: Center(
        //show volunteer info
        child: FutureBuilder(
          future: volunteerInfo,
          builder: (context, AsyncSnapshot snapshot) {
            if (ConnectionState.active != null && !snapshot.hasData) {
              return const Text("Loading");
            }
          },
        ), /*Column(
          children: [
            Text('ID : ${volunteerInfo.id}'),
            Text('username : ${volunteerInfo.username}'),
            Text('firstName : ${volunteerInfo.firstName}'),
            Text('lastName : ${volunteerInfo.lastName}'),
            Text('phoneNumber : ${volunteerInfo.phoneNumber}'),
            Text('isValidated : ${volunteerInfo.isValidated}'),
            Text('localUnitId : ${volunteerInfo.localUnitId}'),
          ],
        ),*/
      ),
    );
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
