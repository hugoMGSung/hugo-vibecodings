import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'core/theme.dart';
import 'core/theme_controller.dart';
import 'core/locale_controller.dart';
import 'app_router.dart';

import 'l10n/generated/app_localizations.dart';


void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mode = ref.watch(themeModeProvider); // Light/Dark
    final locale = ref.watch(localeProvider); // null이면 시스템 따름

    return MaterialApp.router(
      title: 'Number Sums',
      debugShowCheckedModeBanner: false,
      theme: appThemeLight(context),
      darkTheme: appThemeDark(context),
      themeMode: mode, // ← 전역 테마모드
      routerConfig: router,

      locale: locale,                                  // ✅ 현재 선택 로케일
      supportedLocales: const [Locale('en'), Locale('ko')],
      localizationsDelegates: const [                 // ✅ 머스트
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
    );
  }
}
