import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:pa_mobile/core/model/authentication/beneficiary_creation_request.dart';
import 'package:pa_mobile/core/model/beneficiary/beneficiary_response_dto.dart';
import 'package:pa_mobile/flows/account/logic/account.dart';
import 'package:pa_mobile/flows/event/logic/event.dart';
import 'package:pa_mobile/shared/validators/field_validators.dart';

class ModifyProfileScreen extends StatefulWidget {
  static const routeName = '/modify_profile';

  const ModifyProfileScreen({Key? key}) : super(key: key);

  @override
  State<ModifyProfileScreen> createState() => _ModifyProfileScreenState();
}

class _ModifyProfileScreenState extends State<ModifyProfileScreen> {

  var _showPassword = false;
  var _showConfirmPassword = false;
  final _accountCreationFormKey = GlobalKey<FormState>();
  final _personalInformationFormKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController socialWorkerNumberController = TextEditingController();
  TextEditingController dateInput = TextEditingController();
  List<bool> hasTryToSubmit = [
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

  Future<bool> onRegister(BeneficiaryResponseDto beneficiaryResponseDto) async {
    if (_accountCreationFormKey.currentState!.validate() &&
        _personalInformationFormKey.currentState!.validate()) {
      final beneficiaryCreationRequest = BeneficiaryCreationRequest(
        firstName: firstNameController.text,
        lastName: lastNameController.text,
        username: emailController.text,
        password: passwordController.text.isEmpty ? null : passwordController.text,
        phoneNumber: phoneNumberController.text,
        birthDate: dateInput.text,
        localUnitCode: beneficiaryResponseDto.localUnitId.toString(),
        socialWorkerNumber: socialWorkerNumberController.text,
        familyMembers: null,
      );
      await Account.modifyBeneficiaryInfo(beneficiaryCreationRequest, beneficiaryResponseDto.id);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.green,
          content: Text('Votre compte a été modifié avec succès'),
        ),
      );
      Navigator.pop(context, true);
      return true;
    }
    return false;
  }

  bool isAccountCreationFormValid() {
    return _accountCreationFormKey.currentState!.validate();
  }

  bool isPersonalInformationFormValid() {
    return _personalInformationFormKey.currentState!.validate();
  }

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
          emailController.text = beneficiary.username;
          firstNameController.text = beneficiary.firstName;
          lastNameController.text = beneficiary.lastName;
          phoneNumberController.text = beneficiary.phoneNumber;
          dateInput.text = beneficiary.birthDate;
          return Padding(
            padding: const EdgeInsets.all(20),
            child: SafeArea(
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
                        if (!(_index == 1))
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
                              onPressed: () => onRegister(beneficiary),
                              child: const Text("Sauvegarder"),
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
                        title: const Text('Compte'),
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
                                    if (passwordController.text.isEmpty) {
                                      return null;
                                    }
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
                    ],
                  ),
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
