import 'package:flutter_test/flutter_test.dart';
import 'package:shikshalaya/features/auth/domain/validator/login_validation.dart';

void main() {
  group('Validation Tests', () {
    group('validateEmail', () {
      test('returns error message for null value', () {
        expect(Validation.validateEmail(null), 'Please enter your email');
      });

      test('returns error message for empty string', () {
        expect(Validation.validateEmail(''), 'Please enter your email');
      });

      test('returns error message for email with only spaces', () {
        expect(Validation.validateEmail('   '), 'Please enter your email');
      });

      test('returns error message for invalid email format', () {
        expect(Validation.validateEmail('invalid-email'),
            'Please enter a valid email address');
      });

      test('returns null for valid email format', () {
        expect(Validation.validateEmail('test@example.com'), null);
      });
    });

    group('validatePassword', () {
      test('returns error message for null value', () {
        expect(Validation.validatePassword(null), 'Please enter your password');
      });

      test('returns error message for empty string', () {
        expect(Validation.validatePassword(''), 'Please enter your password');
      });

      test('returns null for non-empty password', () {
        expect(Validation.validatePassword('password123'), null);
      });
    });
  });
}
