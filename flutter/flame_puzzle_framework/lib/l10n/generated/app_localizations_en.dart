// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Number Sums';

  @override
  String get homeDaily => 'Daily Challenge';

  @override
  String get play => 'Play';

  @override
  String levelN(Object level) {
    return 'Level $level';
  }

  @override
  String get tabHome => 'Home';

  @override
  String get tabAwards => 'Daily';

  @override
  String get tabSettings => 'Settings';

  @override
  String get tutorialTitle => 'How to Play';

  @override
  String get tutorialBody =>
      'Match tiles to reach the target sum. Toggle circle/X to mark candidates. (Tutorial 1/3)';

  @override
  String get consentTitle => 'Welcome!';

  @override
  String get consentBody =>
      'Please read and agree to the Terms and Privacy Policy. Otherwise, you can use limited options.';

  @override
  String get agree => 'Agree';

  @override
  String get options => 'Options';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get sound => 'Sound';

  @override
  String get darkMode => 'Dark Mode';

  @override
  String get autoSleep => 'Auto Sleep';

  @override
  String get showIntro => 'Show Intro';

  @override
  String get howToPlay => 'How to Play';

  @override
  String get help => 'Help';

  @override
  String get gameInfo => 'Game Info';

  @override
  String get privacyRights => 'Privacy Rights';

  @override
  String get privacyDefaults => 'Privacy Defaults';

  @override
  String get removeAds => 'Remove Ads';

  @override
  String get awardsTitle => 'Awards';

  @override
  String get awardsHint => 'Show monthly/event progress here.';

  @override
  String get details => 'Details';

  @override
  String get dailyTitle => 'Daily Challenge';

  @override
  String get loading => 'Loading...';
}
