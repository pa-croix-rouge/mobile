import 'package:equatable/equatable.dart';

import 'package:pa_mobile/core/model/beneficiary/beneficiary_response_dto.dart';

abstract class BeneficiaryState extends Equatable {}

class InitialBeneficiaryState extends BeneficiaryState {
  @override
  List<Object> get props => [];
}

class LoadingBeneficiaryState extends BeneficiaryState {
  @override
  List<Object> get props => [];
}

class LoadedBeneficiaryState extends BeneficiaryState {
  LoadedBeneficiaryState(this.beneficiary);

  final BeneficiaryResponseDto beneficiary;

  @override
  List<Object> get props => [beneficiary];
}

class ErrorBeneficiaryState extends BeneficiaryState {
  @override
  List<Object> get props => [];
}
