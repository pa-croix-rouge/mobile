import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pa_mobile/shared/cubit/beneficiary_state.dart';
import 'package:pa_mobile/shared/services/request/beneficiary/beneficiary_repository.dart';

class BeneficiaryCubit extends Cubit<BeneficiaryState> {
  BeneficiaryCubit({required this.beneficiaryRepository})
      : super(InitialBeneficiaryState()) {
    getBeneficiary();
}

  final BeneficiaryRepository beneficiaryRepository;

  Future<void> getBeneficiary() async {
    try {
      emit(LoadingBeneficiaryState());
      final beneficiary = await beneficiaryRepository.getBeneficiary();
      emit(LoadedBeneficiaryState(beneficiary));
    } catch (e) {
      emit(ErrorBeneficiaryState());
    }
  }
}
