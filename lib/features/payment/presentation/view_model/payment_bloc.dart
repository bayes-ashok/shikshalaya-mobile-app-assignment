import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shikshalaya/features/course/domain/entity/course_entity.dart';
import 'package:shikshalaya/features/payment/domain/use_case/on_payment_complete.dart';

import '../../../../app/di/di.dart';
import '../../../../core/common/common_snackbar.dart';
import '../../../course/presentation/view/course_detail_page.dart';
import '../../../course/presentation/view_model/bloc/course_bloc.dart';
import '../../../test/presentation/view/test_screen.dart';

part 'payment_event.dart';
part 'payment_state.dart';

class PaymentBloc extends Bloc<PaymentEvent, PaymentState> {
  final OnPaymentCompleteUseCase _onPaymentCompleteUseCase;
  PaymentBloc({required OnPaymentCompleteUseCase paymentCompleteUseCase})
      : _onPaymentCompleteUseCase = paymentCompleteUseCase,
        super(PaymentInitial()) {
    on<GeneratePidxEvent>((event, emit) {
      print("yooo ${event.courseId}");
      // Emit a static PidxGenerated state
      emit(PidxGenerated("V49pRRq3RhxPzvaYyb3vfC"));
    });

    on<OnPaymentCompleteEvent>((event, emit) async {
      print("Payment completed successfully!");
      final result = await _onPaymentCompleteUseCase(
          OnPaymentCompleteParams(course: event.course));

      result.fold(
        (failure) {
          print("Enrollment check failed");
        },
        (isEnrolled) {
          showMySnackBar(
            context: event.context,
            message: "You have successfully purchased the course!",
            color: Colors.green,
          );
          Navigator.push(
            event.context,
            MaterialPageRoute(
              builder: (context) =>
                  MultiBlocProvider(
                    providers: [
                      BlocProvider.value(value: getIt<CourseBloc>()),
                      BlocProvider.value(value: getIt<PaymentBloc>()),
                    ],
                    child: CourseDetailPage(courseId: event.course.courseId),
                  ),
            ),
          );

          print("📌 Enrollment Check Completed! Fetching Course...");
        },
      );
    });
  }
}
