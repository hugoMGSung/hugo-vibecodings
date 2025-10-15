// add_habit_screen.dart

// 1. cloud_firestore 라이브러리 가져오기
import 'package:cloud_firestore/cloud_firestore.dart';
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
            onPressed: () async {
              // 만약 습관 이름이 비어있다면 저장하지 않기 (사용자 실수 방지)
              if (_habitNameController.text.isEmpty) {
                print("습관 이름이 비어있습니다.");
                return; // 함수 종료
              }

              try {
                // 2. 데이터 저장이 끝날 때까지 여기서 '기다리세요' (await)
                final docRef = await FirebaseFirestore.instance.collection('habits').add({
                  'name': _habitNameController.text,
                  'category': _selectedCategory,
                  'cycle': _selectedCycle,
                  'createdAt': Timestamp.now(),
                  'isCompleted': false, // 👈 이 필드를 추가해주세요! (초기값은 false)
                });

                // 🔥 성공했을 때! (await이 끝났다는 건 성공했다는 의미)
                print("데이터 저장 성공! Document ID: ${docRef.id}");

                // 3. 저장이 '완전히 끝난 후'에 화면을 닫으세요.
                // 이 코드는 이제 안전하게 항상 저장 후에만 실행됩니다.
                if (mounted) { // 위젯이 아직 화면에 있는지 확인하는 습관
                  Navigator.pop(context);
                }
              } catch (error) {
                // 💣 실패했을 때!
                print("데이터 저장 실패: $error");
                // 여기서 사용자에게 에러가 났다고 알려주는 UI를 보여주면 더 좋습니다.
              }
            },
            child: Text(
              '저장',
              style: TextStyle(
                // Colors.white 대신 앱의 기본 테마 색상이나 다른 잘 보이는 색으로 변경
                color: Theme.of(context).primaryColor,
                fontSize: 16,
              ),
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