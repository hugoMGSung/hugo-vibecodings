// add_habit_screen.dart

import 'package:flutter/material.dart';

class AddHabitScreen extends StatefulWidget {
  // StatefulWidget을 사용하는 이유:
  // 사용자가 입력하는 값(텍스트, 선택)을 화면에 바로바로 반영하고 기억해야 하기 때문이에요.
  @override
  _AddHabitScreenState createState() => _AddHabitScreenState();
}

class _AddHabitScreenState extends State<AddHabitScreen> {
  // 1. 사용자가 입력할 값들을 저장할 변수들을 미리 만들어 둬요.
  final _habitNameController = TextEditingController(); // 습관 이름을 위한 컨트롤러
  String _selectedCategory = '운동'; // 카테고리 기본 선택값
  String _selectedCycle = '매일'; // 주기 기본 선택값

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('새 습관 추가하기'),
        actions: [
          // 2. 저장 버튼! 아직 기능은 없지만 모양만 만들어 둬요.
          TextButton(
            onPressed: () {
              // TODO: Firebase에 습관 데이터 저장하는 로직 추가
              print('습관 이름: ${_habitNameController.text}');
              print('카테고리: $_selectedCategory');
              print('주기: $_selectedCycle');

              // 저장이 끝나면 이전 화면(메인 화면)으로 돌아가기
              Navigator.pop(context);
            },
            child: Text(
              '저장',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
        ],
      ),
      body: Padding(
        // 3. 화면 가장자리에 예쁜 여백을 줘요.
        padding: const EdgeInsets.all(16.0),
        child: Column(
          // 4. 위젯들을 세로로 차곡차곡 쌓아요.
          // crossAxisAlignment: CrossAxisAlignment.start는 왼쪽 정렬을 의미해요.
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 5. 습관 이름 입력칸
            TextField(
              controller: _habitNameController,
              decoration: InputDecoration(
                labelText: '습관 이름',
                hintText: '예: 아침에 스트레칭하기',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 24), // 위젯 사이에 적당한 간격 주기

            // 6. 카테고리 선택 메뉴
            Text('카테고리', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            DropdownButton<String>(
              value: _selectedCategory,
              isExpanded: true, // 너비를 꽉 채워요
              items: ['운동', '공부', '생활'].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) {
                // 7. 사용자가 다른 카테고리를 선택하면, 화면에 바로 반영해요.
                setState(() {
                  _selectedCategory = newValue!;
                });
              },
            ),
            SizedBox(height: 24),

            // 8. 주기 선택 메뉴 (카테고리와 동일한 구조예요)
            Text('주기', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            DropdownButton<String>(
              value: _selectedCycle,
              isExpanded: true,
              items: ['매일', '주 3회', '주말마다'].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedCycle = newValue!;
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}