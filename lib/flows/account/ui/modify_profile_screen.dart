import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pa_mobile/core/model/beneficiary/beneficiary_response_dto.dart';
import 'package:pa_mobile/flows/event/logic/event.dart';

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
    return FutureBuilder(
      future: loadBeneficiary(),
      builder: (BuildContext context,
          AsyncSnapshot<BeneficiaryResponseDto> snapshot) {
        if (snapshot.hasData) {
          final beneficiary = snapshot.data!;
          return Padding(
            padding: const EdgeInsets.all(20),
            child: Center(
              child: Form(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextFormField(
                      initialValue: beneficiary.firstName,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Prénom',
                      ),
                    ),
                    TextFormField(
                      initialValue: beneficiary.lastName,
                      decoration: const InputDecoration(
                        labelText: 'Nom de famille',
                      ),
                    ),
                    TextFormField(
                      initialValue: beneficiary.phoneNumber,
                      decoration: const InputDecoration(
                        labelText: 'Numéro de téléphone',
                      ),
                    ),
                    TextFormField(
                      initialValue: beneficiary.username,
                      decoration: const InputDecoration(
                        labelText: 'Email',
                      ),
                    ),
                    TextFormField(
                      initialValue: beneficiary.birthDate,
                      decoration: const InputDecoration(
                        labelText: 'Date de naissance',
                      ),
                      onTap: () async {
                        final pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now()
                              .subtract(const Duration(days: 10950)),
                          firstDate: DateTime.now()
                              .subtract(const Duration(days: 36500)),
                          lastDate: DateTime.now()
                              .subtract(const Duration(days: 5840)),
                        );

                        if (pickedDate != null) {
                          print(pickedDate);
                          final formattedDate =
                              DateFormat('yyyy-MM-dd').format(pickedDate);
                          print(formattedDate);
                          setState(() {
                            //dateInput.text = formattedDate;
                          });
                        } else {}
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
        } else if (snapshot.hasError) {
          return const Text('Error');
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Future<BeneficiaryResponseDto> loadBeneficiary() async {
    return EventLogic.getConnectBeneficiary();
  }
}
