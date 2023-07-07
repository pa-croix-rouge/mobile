import 'package:flutter/material.dart';
import 'package:pa_mobile/core/model/address/address_dto.dart';
import 'package:pa_mobile/core/model/beneficiary/beneficiary_response_dto.dart';
import 'package:pa_mobile/core/model/local_unit/local_unit_response_dto.dart';
import 'package:pa_mobile/flows/account/ui/modify_profile_screen.dart';
import 'package:pa_mobile/flows/event/ui/event_calendar_screen.dart';
import 'package:pa_mobile/flows/account/logic/account.dart';
import 'package:pa_mobile/flows/home/ui/home_screen.dart';
import 'package:pa_mobile/shared/services/storage/jwt_secure_storage.dart';
import 'package:pa_mobile/shared/services/storage/stay_login_secure_storage.dart';
import 'package:pa_mobile/shared/widget/disable_focus_node.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  static const routeName = '/profile';

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  BeneficiaryResponseDto beneficiary = BeneficiaryResponseDto(
    1,
    'loading',
    'loading',
    'loading',
    'loading',
    'loading',
    false,
    0,
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
    Account.getBeneficiaryInfo();
    return Scaffold(
      resizeToAvoidBottomInset: false,
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
    return SingleChildScrollView(
      child: FutureBuilder(
        future: getBeneficiary(),
        builder: (context, AsyncSnapshot<BeneficiaryResponseDto> snapshot) {
          if (snapshot.hasError) {
            JwtSecureStorage().deleteJwtToken();
            StayLoginSecureStorage().notStayLogin();
            Navigator.pushNamedAndRemoveUntil(
              context,
              HomeScreen.routeName,
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
                child: Row(
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(15),
                      child: Icon(Icons.account_circle, size: 80),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 2),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Bonjour',
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 2),
                          child: Text(
                            '${beneficiary.firstName} ${beneficiary.lastName}',
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    RawMaterialButton(
                      onPressed: () async {
                        await Navigator.pushNamed(
                          context,
                          ModifyProfileScreen.routeName,
                          arguments: beneficiary,
                        );
                        setState(() {});
                      },
                      fillColor: Theme.of(context).colorScheme.secondary,
                      padding: const EdgeInsets.all(10),
                      shape: const CircleBorder(),
                      child: const Icon(
                        Icons.edit,
                        size: 20,
                        color: Colors.white,
                      ),
                    ),
                    RawMaterialButton(
                      onPressed: () {
                        JwtSecureStorage().deleteJwtToken();
                        StayLoginSecureStorage().notStayLogin();
                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          HomeScreen.routeName,
                          (route) => false,
                        );
                      },
                      shape: const CircleBorder(),
                      fillColor: Theme.of(context).colorScheme.secondary,
                      padding: const EdgeInsets.all(10.0),
                      child: const Icon(
                        Icons.logout,
                        size: 20,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 30, right: 30),
                child: Column(
                  children: [
                    TextField(
                      decoration: const InputDecoration(
                        icon: Icon(Icons.account_balance_wallet),
                        labelText: 'Solde restant',
                      ),
                      readOnly: true,
                      controller: TextEditingController(
                        text: '${beneficiary.solde/100}€',
                      ),
                      focusNode: AlwaysDisabledFocusNode(),
                    ),
                    TextField(
                      decoration: const InputDecoration(
                        icon: Icon(Icons.email),
                        labelText: 'Email',
                      ),
                      readOnly: true,
                      controller: TextEditingController(
                        text: beneficiary.username,
                      ),
                      focusNode: AlwaysDisabledFocusNode(),
                    ),
                    TextField(
                      decoration: const InputDecoration(
                        icon: Icon(Icons.person),
                        labelText: 'Nom',
                      ),
                      readOnly: true,
                      controller: TextEditingController(
                        text: '${beneficiary.lastName} ${beneficiary.firstName}',
                      ),
                      focusNode: AlwaysDisabledFocusNode(),
                    ),
                    TextField(
                      decoration: const InputDecoration(
                        icon: Icon(Icons.phone),
                        labelText: 'Numéro de téléphone',
                      ),
                      readOnly: true,
                      controller: TextEditingController(
                        text: beneficiary.phoneNumber,
                      ),
                      focusNode: AlwaysDisabledFocusNode(),
                    ),
                    TextField(
                      decoration: const InputDecoration(
                        icon: Icon(Icons.calendar_today),
                        labelText: 'Date de naissance',
                      ),
                      readOnly: true,
                      controller: TextEditingController(
                        text: beneficiary.birthDate,
                      ),
                      focusNode: AlwaysDisabledFocusNode(),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20, bottom: 20),
                child: Divider(
                  color: Theme.of(context).colorScheme.secondary,
                  thickness: 1,
                  indent: 30,
                  endIndent: 30,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 30, right: 30),
                child: Column(
                  children: [
                    TextField(
                      decoration: const InputDecoration(
                        icon: Icon(Icons.account_balance_outlined),
                        labelText: 'Unité locale',
                      ),
                      readOnly: true,
                      controller: TextEditingController(
                        text: localUnit.name,
                      ),
                      focusNode: AlwaysDisabledFocusNode(),
                    ),
                    TextField(
                      decoration: const InputDecoration(
                        icon: Icon(Icons.location_on),
                        labelText: 'Adresse',
                      ),
                      readOnly: true,
                      controller: TextEditingController(
                        text:
                            '${localUnit.address.city}, ${localUnit.address.streetNumberAndName}',
                      ),
                      focusNode: AlwaysDisabledFocusNode(),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
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
    final res = await Future.wait([Account.getBeneficiaryInfo()]);
    final beneficiary = res[0];
    localUnit = await Account.getLocalUnit(beneficiary.localUnitId.toString());
    return beneficiary;
  }
}
