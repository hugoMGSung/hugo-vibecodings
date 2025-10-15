// main_screen.dart

// 1. cloud_firestore 라이브러리 가져오기
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'add_habit_screen.dart';
import 'calendar_screen.dart'; // 👈 1. 방금 만든 calendar_screen.dart를 import 하세요.

class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('나의 습관 트래커'),
        actions: [
          // 🔥 여기를 수정/추가하세요!
          IconButton(
            icon: Icon(Icons.calendar_today),
            onPressed: () {
              // 달력 화면으로 이동하는 코드
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CalendarScreen()),
              );
            },
          ),
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
      // body 부분을 이렇게 바꿔주세요.
      body: StreamBuilder<QuerySnapshot>(
        // 2. 어떤 데이터를 실시간으로 들을지 지정
        // 'habits' 컬렉션의 데이터를 'createdAt' 시간 순서대로 들을 거야!
        stream: FirebaseFirestore.instance.collection('habits').orderBy('createdAt').snapshots(),

        // 3. 데이터가 바뀔 때마다 이 builder 부분이 새로 실행돼요
        builder: (context, snapshot) {
          // 4. 데이터 로딩 중일 때
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator()); // 로딩 동그라미 보여주기
          }

          // 5. 데이터가 없을 때
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text("아직 등록된 습관이 없어요.\n새 습관을 추가해보세요! 💪"));
          }

          // 6. 데이터가 성공적으로 왔을 때!
          final habitDocs = snapshot.data!.docs; // 습관 목록 가져오기

          // ListView를 사용해서 목록을 그려줘요.
          return ListView.builder(
            itemCount: habitDocs.length, // 목록 개수
            itemBuilder: (context, index) {
              // habitDocs[index]에서 각 습관의 데이터를 꺼내요.
              final habit = habitDocs[index];
              final String docId = habit.id; // 🔥 업데이트에 꼭 필요한 문서의 고유 ID
              final habitName = habit['name']; // 'name' 필드의 값을 가져옴
              // 'isCompleted' 필드를 가져오되, 없으면(null) 기본값으로 false를 사용해요.
              final bool isCompleted = habit['isCompleted'] ?? false;

              return ListTile(
                title: Text(
                  habitName,
                  style: TextStyle(
                    // 완료된 항목은 취소선 표시
                    decoration: isCompleted ? TextDecoration.lineThrough : null,
                  ),
                ),
                trailing: Checkbox(
                  // ✅ 1. 체크박스의 값은 Firestore 문서의 'isCompleted' 값!
                  value: isCompleted,
                  // ✅ 2. 사용자가 체크박스를 누르면 상태를 Firestore에 업데이트!
                  onChanged: (bool? newValue) {
                    if (newValue != null) {
                      FirebaseFirestore.instance
                          .collection('habits')
                          .doc(docId) // 이 ID를 가진 문서를 찾아서
                          .update({'isCompleted': newValue}); // isCompleted 필드를 새 값으로 변경!
                    }
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}