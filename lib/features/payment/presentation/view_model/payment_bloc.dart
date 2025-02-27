import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'payment_event.dart';
part 'payment_state.dart';

class PaymentBloc extends Bloc<PaymentEvent, PaymentState> {
  PaymentBloc() : super(PaymentInitial()) {
    on<GeneratePidxEvent>((event, emit) {
      print("yooo ${event.courseId}");
      // Emit a static PidxGenerated state
      emit(PidxGenerated("V49pRRq3RhxPzvaYyb3vfC"));
    });
  }
}
