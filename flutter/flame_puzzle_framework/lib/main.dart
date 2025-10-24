import 'package:flutter/material.dart';                     // Flutter 기본 라이브러리
import 'package:flutter_riverpod/flutter_riverpod.dart';    // 전역 상태관리 (ProviderScope 사용)
import 'core/theme.dart';                                   // 앱 전체 테마 정의
import 'app_router.dart';                                   // 화면 라우팅 설정 (동의 → 홈 → 설정 → 어워드)

// 앱 실행의 진입점 (main 함수)
void main() {
  WidgetsFlutterBinding.ensureInitialized();        // Flutter 엔진 초기화
  runApp(const ProviderScope(child: MyApp()));      // 전역 상태 컨테이너 ProviderScope로 감싸서 앱 실행
}

/// 앱 전체 위젯의 루트 클래스
/// - MaterialApp.router를 사용하여 라우팅을 구성함
/// - 앱 테마와 네비게이션 구성을 함께 설정
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Number Sums',                       // 앱 이름
      debugShowCheckedModeBanner: false,          // 상단 "debug" 배너 제거
      theme: appTheme(context),                   // core/theme.dart에서 정의한 테마 적용
      routerConfig: router,                       // app_router.dart의 GoRouter 객체
    );
  }
}
