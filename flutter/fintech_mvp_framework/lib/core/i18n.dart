// lib/core/i18n.dart
import 'package:flutter/widgets.dart';
// 🔁 flutter_gen 경로가 아니라, 우리가 지정한 output-dir 경로로 임포트
import '../l10n/generated/app_localizations.dart';

extension T on BuildContext {
  AppLocalizations get t => AppLocalizations.of(this)!;
}
