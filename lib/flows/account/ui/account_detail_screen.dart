import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pa_mobile/shared/cubit/beneficiary_cubit.dart';
import 'package:pa_mobile/shared/cubit/beneficiary_state.dart';
import 'package:pa_mobile/shared/services/request/beneficiary/beneficiary_repository.dart';

class AccountDetailsScreen extends StatefulWidget {
  const AccountDetailsScreen({super.key});

  static const routeName = '/account';

  @override
  State<AccountDetailsScreen> createState() => _AccountDetailsScreenState();
}

class _AccountDetailsScreenState extends State<AccountDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => BeneficiaryCubit(
        beneficiaryRepository: BeneficiaryRepository(),
      ),
      child: Scaffold(
        resizeToAvoidBottomInset : false,
        appBar: AppBar(
          title: const Text('Account Details'),
        ),
        body: BlocBuilder<BeneficiaryCubit, BeneficiaryState>(
          builder: (context, state) {
            print(state);
            if (state is LoadingBeneficiaryState) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is ErrorBeneficiaryState) {
              return const Center(child: Text('Failed to load beneficiary'));
            } else if (state is LoadedBeneficiaryState) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('First: ${state.beneficiary.lastName}'),
                    Text('Last: ${state.beneficiary.firstName}'),
                    Text('Phone: ${state.beneficiary.phoneNumber}'),
                    Text('Local Unit: ${state.beneficiary.localUnitId}'),
                    Text('Validated: ${state.beneficiary.isValidated}'),
                    Text('Username: ${state.beneficiary.username}')
                  ],
                ),
              );
            }
            return Container(
                child: Text('Something went wrong'));
          },
        ),
      ),
    );
  }
}
