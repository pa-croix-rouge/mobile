import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:pa_mobile/core/model/authentication/beneficiary_creation_request.dart';
import 'package:pa_mobile/core/model/authentication/family_member_creation_request.dart';
import 'package:pa_mobile/core/model/local_unit/local_unit_response_dto.dart';
import 'package:pa_mobile/flows/inscription/logic/register.dart';
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
  final _formKeyFamily = GlobalKey<FormState>();
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
  int _index = 0;
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
    alertBirthDate = TextEditingController(
      text: DateFormat('yyyy-MM-dd').format(
        DateTime.now().subtract(const Duration(days: 10950)),
      ),
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
                child: Padding(
                  padding: const EdgeInsets.all(0),
                  child: Stepper(
                    //horizontal
                    currentStep: _index,
                    onStepCancel: () {
                      if (_index > 0) {
                        setState(() {
                          _index -= 1;
                        });
                      }
                    },
                    onStepContinue: () {
                      if (_index <= 0) {
                        setState(() {
                          _index += 1;
                        });
                      }
                    },
                    onStepTapped: (int index) {
                      setState(() {
                        _index = index;
                      });
                    },
                    steps: <Step>[
                      Step(
                        title: const Text('1'),
                        content: Column(
                          children: [
                            TextFormField(
                              decoration: const InputDecoration(
                                labelText: 'Email',
                                icon: Icon(Icons.account_circle),
                                fillColor: Colors.grey,
                              ),
                              keyboardType: TextInputType.name,
                              textInputAction: TextInputAction.next,
                              controller: emailController,
                              validator: FieldValidators.emailValidator,
                              focusNode: _focusNodes[0],
                            ),
                            TextFormField(
                              decoration: const InputDecoration(
                                filled: true,
                                labelText: 'Mot de passe',
                                icon: Icon(Icons.lock),
                                fillColor: Colors.black,
                              ),
                              keyboardType: TextInputType.visiblePassword,
                              textInputAction: TextInputAction.next,
                              controller: passwordController,
                              validator: FieldValidators.passwordValidator,
                              focusNode: _focusNodes[1],
                            ),
                            TextFormField(
                              decoration: const InputDecoration(
                                labelText: 'Confirmer le mot de passe',
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
                          ],
                        ),
                      ),
                      Step(
                        title: const Text('2'),
                        content: Column(
                          children: [
                            TextFormField(
                              decoration: const InputDecoration(
                                labelText: 'Prénom',
                                icon: Icon(Icons.account_circle),
                                fillColor: Colors.white,
                              ),
                              keyboardType: TextInputType.name,
                              controller: firstNameController,
                              textInputAction: TextInputAction.next,
                              validator: FieldValidators.nameValidator,
                              focusNode: _focusNodes[3],
                            ),TextFormField(
                              decoration: const InputDecoration(
                                labelText: 'Nom',
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
                                labelText: 'Numéro de téléphone',
                                icon: Icon(Icons.phone),
                                fillColor: Colors.white,
                              ),
                              keyboardType: TextInputType.phone,
                              textInputAction: TextInputAction.next,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                                LengthLimitingTextInputFormatter(10),
                              ],
                              controller: phoneNumberController,
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
                          ],
                        ),
                      ),
                      Step(
                        title: const Text('3'),
                        content: Column(
                          children: [
                            FutureBuilder(
                              future: Register.loadLocalUnit(),
                              builder: (BuildContext context,
                                  AsyncSnapshot<List<LocalUnitResponseDTO>>
                                      snapshot) {
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
                                        value: localUnit.code,
                                        child: Text(localUnit.name),
                                      );
                                    }).toList(),
                                    onChanged: (String? value) {
                                      setState(() {
                                        localUnitCode = value!;
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
                          ],
                        ),
                      ),
                      Step(
                        title: const Text('4'),
                        content: Wrap(
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
                      ),
                    ],
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: onRegister,
                child: const Text("S'inscrire"),
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
          content: Form(
            key: _formKeyFamily,
            child: Column(
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
    if (_formKeyFamily.currentState!.validate()) {
      _formKeyFamily.currentState!.save();
      Navigator.of(context).pop(
        FamilyMemberCreationRequest(
          firstName: alertFirstName.text,
          lastName: alertLastName.text,
          birthDate: alertBirthDate.text,
        ),
      );
    }
  }
}
