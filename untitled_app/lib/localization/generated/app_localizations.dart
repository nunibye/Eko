import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('es')
  ];

  /// No description provided for @post.
  ///
  /// In en, this message translates to:
  /// **'Post'**
  String get post;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @confirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get confirmPassword;

  /// No description provided for @logIn.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get logIn;

  /// No description provided for @invalidUserName.
  ///
  /// In en, this message translates to:
  /// **'Username does not meet requirements'**
  String get invalidUserName;

  /// No description provided for @available.
  ///
  /// In en, this message translates to:
  /// **'Available'**
  String get available;

  /// No description provided for @usernameInUse.
  ///
  /// In en, this message translates to:
  /// **'Username Unavilable'**
  String get usernameInUse;

  /// No description provided for @usernameTakenTitle.
  ///
  /// In en, this message translates to:
  /// **'This Username has been taken.'**
  String get usernameTakenTitle;

  /// No description provided for @usernameTakenBody.
  ///
  /// In en, this message translates to:
  /// **'Please go back and choose a diffrent username.'**
  String get usernameTakenBody;

  /// No description provided for @invalidEmailTittle.
  ///
  /// In en, this message translates to:
  /// **'Invalid Email Formating'**
  String get invalidEmailTittle;

  /// No description provided for @invalidEmailBody.
  ///
  /// In en, this message translates to:
  /// **'Please check your email and try again.'**
  String get invalidEmailBody;

  /// No description provided for @userNotFoundTitle.
  ///
  /// In en, this message translates to:
  /// **'Can\'t Find Account'**
  String get userNotFoundTitle;

  /// No description provided for @userNotFoundBody.
  ///
  /// In en, this message translates to:
  /// **'We can\'t find an account with that email. Try another email, or sign up.'**
  String get userNotFoundBody;

  /// No description provided for @wrongPasswordTittle.
  ///
  /// In en, this message translates to:
  /// **'Incorrect Password'**
  String get wrongPasswordTittle;

  /// No description provided for @wrongPasswordBody.
  ///
  /// In en, this message translates to:
  /// **'The password you entered is incorrect.'**
  String get wrongPasswordBody;

  /// No description provided for @userDisabledTittle.
  ///
  /// In en, this message translates to:
  /// **'Account Disabled'**
  String get userDisabledTittle;

  /// No description provided for @userDisabledBody.
  ///
  /// In en, this message translates to:
  /// **'Your account has been disabled. Please contact us at conetechnologiesdev@gmail.com.'**
  String get userDisabledBody;

  /// No description provided for @weakPasswordTitle.
  ///
  /// In en, this message translates to:
  /// **'Weak Password'**
  String get weakPasswordTitle;

  /// No description provided for @weakPasswordBody.
  ///
  /// In en, this message translates to:
  /// **'Check password requirements and try again.'**
  String get weakPasswordBody;

  /// No description provided for @defaultErrorTittle.
  ///
  /// In en, this message translates to:
  /// **'Something Went Wrong'**
  String get defaultErrorTittle;

  /// No description provided for @defaultErrorBody.
  ///
  /// In en, this message translates to:
  /// **'Please try again later or reach out to conetechnologiesdev@gmail.com.'**
  String get defaultErrorBody;

  /// No description provided for @emailAlreadyInUseTitle.
  ///
  /// In en, this message translates to:
  /// **'Email Already In-Use'**
  String get emailAlreadyInUseTitle;

  /// No description provided for @emailAlreadyInUseBody.
  ///
  /// In en, this message translates to:
  /// **'An account with that email already exists'**
  String get emailAlreadyInUseBody;

  /// No description provided for @forgotPasswordTittle.
  ///
  /// In en, this message translates to:
  /// **'You\'ve Got Mail!'**
  String get forgotPasswordTittle;

  /// No description provided for @forgotPasswordBody.
  ///
  /// In en, this message translates to:
  /// **'Check your email for a password reset link.'**
  String get forgotPasswordBody;

  /// No description provided for @exitCreateAccountTitle.
  ///
  /// In en, this message translates to:
  /// **'Return to welcome page'**
  String get exitCreateAccountTitle;

  /// No description provided for @exitCreateAccountBody.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to go back? your information will be deleted.'**
  String get exitCreateAccountBody;

  /// No description provided for @exitEditProfileTitle.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to exit?'**
  String get exitEditProfileTitle;

  /// No description provided for @exitEditProfileBody.
  ///
  /// In en, this message translates to:
  /// **'All changes will be lost.'**
  String get exitEditProfileBody;

  /// No description provided for @stay.
  ///
  /// In en, this message translates to:
  /// **'Stay'**
  String get stay;

  /// No description provided for @exit.
  ///
  /// In en, this message translates to:
  /// **'Exit'**
  String get exit;

  /// No description provided for @goBack.
  ///
  /// In en, this message translates to:
  /// **'Go Back'**
  String get goBack;

  /// No description provided for @tryAgain.
  ///
  /// In en, this message translates to:
  /// **'Try Again'**
  String get tryAgain;

  /// No description provided for @signUp.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get signUp;

  /// No description provided for @forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password?'**
  String get forgotPassword;

  /// No description provided for @passwordLen.
  ///
  /// In en, this message translates to:
  /// **'Between 8 and 32 characters.'**
  String get passwordLen;

  /// No description provided for @passwordLower.
  ///
  /// In en, this message translates to:
  /// **'Contains a lowercase letter'**
  String get passwordLower;

  /// No description provided for @passwordUpper.
  ///
  /// In en, this message translates to:
  /// **'Contains a uppercase letter'**
  String get passwordUpper;

  /// No description provided for @passwordNumber.
  ///
  /// In en, this message translates to:
  /// **'Contains a number'**
  String get passwordNumber;

  /// No description provided for @passwordSpecial.
  ///
  /// In en, this message translates to:
  /// **'Contains a special character'**
  String get passwordSpecial;

  /// No description provided for @passwordMatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords match'**
  String get passwordMatch;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @likes.
  ///
  /// In en, this message translates to:
  /// **'Likes'**
  String get likes;

  /// No description provided for @follow.
  ///
  /// In en, this message translates to:
  /// **'Follow'**
  String get follow;

  /// No description provided for @followers.
  ///
  /// In en, this message translates to:
  /// **'Followers'**
  String get followers;

  /// No description provided for @following.
  ///
  /// In en, this message translates to:
  /// **'Following'**
  String get following;

  /// No description provided for @editProfile.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get editProfile;

  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// No description provided for @userName.
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get userName;

  /// No description provided for @previous.
  ///
  /// In en, this message translates to:
  /// **'Previous'**
  String get previous;

  /// No description provided for @followingTab.
  ///
  /// In en, this message translates to:
  /// **'Following'**
  String get followingTab;

  /// No description provided for @popularTab.
  ///
  /// In en, this message translates to:
  /// **'Popular'**
  String get popularTab;

  /// No description provided for @newTab.
  ///
  /// In en, this message translates to:
  /// **'New'**
  String get newTab;

  /// No description provided for @oldTab.
  ///
  /// In en, this message translates to:
  /// **'Old'**
  String get oldTab;

  /// No description provided for @postTitle.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get postTitle;

  /// No description provided for @postBody.
  ///
  /// In en, this message translates to:
  /// **'Body'**
  String get postBody;

  /// No description provided for @newLines.
  ///
  /// In en, this message translates to:
  /// **'New Lines'**
  String get newLines;

  /// No description provided for @characters.
  ///
  /// In en, this message translates to:
  /// **'Characters'**
  String get characters;

  /// No description provided for @postButton.
  ///
  /// In en, this message translates to:
  /// **'POST'**
  String get postButton;

  /// No description provided for @tooManyChar.
  ///
  /// In en, this message translates to:
  /// **'Too many characters.'**
  String get tooManyChar;

  /// No description provided for @tooManyLine.
  ///
  /// In en, this message translates to:
  /// **'Too many newlines.'**
  String get tooManyLine;

  /// No description provided for @emptyFieldError.
  ///
  /// In en, this message translates to:
  /// **'Make sure all feilds are filled.'**
  String get emptyFieldError;

  /// No description provided for @bioTitle.
  ///
  /// In en, this message translates to:
  /// **'Bio'**
  String get bioTitle;

  /// No description provided for @logOut.
  ///
  /// In en, this message translates to:
  /// **'Log Out'**
  String get logOut;

  /// No description provided for @deleteAccount.
  ///
  /// In en, this message translates to:
  /// **'Delete Account'**
  String get deleteAccount;

  /// No description provided for @darkMode.
  ///
  /// In en, this message translates to:
  /// **'Dark Mode'**
  String get darkMode;

  /// No description provided for @addComment.
  ///
  /// In en, this message translates to:
  /// **'Add a comment'**
  String get addComment;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @welcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome'**
  String get welcome;

  /// No description provided for @welcomeTo.
  ///
  /// In en, this message translates to:
  /// **'Welcome to'**
  String get welcomeTo;

  /// No description provided for @welcomeBack.
  ///
  /// In en, this message translates to:
  /// **'Welcome Back'**
  String get welcomeBack;

  /// No description provided for @createAccount.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get createAccount;

  /// No description provided for @createAnAccount.
  ///
  /// In en, this message translates to:
  /// **'Create an Account'**
  String get createAnAccount;

  /// No description provided for @cont.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get cont;

  /// No description provided for @dateOfBirth.
  ///
  /// In en, this message translates to:
  /// **'Date of Birth'**
  String get dateOfBirth;

  /// No description provided for @createAPassword.
  ///
  /// In en, this message translates to:
  /// **'Create a Password'**
  String get createAPassword;

  /// No description provided for @deleteAcountTitle.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete your account?'**
  String get deleteAcountTitle;

  /// No description provided for @deleteAcountBody.
  ///
  /// In en, this message translates to:
  /// **'All account data will be deleted. This action cannot be undone. Press \"Go Back\" to cancel'**
  String get deleteAcountBody;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @searchUsername.
  ///
  /// In en, this message translates to:
  /// **'Search username...'**
  String get searchUsername;

  /// No description provided for @noResultsFound.
  ///
  /// In en, this message translates to:
  /// **'No results found.'**
  String get noResultsFound;

  /// No description provided for @confirmation.
  ///
  /// In en, this message translates to:
  /// **'Confirmation'**
  String get confirmation;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @resetPassword.
  ///
  /// In en, this message translates to:
  /// **'Reset Password'**
  String get resetPassword;

  /// No description provided for @sendResetLink.
  ///
  /// In en, this message translates to:
  /// **'Send reset link'**
  String get sendResetLink;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'Ok'**
  String get ok;

  /// No description provided for @recentActivity.
  ///
  /// In en, this message translates to:
  /// **'Recent Activity'**
  String get recentActivity;

  /// No description provided for @nothingToSeeHere.
  ///
  /// In en, this message translates to:
  /// **'Nothing to see here!'**
  String get nothingToSeeHere;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'es'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return AppLocalizationsEn();
    case 'es': return AppLocalizationsEs();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
