// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Korean (`ko`).
class AppLocalizationsKo extends AppLocalizations {
  AppLocalizationsKo([String locale = 'ko']) : super(locale);

  @override
  String get appTitle => '숫자 총합';

  @override
  String get homeDaily => '일일 도전';

  @override
  String get play => '플레이';

  @override
  String levelN(Object level) {
    return '레벨 $level';
  }

  @override
  String get tabHome => '메인';

  @override
  String get tabAwards => '일일 도전';

  @override
  String get tabSettings => '설정';

  @override
  String get tutorialTitle => '플레이 방법';

  @override
  String get tutorialBody =>
      '목표 숫자에 맞게 타일들의 합을 맞추세요. 원/엑스 토글로 후보를 표시할 수 있어요. (튜토리얼 1/3)';

  @override
  String get consentTitle => '환영합니다!';

  @override
  String get consentBody =>
      '앱의 약관과 개인정보 처리방침을 읽고 동의해주세요. 동의하지 않으면 옵션 보기를 통해 제한적으로 이용할 수 있습니다.';

  @override
  String get agree => '동의';

  @override
  String get options => '옵션 보기';

  @override
  String get settingsTitle => '설정';

  @override
  String get sound => '사운드';

  @override
  String get darkMode => '다크 모드';

  @override
  String get autoSleep => '자동 잠금';

  @override
  String get showIntro => '소개 표시';

  @override
  String get howToPlay => '플레이 방법';

  @override
  String get help => '도움말';

  @override
  String get gameInfo => '게임 정보';

  @override
  String get privacyRights => '개인 정보 보호 권리';

  @override
  String get privacyDefaults => '개인정보 기본 설정';

  @override
  String get removeAds => '광고 제거';

  @override
  String get awardsTitle => '어워드';

  @override
  String get awardsHint => '월별/이벤트 기반 도전 진행도를 여기에 표시하세요.';

  @override
  String get details => '자세히';

  @override
  String get dailyTitle => '일일 도전';

  @override
  String get loading => '로딩 중...';
}
