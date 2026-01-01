import 'package:easy_localization/easy_localization.dart';
import 'package:engaz_app/core/constants/app_keys.dart';

abstract class Validator {
  static String? validateEmail(String? val) {
    final RegExp emailRegex = RegExp(AppKeys.emailRegex);
    if (val == null || val.trim().isEmpty) {
      return 'Email cannot be empty'.tr();
    } else if (!emailRegex.hasMatch(val)) {
      return 'Enter a valid email address'.tr();
    } else {
      return null;
    }
  }

  static String? validatePassword(String? val) {
    final RegExp passwordRegex = RegExp(AppKeys.passwordRegex);
    if (val == null || val.isEmpty) {
      return 'Password cannot be empty'.tr();
    } else if (!passwordRegex.hasMatch(val)) {
      return 'Enter a valid password'.tr();
    } else {
      return null;
    }
  }

  static String? validateConfirmPassword(String? val, String? password) {
    if (val == null || val.isEmpty) {
      return 'Password cannot be empty'.tr();
    } else if (val != password) {
      return 'Confirm password must match the password'.tr();
    } else {
      return null;
    }
  }

  static String? validateName(String? val) {
    if (val == null || val.isEmpty) {
      return 'Name cannot be empty'.tr();
    } else {
      return null;
    }
  }

  static String? validatePhoneNumber(String? val) {
    if (val == null || val.trim().isEmpty) {
      return 'Phone number cannot be empty'.tr();
    }

    final phone = val.trim();
    final isValid = RegExp(r'^\+?\d+$').hasMatch(phone);
    if (!isValid || phone.length != 11) {
      return 'Enter a valid phone number'.tr();
    }

    return null;
  }

  static String? validateCode(String? val) {
    if (val == null || val.isEmpty) {
      return 'Code cannot be empty'.tr();
    } else if (val.length < 6) {
      return 'Code should be at least 6 digits'.tr();
    } else {
      return null;
    }
  }

  static String? validateQuantity(String? value) {
    if (value == null || value.isEmpty) {
      return "Please enter quantity".tr();
    }
    if (int.tryParse(value) == null) {
      return "Please enter a valid number".tr();
    }
    return null;
  }

  static String? validatePrice(String? value) {
    if (value == null || value.isEmpty) {
      return "Please enter price".tr();
    }
    final price = double.tryParse(value);
    if (price == null) {
      return "Please enter a valid price".tr();
    }
    if (price <= 0) {
      return "Price must be greater than zero".tr();
    }
    return null;
  }
}
