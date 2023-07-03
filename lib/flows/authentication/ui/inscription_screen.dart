import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:pa_mobile/core/model/authentication/beneficiary_creation_request.dart';
import 'package:pa_mobile/core/model/authentication/family_member_creation_request.dart';
import 'package:pa_mobile/core/model/local_unit/local_unit_response_dto.dart';
import 'package:pa_mobile/flows/authentication/logic/register.dart';
import 'package:pa_mobile/shared/validators/field_validators.dart';

class InscriptionScreen extends StatefulWidget {
  const InscriptionScreen({super.key});

  static const routeName = '/register';

  @override
  State<InscriptionScreen> createState() => _InscriptionScreenState();
}

class _InscriptionScreenState extends State<InscriptionScreen> {
  List<FamilyMemberCreationRequest> familyMembers = [];

  final _registerKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController socialWorkerNumberController = TextEditingController();
  String localUnitCode = '';
  TextEditingController dateInput = TextEditingController();
  TextEditingController alertFirstName = TextEditingController();
  TextEditingController alertLastName = TextEditingController();
  TextEditingController alertBirthDate = TextEditingController();
  final List<FocusNode> _focusNodes = [
    FocusNode(),
    FocusNode(),
    FocusNode(),
    FocusNode(),
    FocusNode(),
    FocusNode(),
    FocusNode(),
    FocusNode(),
    FocusNode(),
  ];

