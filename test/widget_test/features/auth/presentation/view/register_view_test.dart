import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shikshalaya/features/auth/presentation/view/register_view.dart';
import 'package:shikshalaya/features/auth/presentation/view_model/signup/register_bloc.dart';
import 'package:network_image_mock/network_image_mock.dart';

import '../../../../../mocks.dart';

void main() {
  late MockRegisterBloc mockRegisterBloc;

  setUpAll(() {
    // Register concrete fake events
    registerFallbackValue(FakeRegisterStudent());
    registerFallbackValue(FakeLoadImage());
  });

  setUp(() {
    mockRegisterBloc = MockRegisterBloc();
    when(() => mockRegisterBloc.state).thenReturn(RegisterState.initial());
  });

  Widget createWidgetUnderTest() {
    return BlocProvider<RegisterBloc>.value(
      value: mockRegisterBloc,
      child: const MaterialApp(
        home: RegisterView(),
      ),
    );
  }

  testWidgets('RegisterView renders all fields and button',
      (WidgetTester tester) async {
    mockNetworkImagesFor(() async {
      // Mock network images
      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.text('Create New Account!'), findsOneWidget);
      expect(find.byType(TextFormField), findsNWidgets(5));
      expect(find.byType(ElevatedButton), findsOneWidget);
    });
  });

  testWidgets('User can enter text into form fields',
      (WidgetTester tester) async {
    mockNetworkImagesFor(() async {
      await tester.pumpWidget(createWidgetUnderTest());

      await tester.enterText(find.byType(TextFormField).at(0), 'John Doe');
      await tester.enterText(
          find.byType(TextFormField).at(1), 'john@example.com');
      await tester.enterText(find.byType(TextFormField).at(2), '1234567890');
      await tester.enterText(find.byType(TextFormField).at(3), 'password123');
      await tester.enterText(find.byType(TextFormField).at(4), 'password123');

      expect(find.text('John Doe'), findsOneWidget);
      expect(find.text('john@example.com'), findsOneWidget);
    });
  });

  testWidgets('RegisterView has a profile image button',
      (WidgetTester tester) async {
    mockNetworkImagesFor(() async {
      await tester.pumpWidget(createWidgetUnderTest());

      // Ensure at least one InkWell exists
      expect(find.byType(InkWell), findsAtLeastNWidgets(1));
      expect(find.byType(CircleAvatar), findsOneWidget);
    });
  });

  testWidgets('RegisterView has expected text fields and labels',
      (WidgetTester tester) async {
    mockNetworkImagesFor(() async {
      await tester.pumpWidget(createWidgetUnderTest());

      // Checking for expected labels in form fields
      expect(find.text('Full Name'), findsOneWidget);
      expect(find.text('Email'), findsOneWidget);
      expect(find.text('Phone Number'), findsOneWidget);
      expect(find.text('Password'), findsOneWidget);
      expect(find.text('Confirm Password'), findsOneWidget);
    });
  });
}
