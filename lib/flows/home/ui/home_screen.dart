import 'package:flutter/material.dart';
import 'package:pa_mobile/core/model/address/address_dto.dart';
import 'package:pa_mobile/core/model/beneficiary/beneficiary_response_dto.dart';
import 'package:pa_mobile/core/model/local_unit/local_unit_response_dto.dart';
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
  BeneficiaryResponseDto beneficiary = BeneficiaryResponseDto(
    1,
    'loading',
    'loading',
    'loading',
    'loading',
    'loading',
    false,
    0,
  );

  LocalUnitResponseDTO localUnit = LocalUnitResponseDTO(
    0,
    'loading',
    AddressDTO(
      'loading',
      'loading',
      'loading',
      'loading',
    ),
    'loading',
    'loading',
  );

  int _screenIndex = 1;
  String title = 'Profile';

  @override
  Widget build(BuildContext context) {
    Home.getBeneficiaryInfo();
    return Scaffold(
      resizeToAvoidBottomInset : false,
      appBar: AppBar(
        title: Text(
          title,
          style: Theme.of(context).textTheme.headlineLarge,
        ),
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
      return getProfile();
    } else {
      return const Text('Error');
    }
  }

  Widget getProfile() {
    return Column(
      children: [
        FutureBuilder(
          future: getBeneficiary(),
          builder: (context, AsyncSnapshot<BeneficiaryResponseDto> snapshot) {
            if (snapshot.hasError) {
              JwtSecureStorage().deleteJwtToken();
              StayLoginSecureStorage().notStayLogin();
              Navigator.pushNamedAndRemoveUntil(
                context,
                LoginScreen.routeName,
                (route) => false,
              );
            }
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }
            beneficiary = snapshot.data!;
            return Column(
              children: [
                Container(
                  margin: const EdgeInsets.all(10),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.secondary,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.account_tree),
                          const SizedBox(width: 10),
                          Text(
                            beneficiary.username,
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          const Icon(Icons.person),
                          const SizedBox(width: 10),
                          Text(
                            '${beneficiary.firstName} ${beneficiary.lastName}',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          const Icon(Icons.phone),
                          const SizedBox(width: 10),
                          Text(
                            beneficiary.phoneNumber,
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          const Icon(Icons.home),
                          const SizedBox(width: 10),
                          Text(
                            beneficiary.birthDate,
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          const Icon(Icons.home),
                          const SizedBox(width: 10),
                          Text(
                            localUnit.name,
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          const Icon(Icons.home),
                          const SizedBox(width: 10),
                          Text(
                            localUnit.address.city,
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                //modify profile button
              ],
            );
          },
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.pushNamed(context, '/modify_profile');
          },
          child: Text(
            'Modifier le profile',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ),
        ElevatedButton(
          onPressed: () {
            JwtSecureStorage().deleteJwtToken();
            StayLoginSecureStorage().notStayLogin();
            Navigator.pushNamedAndRemoveUntil(
              context,
              LoginScreen.routeName,
                  (route) => false,
            );
          },
          child: Text(
            'Se deconnecter',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ),
      ],
    );
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
    super.initState();
  }

  Future<BeneficiaryResponseDto> getBeneficiary() async {
    final res = await Future.wait([Home.getBeneficiaryInfo()]);
    final beneficiary = res[0];
    localUnit = await Home.getLocalUnit(beneficiary.localUnitId.toString());
    return beneficiary;
  }
}
