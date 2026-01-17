String? conditionOfValidationEmail(value) {
  var nonNullValue = value ?? '';
  // if (nonNullValue.isEmpty) {
  //   return ("Email is required");
  // }
  if (!nonNullValue.contains("@")) {
    return ("Email should contains @");
  }
  return null;
}

String? conditionOfValidationPassWord(value) {
  // RegExp regex =
  //     RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');
  var passNonNullValue = value ?? "";
  if (passNonNullValue.isEmpty) {
    return ("كلمة المرور مطلوبة");
  } else if (passNonNullValue.length < 8) {
    return ("يجب أن تكون كلمة المرور أكثر من 8 أحرف");
  }
  //  else if (!regex.hasMatch(passNonNullValue)) {
  //   return ("كلمه المرور يجب ان تتضمن الشروط المطلوبه");
  // }
  return null;
}

String? conditionOfValidationName(value) {
  var nonNullValue = value ?? '';
  if (nonNullValue.isEmpty) {
    return 'اسم المستخدم مطلوب';
  }

  // تقسيم الاسم إلى مقاطع باستخدام المسافات
  List<String> nameParts = nonNullValue.split(' ');

  // التحقق من عدد المقاطع
  if (nameParts.length < 3) {
    return 'الاسم يجب أن يكون مكونًا من ثلاث مقاطع على الأقل';
  }

  return null;
}

String? conditionOfValidationPhone(value) {
  var nonNullValue = value ?? '';

  if (nonNullValue.isEmpty) {
    return ('الهاتف مطلوب');
  } else if (nonNullValue.length < 11 || nonNullValue.length > 11) {
    return ("رقم الهاتف يجب أن يكون 11 رقم");
  }
  return null;
}
