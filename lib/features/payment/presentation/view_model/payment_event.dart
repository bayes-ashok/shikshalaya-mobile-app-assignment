// payment_event.dart
part of 'payment_bloc.dart';

sealed class PaymentEvent extends Equatable {
  const PaymentEvent();

  @override
  List<Object> get props => [];
}

class GeneratePidxEvent extends PaymentEvent {
  final String courseId;

  const GeneratePidxEvent(this.courseId);

  @override
  List<Object> get props => [courseId];
}
