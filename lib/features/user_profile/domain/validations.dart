class ProfileValidationUtils {
  static String? validateFullName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Full Name cannot be empty";
    }
    if (value.length < 3) {
      return "Full Name must be at least 3 characters";
    }
    return null;
  }

  static String? validatePhoneNumber(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Phone Number is required";
    }
    final regex = RegExp(r'^[0-9]{10}$');
    if (!regex.hasMatch(value)) {
      return "Enter a valid 10-digit phone number";
    }
    return null;
  }

  static String? validateCurrentPassword(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Current password is required";
    }
    return null;
  }
}
