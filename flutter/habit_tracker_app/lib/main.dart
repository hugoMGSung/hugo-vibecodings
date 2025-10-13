// main.dart

import 'package:flutter/material.dart';
// 1. 우리가 만든 main_screen.dart 파일을 가져오는 코드예요.
//    경로는 실제 파일 위치에 맞게 조절해야 할 수도 있어요.
import 'screens/main_screen.dart';

// 2. 모든 Dart 프로그램의 시작점! main 함수예요.
void main() {
  runApp(const MyApp());
}

// 3. 우리 앱의 전체적인 틀을 잡아주는 위젯이에요.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // 4. MaterialApp은 구글의 머티리얼 디자인을 적용해주는 고마운 위젯이에요.
    return MaterialApp(
      title: '습관 트래커', // 앱의 전체적인 이름
      theme: ThemeData(
        // 앱의 기본 색상 테마 등을 여기서 정할 수 있어요.
        primarySwatch: Colors.teal,
        useMaterial3: true,
      ),
      // 5. 가장 중요! 우리 앱의 첫 화면(집)은 MainScreen이야!
      home: MainScreen(),
    );
  }
}