  @override
  void initState() {
    super.initState();
    dateInput.text = DateFormat('yyyy-MM-dd').format(
      DateTime.now().subtract(const Duration(days: 10950)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Inscription'),
      ),
      body: SafeArea(
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          body: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Form(
                key: _registerKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextFormField(
                      decoration: const InputDecoration(
                        hintText: 'Email',
                        icon: Icon(Icons.account_circle),
                        fillColor: Colors.white,
                      ),
                      keyboardType: TextInputType.name,
                      textInputAction: TextInputAction.next,
                      controller: emailController,
                      validator: FieldValidators.emailValidator,
                      focusNode: _focusNodes[0],
                    ),
                    TextFormField(
                      decoration: const InputDecoration(
                        hintText: 'Mot de passe',
                        icon: Icon(Icons.lock),
                        fillColor: Colors.white,
                      ),
                      keyboardType: TextInputType.visiblePassword,
                      textInputAction: TextInputAction.next,
                      controller: passwordController,
                      validator: FieldValidators.passwordValidator,
                      focusNode: _focusNodes[1],
                    ),
                    TextFormField(
                      decoration: const InputDecoration(
                        hintText: 'Confirmer le mot de passe',
                        icon: Icon(Icons.lock),
                        fillColor: Colors.white,
                      ),
                      keyboardType: TextInputType.visiblePassword,
                      textInputAction: TextInputAction.next,
                      controller: confirmPasswordController,
                      validator: (value) {
                        if (value != passwordController.text) {
                          return 'Les mots de passe ne correspondent pas';
                        }
                        return null;
                      },
                      focusNode: _focusNodes[2],
                    ),
                    TextFormField(
                      decoration: const InputDecoration(
                        hintText: 'Prénom',
                        icon: Icon(Icons.account_circle),
                        fillColor: Colors.white,
                      ),
                      keyboardType: TextInputType.name,
                      controller: firstNameController,
                      textInputAction: TextInputAction.next,
                      validator: FieldValidators.nameValidator,
                      focusNode: _focusNodes[3],
                    ),
                    TextFormField(
                      decoration: const InputDecoration(
                        hintText: 'Nom',
                        icon: Icon(Icons.account_circle),
                        fillColor: Colors.white,
                      ),
                      keyboardType: TextInputType.name,
                      textInputAction: TextInputAction.next,
                      controller: lastNameController,
                      validator: FieldValidators.nameValidator,
                      focusNode: _focusNodes[4],
                    ),
                    TextFormField(
                      decoration: const InputDecoration(
                        hintText: 'Numéro de téléphone',
                        icon: Icon(Icons.phone),
                        fillColor: Colors.white,
                      ),
                      keyboardType: TextInputType.phone,
                      textInputAction: TextInputAction.next,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(10),
                      ],
                      validator: FieldValidators.phoneNumberValidator,
                      focusNode: _focusNodes[5],
                    ),
                    TextFormField(
                      controller: dateInput,
                      decoration: const InputDecoration(
                        icon: Icon(Icons.calendar_today),
                        labelText: 'Enter Date',
                      ),
                      readOnly: true,
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
                            dateInput.text = formattedDate;
                          });
                        } else {}
                      },
                      focusNode: _focusNodes[6],
                    ),
                    FutureBuilder(
                      future: Register.loadLocalUnit(),
                      builder: (BuildContext context,
                          AsyncSnapshot<List<LocalUnitResponseDTO>> snapshot) {
                        if (snapshot.hasError) {
                          return const Text(
                              'Impossible de charger les unités locales');
                        }
                        if (snapshot.hasData) {
                          return DropdownButtonFormField(
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Veuillez sélectionner une unité locale';
                              }
                              return null;
                            },
                            decoration: const InputDecoration(
                              icon: Icon(Icons.home),
                              labelText: 'Unité locale',
                            ),
                            items: snapshot.data!
                                .map((LocalUnitResponseDTO localUnit) {
                              return DropdownMenuItem(
                                value:
                                    utf8.decode(localUnit.code.runes.toList()),
                                child: Text(
                                    utf8.decode(localUnit.name.runes.toList())),
                              );
                            }).toList(),
                            onChanged: (String? value) {
                              setState(() {
                                print('value: $value');
                              });
                            },
                            focusNode: _focusNodes[7],
                          );
                        } else {
                          return const CircularProgressIndicator();
                        }
                      },
                    ),
                    TextFormField(
                      decoration: const InputDecoration(
                        hintText: 'Numéro de travailleur social',
                        icon: Icon(Icons.work),
                        fillColor: Colors.white,
                      ),
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.next,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(15),
                      ],
                      controller: socialWorkerNumberController,
                      validator: FieldValidators.socialWorkerNumberValidator,
                      focusNode: _focusNodes[8],
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: () async {
                            final familyMember = await openDialogFamily();
                            if (familyMember != null) {
                              setState(() {
                                familyMembers.add(familyMember);
                              });
                            }
                          },
                          child: const Text('Ajouter un membre de famille'),
                        ),
                        const SizedBox(width: 10),
                        //see family members button
                        ElevatedButton(
                          onPressed: () async {
                            await openDialogFamilyMembers();
                            setState(() {});
                          },
                          child: Text('Famille (${familyMembers.length})'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: onRegister,
                child: const Text('S\'inscrire'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<FamilyMemberCreationRequest?> openDialogFamily() =>
      showDialog<FamilyMemberCreationRequest>(
        context: context,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text('Ajouter un membre de la famille'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                decoration: const InputDecoration(
                  hintText: 'Prénom',
                  icon: Icon(Icons.account_circle),
                  fillColor: Colors.white,
                ),
                keyboardType: TextInputType.name,
                textInputAction: TextInputAction.next,
                validator: FieldValidators.nameValidator,
                controller: alertFirstName,
              ),
              TextFormField(
                decoration: const InputDecoration(
                  hintText: 'Nom',
                  icon: Icon(Icons.account_circle),
                  fillColor: Colors.white,
                ),
                keyboardType: TextInputType.name,
                textInputAction: TextInputAction.next,
                validator: FieldValidators.nameValidator,
                controller: alertLastName,
              ),
              TextFormField(
                controller: alertBirthDate,
                decoration: const InputDecoration(
                  icon: Icon(Icons.calendar_today),
                  labelText: 'Enter Date',
                ),
                readOnly: true,
                onTap: () async {
                  final pickedDate = await showDatePicker(
                    context: context,
                    initialDate:
                        DateTime.now().subtract(const Duration(days: 10950)),
                    firstDate:
                        DateTime.now().subtract(const Duration(days: 36500)),
                    lastDate: DateTime.now(),
                  );
                  if (pickedDate != null) {
                    final formattedDate =
                        DateFormat('yyyy-MM-dd').format(pickedDate);
                    setState(() {
                      alertBirthDate.text = formattedDate;
                    });
                  } else {}
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: submit,
              child: const Text('Add'),
            ),
          ],
        ),
      );

  Future<void> openDialogFamilyMembers() {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: const Text('Membres de la famille'),
        content: StatefulBuilder(
          builder: (context, setState) {
            return Scaffold(
              body: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: familyMembers.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(
                            '${familyMembers[index].firstName} ${familyMembers[index].lastName}'),
                        subtitle: Text(
                          familyMembers[index].birthDate,
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () {
                            setState(() {
                              familyMembers.remove(familyMembers[index]);
                            });
                          },
                        ),
                      );
                    },
                  ),
                ],
              ),
            );
          },
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Ok'),
          ),
        ],
      ),
    );
  }

  Future<bool> onRegister() async {
    if (_registerKey.currentState!.validate()) {
      final beneficiaryCreationRequest = BeneficiaryCreationRequest(
        firstName: firstNameController.text,
        lastName: lastNameController.text,
        username: emailController.text,
        password: passwordController.text,
        phoneNumber: phoneNumberController.text,
        birthDate: dateInput.text,
        localUnitCode: localUnitCode,
        socialWorkerNumber: socialWorkerNumberController.text,
        familyMembers: familyMembers,
      );
      return Register.registerBeneficiary(beneficiaryCreationRequest);
    }
    return false;
  }

  void submit() {
    Navigator.of(context).pop(
      FamilyMemberCreationRequest(
        firstName: alertFirstName.text,
        lastName: alertLastName.text,
        birthDate: alertBirthDate.text,
      ),
    );
  }
}
