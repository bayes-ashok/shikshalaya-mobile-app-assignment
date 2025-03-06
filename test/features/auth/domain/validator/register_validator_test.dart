import 'package:flutter_test/flutter_test.dart';
import 'package:shikshalaya/features/auth/domain/validator/register_validator.dart';

void main() {
  group('ValidationUtils Tests', () {
    group('validateFullName', () {
      test('returns error message for null value', () {
        expect(ValidationUtils.validateFullName(null),
            'Please enter your full name');
      });

      test('returns error message for empty string', () {
        expect(ValidationUtils.validateFullName(''),
            'Please enter your full name');
      });

      test('returns null for non-empty name', () {
        expect(ValidationUtils.validateFullName('John Doe'), null);
      });
    });

    group('validateEmail', () {
      test('returns error message for null value', () {
        expect(ValidationUtils.validateEmail(null), 'Please enter your email');
      });

      test('returns error message for empty string', () {
        expect(ValidationUtils.validateEmail(''), 'Please enter your email');
      });

      test('returns error message for email with only spaces', () {
        expect(ValidationUtils.validateEmail('   '), 'Please enter your email');
      });

      test('returns error message for invalid email format', () {
        expect(ValidationUtils.validateEmail('invalid-email'),
            'Please enter a valid email address');
      });

      test('returns null for valid email format', () {
        expect(ValidationUtils.validateEmail('test@example.com'), null);
      });
    });

    group('validatePhoneNumber', () {
      test('returns error message for null value', () {
        expect(ValidationUtils.validatePhoneNumber(null),
            'Please enter your phone number');
      });

      test('returns error message for empty string', () {
        expect(ValidationUtils.validatePhoneNumber(''),
            'Please enter your phone number');
      });

      test('returns error message for invalid phone number length', () {
        expect(ValidationUtils.validatePhoneNumber('12345'),
            'Please enter a valid 10-digit phone number');
      });

      test('returns error message for non-numeric phone number', () {
        expect(ValidationUtils.validatePhoneNumber('123456789a'),
            'Please enter a valid 10-digit phone number');
      });

      test('returns null for valid phone number', () {
        expect(ValidationUtils.validatePhoneNumber('1234567890'), null);
      });
    });

    group('validatePassword', () {
      test('returns error message for null value', () {
        expect(ValidationUtils.validatePassword(null),
            'Please enter your password');
      });

      test('returns error message for empty string', () {
        expect(
            ValidationUtils.validatePassword(''), 'Please enter your password');
      });

      test('returns error message for password shorter than 6 characters', () {
        expect(ValidationUtils.validatePassword('12345'),
            'Password must be at least 6 characters long');
      });

      test('returns null for valid password', () {
        expect(ValidationUtils.validatePassword('password123'), null);
      });
    });

    group('validateConfirmPassword', () {
      const password = 'password123';

      test('returns error message for null value', () {
        expect(ValidationUtils.validateConfirmPassword(null, password),
            'Please confirm your password');
      });

      test('returns error message for empty string', () {
        expect(ValidationUtils.validateConfirmPassword('', password),
            'Please confirm your password');
      });

      test('returns error message for passwords that do not match', () {
        expect(
            ValidationUtils.validateConfirmPassword(
                'differentPassword', password),
            'Passwords do not match');
      });

      test('returns null for matching passwords', () {
        expect(ValidationUtils.validateConfirmPassword('password123', password),
            null);
      });
    });
  });
}
