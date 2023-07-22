import 'app_localizations.dart';

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get email => 'Email';

  @override
  String get password => 'Password';

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
  String get tooManyRequestsTittle => 'Too Much Traffic';

  @override
  String get tooManyRequestsBody => 'We\'re sorry! Our servers are full at the moment, please try again another time.';

  @override
  String get userDisabledTittle => 'Account Disabled';

  @override
  String get userDisabledBody => 'Your account has been disabled. Please contact us at conetechnologiesdev@gmail.com.';

  @override
  String get defaultErrorTittle => 'Something Went Wrong';

  @override
  String get defaultErrorBody => 'Please try again later or reach out to conetechnologiesdev@gmail.com';

  @override
  String get tryAgain => 'Try Again';

  @override
  String get signUp => 'Sign Up';

  @override
  String get forgotPassword => 'Forgot Password?';

  @override
  String get forgotPasswordTittle => 'You\'ve Got Mail!';

  @override
  String get forgotPasswordBody => 'Check your email for a password reset link.';

  @override
  String get channelErrorBody => 'Make sure you entered an email in the correct feild.';

  @override
  String get close => 'Close';
}
