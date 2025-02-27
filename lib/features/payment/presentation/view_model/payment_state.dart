part of 'payment_bloc.dart';

sealed class PaymentState extends Equatable {
  const PaymentState();

  @override
  List<Object> get props => [];
}

final class PaymentInitial extends PaymentState {}

final class PidxGenerated extends PaymentState {
  final String pidx;

  const PidxGenerated(this.pidx);

  @override
  List<Object> get props => [pidx];
}
