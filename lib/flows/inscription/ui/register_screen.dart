import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:pa_mobile/core/model/authentication/beneficiary_creation_request.dart';
import 'package:pa_mobile/core/model/authentication/family_member_creation_request.dart';
import 'package:pa_mobile/core/model/local_unit/local_unit_response_dto.dart';
import 'package:pa_mobile/flows/inscription/logic/register.dart';
import 'package:pa_mobile/flows/inscription/ui/register_success_screen.dart';
import 'package:pa_mobile/shared/validators/field_validators.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  static const routeName = '/register';

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  List<FamilyMemberCreationRequest> familyMembers = [];

  var _showPassword = false;
  var _showConfirmPassword = false;
  final _formKeyFamily = GlobalKey<FormState>();
  final _accountCreationFormKey = GlobalKey<FormState>();
  final _personalInformationFormKey = GlobalKey<FormState>();
  final _localUnitInformationFormKey = GlobalKey<FormState>();
  final _familyInformationFormKey = GlobalKey<FormState>();
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
  List<bool> hasTryToSubmit = [
    false,
    false,
    false,
    false,
  ];
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
        shadowColor: Colors.transparent,
      ),
      body: SafeArea(
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          body: Theme(
            data: ThemeData(
              colorScheme: Theme.of(context).colorScheme.copyWith(
                    primary: Colors.green,
                    background: Colors.red,
                    secondary: Colors.green,
                    tertiary: Colors.green,
                  ),
            ),
            child: Stepper(
              currentStep: _index,
              controlsBuilder: (context, detail) => Wrap(
                children: <Widget>[
                  if (!(_index == 0))
                    Padding(
                      padding: const EdgeInsets.all(4),
                      child: TextButton(
                        onPressed: onStepCancel,
                        child: const Text('Précédent'),
                      ),
                    ),
                  if (!(_index == 3))
                    Padding(
                      padding: const EdgeInsets.all(4),
                      child: TextButton(
                        onPressed: onStepContinue,
                        child: const Text('Suivant'),
                      ),
                    )
                  else
                    Padding(
                      padding: const EdgeInsets.all(4),
                      child: TextButton(
                        onPressed: onRegister,
                        child: const Text("S'inscrire"),
                      ),
                    ),
                ],
              ),
              onStepTapped: (int index) {
                if (index < _index) {
                  setState(() {
                    _index = index;
                  });
                } else if (index == _index) {
                } else {
                  onStepContinue();
                }
              },
              steps: <Step>[
                Step(
                  isActive: _index >= 0,
                  title: const Text('Création du Compte'),
                  state: _index >= 0 && hasTryToSubmit[0]
                      ? (isAccountCreationFormValid()
                          ? StepState.complete
                          : StepState.error)
                      : StepState.indexed,
                  content: Form(
                    key: _accountCreationFormKey,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(4),
                          child: TextFormField(
                            decoration: const InputDecoration(
                              labelText: 'Email',
                              hintText: 'email@email.com',
                              fillColor: Color(0xfff3f3f4),
                              filled: true,
                              border: OutlineInputBorder(),
                            ),
                            keyboardType: TextInputType.name,
                            textInputAction: TextInputAction.next,
                            controller: emailController,
                            validator: FieldValidators.emailValidator,
                            focusNode: _focusNodes[0],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(4),
                          child: TextFormField(
                            decoration: InputDecoration(
                              fillColor: const Color(0xfff3f3f4),
                              filled: true,
                              labelText: 'Mot de passe',
                              border: const OutlineInputBorder(),
                              suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    _showPassword = !_showPassword;
                                  });
                                },
                                icon: Icon(
                                  _showPassword
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                ),
                              ),
                            ),
                            obscureText: !_showPassword,
                            keyboardType: TextInputType.visiblePassword,
                            textInputAction: TextInputAction.next,
                            controller: passwordController,
                            validator: FieldValidators.passwordValidator,
                            focusNode: _focusNodes[1],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(4),
                          child: TextFormField(
                            decoration: InputDecoration(
                              labelText: 'Confirmer le mot de passe',
                              border: const OutlineInputBorder(),
                              fillColor: const Color(0xfff3f3f4),
                              filled: true,
                              suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    _showConfirmPassword =
                                        !_showConfirmPassword;
                                  });
                                },
                                icon: Icon(
                                  _showConfirmPassword
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                ),
                              ),
                            ),
                            obscureText: !_showConfirmPassword,
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
                        ),
                      ],
                    ),
                  ),
                ),
                Step(
                  state: _index >= 1 && hasTryToSubmit[1]
                      ? (isPersonalInformationFormValid()
                          ? StepState.complete
                          : StepState.error)
                      : StepState.indexed,
                  isActive: _index >= 1,
                  title: const Text('Informations Personnelles'),
                  content: Form(
                    key: _personalInformationFormKey,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(4),
                          child: TextFormField(
                            decoration: const InputDecoration(
                              labelText: 'Prénom',
                              icon: Icon(Icons.account_circle),
                              fillColor: Color(0xfff3f3f4),
                              filled: true,
                              border: OutlineInputBorder(),
                            ),
                            keyboardType: TextInputType.name,
                            controller: firstNameController,
                            textInputAction: TextInputAction.next,
                            validator: FieldValidators.nameValidator,
                            focusNode: _focusNodes[3],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(4),
                          child: TextFormField(
                            decoration: const InputDecoration(
                              labelText: 'Nom',
                              icon: Icon(Icons.account_circle),
                              fillColor: Color(0xfff3f3f4),
                              filled: true,
                              border: OutlineInputBorder(),
                            ),
                            keyboardType: TextInputType.name,
                            textInputAction: TextInputAction.next,
                            controller: lastNameController,
                            validator: FieldValidators.nameValidator,
                            focusNode: _focusNodes[4],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(4),
                          child: TextFormField(
                            decoration: const InputDecoration(
                              labelText: 'Numéro de téléphone',
                              icon: Icon(Icons.phone),
                              fillColor: Color(0xfff3f3f4),
                              filled: true,
                              border: OutlineInputBorder(),
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
                        ),
                        Padding(
                          padding: const EdgeInsets.all(4),
                          child: TextFormField(
                            controller: dateInput,
                            decoration: const InputDecoration(
                              icon: Icon(Icons.calendar_today),
                              labelText: 'Enter Date',
                              fillColor: Color(0xfff3f3f4),
                              filled: true,
                              border: OutlineInputBorder(),
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
                        ),
                      ],
                    ),
                  ),
                ),
                Step(
                  state: _index >= 2 && hasTryToSubmit[2]
                      ? (isLocalUnitInformationFormValid()
                          ? StepState.complete
                          : StepState.error)
                      : StepState.indexed,
                  isActive: _index >= 2,
                  title: const Text('Informations Unité Locale'),
                  content: Form(
                    key: _localUnitInformationFormKey,
                    child: Column(
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
                              return Padding(
                                padding: const EdgeInsets.all(4),
                                child: DropdownButtonFormField(
                                  validator: (value) {
                                    print(value);
                                    if (value == null || value.isEmpty) {
                                      return 'Veuillez sélectionner une unité locale';
                                    }
                                    return null;
                                  },
                                  decoration: const InputDecoration(
                                    icon: Icon(Icons.home),
                                    labelText: 'Unité locale',
                                    fillColor: Color(0xfff3f3f4),
                                    filled: true,
                                    border: OutlineInputBorder(),
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
                                ),
                              );
                            } else {
                              return const CircularProgressIndicator();
                            }
                          },
                        ),
                        Padding(
                          padding: const EdgeInsets.all(4),
                          child: TextFormField(
                            decoration: const InputDecoration(
                              hintText: 'Numéro de travailleur social',
                              icon: Icon(Icons.work),
                              fillColor: Color(0xfff3f3f4),
                              filled: true,
                              border: OutlineInputBorder(),
                            ),
                            keyboardType: TextInputType.number,
                            textInputAction: TextInputAction.next,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(15),
                            ],
                            controller: socialWorkerNumberController,
                            validator:
                                FieldValidators.socialWorkerNumberValidator,
                            focusNode: _focusNodes[8],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Step(
                  state: _index >= 3 && hasTryToSubmit[3]
                      ? (isFamilyInformationFormValid()
                          ? StepState.complete
                          : StepState.error)
                      : StepState.indexed,
                  isActive: _index >= 3,
                  title: const Text('Informations Familiales'),
                  content: Form(
                    key: _familyInformationFormKey,
                    child: Wrap(
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
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void onStepContinue() {
    switch (_index) {
      case 0:
        hasTryToSubmit[0] = true;
        if (_accountCreationFormKey.currentState!.validate()) {
          _accountCreationFormKey.currentState!.save();
          if (_index <= 2) {
            setState(() {
              _index += 1;
            });
          }
        }
        break;
      case 1:
        hasTryToSubmit[1] = true;
        if (_personalInformationFormKey.currentState!.validate()) {
          _personalInformationFormKey.currentState!.save();
          if (_index <= 2) {
            setState(() {
              _index += 1;
            });
          }
        }
        break;
      case 2:
        hasTryToSubmit[2] = true;
        if (_localUnitInformationFormKey.currentState!.validate()) {
          _localUnitInformationFormKey.currentState!.save();
          if (_index <= 2) {
            setState(() {
              _index += 1;
            });
          }
        }
        break;
      case 3:
        hasTryToSubmit[3] = true;
        if (_familyInformationFormKey.currentState!.validate()) {
          _familyInformationFormKey.currentState!.save();
          if (_index <= 2) {
            setState(() {
              _index += 1;
            });
          }
        }
        break;
      default:
        break;
    }
    setState(() {});
  }

  void onStepCancel() {
    if (_index > 0) {
      setState(() {
        _index -= 1;
      });
    }
    setState(() {});
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
    if (_accountCreationFormKey.currentState!.validate() &&
        _personalInformationFormKey.currentState!.validate() &&
        _localUnitInformationFormKey.currentState!.validate() &&
        _familyInformationFormKey.currentState!.validate()) {
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
      final bool =
          await Register.registerBeneficiary(beneficiaryCreationRequest);
      if (bool) {
        await Navigator.of(context).pushNamed(
          RegisterSuccessScreen.routeName,
        );
        return true;
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Inscription échouée'),
          ),
        );
      }
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

  bool isAccountCreationFormValid() {
    return _accountCreationFormKey.currentState!.validate();
  }

  bool isPersonalInformationFormValid() {
    return _personalInformationFormKey.currentState!.validate();
  }

  bool isLocalUnitInformationFormValid() {
    return _localUnitInformationFormKey.currentState!.validate();
  }

  bool isFamilyInformationFormValid() {
    return _familyInformationFormKey.currentState!.validate();
  }
}
