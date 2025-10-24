import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/theme.dart';
import 'core/theme_controller.dart';
import 'app_router.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mode = ref.watch(themeModeProvider); // Light/Dark

    return MaterialApp.router(
      title: 'Number Sums',
      debugShowCheckedModeBanner: false,
      theme: appThemeLight(context),
      darkTheme: appThemeDark(context),
      themeMode: mode, // ← 전역 테마모드
      routerConfig: router,
    );
  }
}
