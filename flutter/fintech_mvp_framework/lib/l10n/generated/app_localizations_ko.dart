// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Korean (`ko`).
class AppLocalizationsKo extends AppLocalizations {
  AppLocalizationsKo([String locale = 'ko']) : super(locale);

  @override
  String get appTitle => '핀테크 리스크';

  @override
  String get homeDaily => '포트폴리오';

  @override
  String get play => '분석하기';

  @override
  String levelN(Object level) {
    return '레벨 $level';
  }

  @override
  String get tabHome => '메인';

  @override
  String get tabAwards => '인사이트';

  @override
  String get tabSettings => '설정';

  @override
  String get tutorialTitle => '작동 방식';

  @override
  String get tutorialBody => '이 MVP는 가격 데이터 없이(규칙 기반) 포트폴리오 쏠림 위험을 점수로 보여줍니다.';

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
  String get awardsTitle => '노트';

  @override
  String get awardsHint => '종목/비중을 입력하면 위험 점수를 보여주는 최소 기능(MVP)입니다.';

  @override
  String get details => '열기';

  @override
  String get dailyTitle => '위험 점수';

  @override
  String get loading => '종목을 추가해 시작하세요.';
}
