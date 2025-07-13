
import 'package:danapaniexpress/core/common_imports.dart';

class PhoneUtils {
  static String? normalizePhone(String rawPhone) {
    String formattedPhone = rawPhone.trim();
    final onlyDigits = formattedPhone.replaceAll(RegExp(r'\D'), '');

    if (onlyDigits.length == 10) {
      return '+92$onlyDigits';
    } else if (onlyDigits.length == 11 && onlyDigits.startsWith('0')) {
      return '+92${onlyDigits.substring(1)}';
    } else if (formattedPhone.startsWith('+92') && formattedPhone.length == 13) {
      return formattedPhone;
    }

    return null;
  }
  static String normalizeEmail(String rawEmail) {
    return rawEmail.trim().toLowerCase();
  }

  /// Detects and normalizes input (email or phone), or returns null if invalid
  static String? normalizeLoginInput(String input) {
    final trimmed = input.trim();

    final isEmail = RegExp(
        r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$"
    ).hasMatch(trimmed);

    if (isEmail) {
      return normalizeEmail(trimmed);
    }

    return normalizePhone(trimmed);
  }
}

class FormValidations {

  static String? fullNameValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppLanguage.enterFullNameStr(appLanguage).toString();
    }

    final trimmed = value.trim();
    final isValid = RegExp(r"^[a-zA-Z\u0600-\u06FF\s.'-]{2,}$").hasMatch(trimmed);

    if (!isValid) {
      return AppLanguage.fullNameInvalidCharactersStr(appLanguage).toString();
    }

    return null;
  }

  static String? optionalEmailValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return null; // ✅ Empty is allowed
    }

    final trimmed = value.trim();
    final isEmail = RegExp(
      r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$",
    ).hasMatch(trimmed);

    if (!isEmail) {
      return AppLanguage.invalidEmailFormatStr(appLanguage).toString();
    }

    return null;
  }

  static String? emailValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppLanguage.enterEmailStr(appLanguage).toString();
    }

    final trimmed = value.trim();
    final isEmail = RegExp(
      r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$",
    ).hasMatch(trimmed);

    if (!isEmail) {
      return AppLanguage.invalidEmailFormatStr(appLanguage).toString();
    }

    return null;
  }

  static String? phoneValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppLanguage.enterPhoneStr(appLanguage).toString();
    }

    final trimmed = value.trim();
    final onlyDigits = trimmed.replaceAll(RegExp(r'\D'), '');

    final isPhoneWithCode = trimmed.startsWith('+92') && trimmed.length == 13;
    final isPhoneWithLeadingZero = onlyDigits.length == 11 && onlyDigits.startsWith('0');
    final isPhoneWithoutCodeOrZero = onlyDigits.length == 10;

    if (isPhoneWithCode || isPhoneWithLeadingZero || isPhoneWithoutCodeOrZero) {
      return null;
    }

    return AppLanguage.invalidPhoneStr(appLanguage).toString();
  }

  static String? emailOrPhoneValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppLanguage.enterEmailOrPhoneStr(appLanguage).toString();
    }

    final trimmed = value.trim();

    // Email validation
    final isEmail = RegExp(
      r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$",
    ).hasMatch(trimmed);

    if (isEmail) return null;

    // Phone validation
    final onlyDigits = trimmed.replaceAll(RegExp(r'\D'), '');
    final isPhoneWithCode = trimmed.startsWith('+92') && trimmed.length == 13;
    final isPhoneWithLeadingZero = onlyDigits.length == 11 && onlyDigits.startsWith('0');
    final isPhoneWithoutCodeOrZero = onlyDigits.length == 10;

    if (isPhoneWithCode || isPhoneWithLeadingZero || isPhoneWithoutCodeOrZero) {
      return null;
    }

    return AppLanguage.invalidEmailOrPhoneStr(appLanguage).toString();
  }

  static String? passwordValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppLanguage.enterPasswordStr(appLanguage).toString();
    }

    if (value.length < 6) {
      return AppLanguage.passwordMustBeStr(appLanguage).toString();
    }

    return null;
  }

  /// ADDRESS VALIDATIONS

  static String? addressValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppLanguage.enterCompleteAddressStr(appLanguage).toString();
    }
    return null;
  }

  static String? nearestPlaceValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppLanguage.enterNearestPlaceStr(appLanguage).toString();
    }
    return null;
  }



}