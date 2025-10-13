// main_screen.dart

import 'package:flutter/material.dart';

import 'add_habit_screen.dart';

class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('나의 습관 트래커'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              // 이 부분을 수정/추가하세요!
              // 1. add_habit_screen.dart를 import 해주세요.
              //    import '../screens/add_habit_screen.dart'; 파일 상단에 추가!
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddHabitScreen()),
              );
            },
          ),
        ],
      ),
      body: ListView(
        children: [
          // 나중에 이곳은 Firebase 데이터와 연결될 거예요!
          // 지금은 예시로 ListTile을 넣어봐요.
          ListTile(
            title: Text('아침 7시 기상 ☀️'),
            trailing: Checkbox(
              value: true, // 완료 여부
              onChanged: (bool? value) {
                // TODO: 체크 상태 변경 코드
              },
            ),
          ),
          ListTile(
            title: Text('책 15분 읽기 📚'),
            trailing: Checkbox(
              value: false,
              onChanged: (bool? value) {},
            ),
          ),
        ],
      ),
    );
  }
}