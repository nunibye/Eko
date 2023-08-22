import 'app_localizations.dart';

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get email => 'Email';

  @override
  String get password => 'Password';

  @override
  String get confirmPassword => 'Confirm Password';

  @override
  String get logIn => 'Log In';

  @override
  String get invalidEmailTittle => 'Invalid Email Formating';

  @override
  String get invalidEmailBody => 'Please check your email and try again.';

  @override
  String get userNotFoundTitle => 'Can\'t Find Account';

  @override
  String get userNotFoundBody => 'We can\'t find an account with that email. Try another email, or sign up.';

  @override
  String get wrongPasswordTittle => 'Incorrect Password';

  @override
  String get wrongPasswordBody => 'The password you entered is incorrect.';

  @override
  String get userDisabledTittle => 'Account Disabled';

  @override
  String get userDisabledBody => 'Your account has been disabled. Please contact us at conetechnologiesdev@gmail.com.';

  @override
  String get weakPasswordTitle => 'Weak Password';

  @override
  String get weakPasswordBody => 'Check password requirements and try again.';

  @override
  String get defaultErrorTittle => 'Something Went Wrong';

  @override
  String get defaultErrorBody => 'Please try again later or reach out to conetechnologiesdev@gmail.com.';

  @override
  String get emailAlreadyInUseTitle => 'Email Already In-Use';

  @override
  String get emailAlreadyInUseBody => 'An account with that email already exists';

  @override
  String get forgotPasswordTittle => 'You\'ve Got Mail!';

  @override
  String get forgotPasswordBody => 'Check your email for a password reset link.';

  @override
  String get exitCreateAccountTitle => 'Return to login';

  @override
  String get exitCreateAccountBody => 'Are you sure you want to go back? your information will be deleted.';

  @override
  String get stay => 'Stay';

  @override
  String get go => 'Go Back';

  @override
  String get tryAgain => 'Try Again';

  @override
  String get signUp => 'Sign Up';

  @override
  String get forgotPassword => 'Forgot Password?';

  @override
  String get passwordLen => 'Between 8 and 32 characters.';

  @override
  String get passwordLower => 'Contains a lowercase letter';

  @override
  String get passwordUpper => 'Contains a uppercase letter';

  @override
  String get passwordNumber => 'Contains a number';

  @override
  String get passwordSpecial => 'Contains a special character';

  @override
  String get passwordMatch => 'Passwords match';

  @override
  String get close => 'Close';

  @override
  String get likes => 'Likes';

  @override
  String get followers => 'Followers';

  @override
  String get following => 'Following';

  @override
  String get editProfile => 'Edit Profile';

  @override
  String get firstName => 'First Name';

  @override
  String get lastName => 'Last Name';

  @override
  String get userName => 'Username';

  @override
  String get previous => 'Previous';

  @override
  String get postTitle => 'Title';

  @override
  String get postBody => 'Body';

  @override
  String get newLines => 'New Lines';

  @override
  String get characters => 'Characters';

  @override
  String get postButton => 'POST';

  @override
  String get tooManyChar => 'Too many characters.';

  @override
  String get tooManyLine => 'Too many newlines.';

  @override
  String get emptyFieldError => 'Make sure all feilds are filled.';
}
