import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:pa_mobile/core/model/authentication/family_member_creation_request.dart';
import 'package:pa_mobile/core/model/local_unit/local_unit_response_dto.dart';
import 'package:pa_mobile/flows/authentication/logic/register.dart';
import 'package:pa_mobile/shared/validators/field_validators.dart';

class InscriptionScreen extends StatefulWidget {
  static const routeName = '/register';

  @override
  State<InscriptionScreen> createState() => _InscriptionScreenState();
}

class _InscriptionScreenState extends State<InscriptionScreen> {
  List<FamilyMemberCreationRequest> familyMembers = [];

  final _registerKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordValidator = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController dateInput = TextEditingController();
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
    //String username; done
    //   String password; done
    //   String firstName; done
    //   String lastName; done
    //   String phoneNumber; done
    //   String localUnitCode; done
    //   DateTime birthDate; done
    //   String socialWorkerNumber; done
    //   List<FamilyMemberCreationRequest> familyMembers;

    // faire le formulaire pour tout ces champs
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inscription'),
      ),
      body: SafeArea(
        child: Scaffold(
          body: Column(
            children: [
              Form(
                key: _registerKey,
                child: Column(
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
                      validator: FieldValidators.usernameValidator,
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
                      controller: confirmPasswordValidator,
                      validator: FieldValidators.passwordValidator,
                      focusNode: _focusNodes[2],
                    ),
                    TextFormField(
                      decoration: const InputDecoration(
                        hintText: 'Prénom',
                        icon: Icon(Icons.account_circle),
                        fillColor: Colors.white,
                      ),
                      keyboardType: TextInputType.name,
                      textInputAction: TextInputAction.next,
                      validator: FieldValidators.usernameValidator,
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
                      validator: FieldValidators.usernameValidator,
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
                          lastDate:
                              DateTime.now().subtract(const Duration(days: 5840)),
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
                          return const Text('Unable to load local units');
                        }
                        if (snapshot.hasData) {
                          return DropdownButtonFormField(
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
                            onChanged: print,
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
                      validator: FieldValidators.socialWorkerNumberValidator,
                      focusNode: _focusNodes[8],
                    ),
                    // show each family member
                    ListView(
                      shrinkWrap: true,
                      children: [
                        for (final familyMember in familyMembers)
                          ListTile(
                            title: Text(
                                '${familyMember.firstName} ${familyMember.lastName}'),
                            subtitle: Text(
                              DateFormat('yyyy-MM-dd')
                                  .format(familyMember.birthDate),
                            ),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () {
                                setState(() {
                                  familyMembers.remove(familyMember);
                                });
                              },
                            ),
                          ),
                        ElevatedButton(
                          onPressed: () async {
                            final familyMember = await openDialogFamily();
                            if (familyMember != null) {
                              setState(() {
                                familyMembers.add(familyMember);
                              });
                            }
                          },
                          child: const Text('Ajouter un membre de la famille'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const Spacer(),
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
          title: const Text('Add a family member'),
          content: Column(
            children: [
              const Spacer(),
              TextFormField(
                decoration: const InputDecoration(
                  hintText: 'Prénom',
                  icon: Icon(Icons.account_circle),
                  fillColor: Colors.white,
                ),
                keyboardType: TextInputType.name,
                textInputAction: TextInputAction.next,
                validator: FieldValidators.usernameValidator,
              ),
              //last name
              TextFormField(
                decoration: const InputDecoration(
                  hintText: 'Nom',
                  icon: Icon(Icons.account_circle),
                  fillColor: Colors.white,
                ),
                keyboardType: TextInputType.name,
                textInputAction: TextInputAction.next,
                validator: FieldValidators.usernameValidator,
              ),
              //birth date],
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
                    initialDate:
                        DateTime.now().subtract(const Duration(days: 10950)),
                    firstDate:
                        DateTime.now().subtract(const Duration(days: 36500)),
                    lastDate: DateTime.now(),
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
              ),
              const Spacer(),
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

  void submit() {
    Navigator.of(context).pop(
      FamilyMemberCreationRequest(
        firstName: 'firstName',
        lastName: 'lastName',
        birthDate: DateTime.now(),
      ),
    );
  }
}
