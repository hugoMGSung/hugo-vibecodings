// main_screen.dart

import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart'; // 👈 1. FCM 라이브러리 import
import 'package:flutter/material.dart';

import 'add_habit_screen.dart';
import 'calendar_screen.dart';

// 1. StatelessWidget에서 StatefulWidget으로 변경합니다.
class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  // 2. 화면이 '짠!'하고 나타날 때 딱 한 번 실행되는 initState 추가
  @override
  void initState() {
    super.initState();

    // 🔥 2. initState에 이 함수 호출 코드를 추가합니다.
    _requestNotificationPermission();

    // initState가 끝난 후, 첫 프레임이 그려진 직후에 코드를 실행하도록 예약합니다.
    // build가 완료된 후에 context를 사용해야 안전하기 때문입니다.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showCheeringMessageIfNeeded();
    });
  }

  // 🔥 3. 알림 권한을 요청하는 함수를 새로 만듭니다.
  void _requestNotificationPermission() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    print('사용자에게 받은 알림 권한: ${settings.authorizationStatus}');
  }


  // 🔥 3. 응원 메시지를 보낼지 말지 결정하고, 필요하면 보여주는 함수
  void _showCheeringMessageIfNeeded() async {
    // 1) 어제 날짜 계산하기
    final now = DateTime.now();
    final yesterdayStart = DateTime(now.year, now.month, now.day - 1); // 어제 시작
    final yesterdayEnd = DateTime(now.year, now.month, now.day - 1, 23, 59, 59); // 어제 끝

    // 2) Firestore에서 '어제 생성됐지만 완료는 안 된' 습관이 있는지 확인
    final snapshot = await FirebaseFirestore.instance
        .collection('habits')
        .where('createdAt', isGreaterThanOrEqualTo: yesterdayStart)
        .where('createdAt', isLessThanOrEqualTo: yesterdayEnd)
        .where('isCompleted', isEqualTo: false)
        .limit(1) // 1개만 찾으면 되므로 limit(1)로 효율적으로 조회
        .get();

    // 3) 만약 그런 습관이 1개라도 있다면 (snapshot.docs가 비어있지 않다면)
    if (snapshot.docs.isNotEmpty) {
      // 응원 메시지를 스낵바로 보여주기
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("어제는 아쉬웠지만, 오늘은 해낼 수 있어요! 🔥"),
          duration: Duration(seconds: 3),
        ),
      );
    }
  }

  // 4. 기존의 build 메소드는 그대로 가져옵니다.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('나의 습관 트래커'),
        actions: [
          IconButton(
            icon: Icon(Icons.calendar_today),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CalendarScreen()),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddHabitScreen()),
              );
            },
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('habits')
            .orderBy('createdAt')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text("아직 등록된 습관이 없어요.\n새 습관을 추가해보세요! 💪"));
          }
          final habitDocs = snapshot.data!.docs;
          return ListView.builder(
            itemCount: habitDocs.length,
            itemBuilder: (context, index) {
              final habit = habitDocs[index];
              final String docId = habit.id;
              final habitName = habit['name'];
              final bool isCompleted = habit['isCompleted'] ?? false;
              return ListTile(
                title: Text(
                  habitName,
                  style: TextStyle(
                    decoration:
                    isCompleted ? TextDecoration.lineThrough : null,
                  ),
                ),
                trailing: Checkbox(
                  value: isCompleted,
                  onChanged: (bool? newValue) {
                    if (newValue != null) {
                      FirebaseFirestore.instance
                          .collection('habits')
                          .doc(docId)
                          .update({'isCompleted': newValue});
                      if (newValue == true) {
                        final List<String> successMessages = [
                          "오늘도 해냈군요! 정말 대단해요! 🎉",
                          "목표 달성! 멋진 하루예요.",
                          "정상에 한 걸음 더 가까워졌어요! 🚀",
                          "이 꾸준함, 정말 멋져요!",
                          "최고예요! 스스로를 칭찬해주세요. ✨",
                        ];
                        final randomMessage = successMessages[
                        Random().nextInt(successMessages.length)];
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(randomMessage),
                            duration: Duration(seconds: 2),
                          ),
                        );
                      }
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