import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shikshalaya/features/auth/presentation/view/login_view.dart';
import 'package:shikshalaya/features/auth/presentation/view_model/login/login_bloc.dart';

import '../../../../../mocks.dart';

void main() {
  late MockLoginBloc mockLoginBloc;

  setUpAll(() {
    // ✅ Register fallbacks for each event type
    registerFallbackValue(FakeNavigateRegisterScreenEvent());
    registerFallbackValue(FakeNavigateHomeScreenEvent());
    registerFallbackValue(FakeLoginStudentEvent());
  });

  setUp(() {
    mockLoginBloc = MockLoginBloc();
  });

  Widget createTestWidget() {
    return MaterialApp(
      home: BlocProvider<LoginBloc>.value(
        value: mockLoginBloc,
        child: const LoginView(),
      ),
    );
  }

  testWidgets('LoginView has email and password fields',
      (WidgetTester tester) async {
    await tester.pumpWidget(createTestWidget());

    expect(find.byType(TextFormField),
        findsNWidgets(2)); // Email and Password fields
    expect(find.text('Email'), findsOneWidget);
    expect(find.text('Password'), findsOneWidget);
  });

  testWidgets('LoginView has login button', (WidgetTester tester) async {
    await tester.pumpWidget(createTestWidget());

    expect(find.text('Login'), findsOneWidget);
    expect(find.byType(ElevatedButton), findsOneWidget);
  });

  testWidgets('Entering invalid email shows validation error',
      (WidgetTester tester) async {
    await tester.pumpWidget(createTestWidget());

    await tester.enterText(find.byType(TextFormField).first, 'invalid-email');
    await tester.tap(find.byType(ElevatedButton));
    await tester.pumpAndSettle();

    expect(find.textContaining('valid email'), findsOneWidget);
  });
}
