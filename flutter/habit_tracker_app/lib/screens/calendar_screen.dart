// calendar_screen.dart

import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart'; // 방금 설치한 라이브러리 가져오기

import 'package:cloud_firestore/cloud_firestore.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  // 달력의 상태를 관리할 변수들
  DateTime _focusedDay = DateTime.now(); // 현재 보고 있는 날짜
  DateTime? _selectedDay; // 사용자가 선택한 날짜

  // 🔥 1. 완료된 습관들을 날짜별로 저장할 Map 변수 추가!
  // 예: { 2023-10-27: ['운동하기', '책읽기'], 2023-10-28: ['물마시기'] }
  Map<DateTime, List<String>> _completedHabits = {};

  // 🔥 1. 선택된 날짜의 완료 습관 목록을 저장할 변수 추가!
  List<String> _selectedDayHabits = [];

  @override
  void initState() {
    super.initState();
    _loadCompletedHabits(); // 화면이 시작될 때 데이터를 불러옵니다.
  }

  // 🔥 2. Firestore에서 완료된 습관 데이터를 불러와 _completedHabits 변수에 채우는 함수
  void _loadCompletedHabits() async {
    // 1. Firestore의 'habits' 컬렉션에 접근
    final snapshot = await FirebaseFirestore.instance
        .collection('habits')
        .where('isCompleted', isEqualTo: true) // 2. isCompleted가 true인 문서만 필터링
        .get();

    // 3. 불러온 데이터(snapshot.docs)를 날짜별로 정리
    Map<DateTime, List<String>> newEvents = {};
    for (var doc in snapshot.docs) {
      final data = doc.data();
      // Firestore의 Timestamp를 Dart의 DateTime으로 변환
      final DateTime completedDate = (data['createdAt'] as Timestamp).toDate();
      // 날짜의 '시/분/초'를 무시하고 '년/월/일'만 사용 (중요!)
      final normalizedDate = DateTime.utc(completedDate.year, completedDate.month, completedDate.day);
      final habitName = data['name'];

      if (newEvents[normalizedDate] == null) {
        newEvents[normalizedDate] = []; // 해당 날짜에 목록이 없으면 새로 만들어주기
      }
      newEvents[normalizedDate]!.add(habitName); // 해당 날짜 목록에 습관 이름 추가
    }

    // 4. 정리된 데이터를 화면에 반영 (setState)
    setState(() {
      _completedHabits = newEvents;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('나의 습관 달력'),
      ),
      body: Column( // 👈 Column으로 전체를 감싸줍니다.
        children: [
          // 1. 달력 위젯
          TableCalendar(
            firstDay: DateTime.utc(2020, 1, 1),
            lastDay: DateTime.utc(2030, 12, 31),
            focusedDay: _focusedDay,
            eventLoader: (day) {
              final normalizedDay = DateTime.utc(day.year, day.month, day.day);
              return _completedHabits[normalizedDay] ?? [];
            },
            // 아이콘 추가
            // 🔥 1. 달력의 각 부분을 직접 꾸밀 수 있는 calendarBuilders 속성을 추가합니다.
            calendarBuilders: CalendarBuilders(
              // 🔥 2. 날짜 밑의 마커(점)를 꾸미는 markerBuilder를 정의합니다.
              markerBuilder: (context, day, events) {
                // eventLoader에서 반환된 목록(events)이 비어있지 않다면
                if (events.isNotEmpty) {
                  // 기본 점 대신 우리가 원하는 위젯을 보여줍니다.
                  return Positioned(
                    right: 1,
                    bottom: 1,
                    child: Text(
                      '✨',
                      style: TextStyle(fontSize: 16), // 아이콘 크기 조절
                    ),
                  );
                }
                // 이벤트가 없다면 아무것도 보여주지 않습니다.
                return null;
              },
            ),

            selectedDayPredicate: (day) {
              return isSameDay(_selectedDay, day);
            },
            onDaySelected: (selectedDay, focusedDay) {
              final normalizedDay = DateTime.utc(selectedDay.year, selectedDay.month, selectedDay.day);
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
                _selectedDayHabits = _completedHabits[normalizedDay] ?? [];
              });
            },
          ),

          // 구분선
          const SizedBox(height: 8.0),

          // 🔥 3. 선택된 날짜의 습관 목록을 보여줄 ListView 추가!
          Expanded(
            child: ListView.builder(
              itemCount: _selectedDayHabits.length,
              itemBuilder: (context, index) {
                return Card( // Card로 감싸서 보기 좋게 만듭니다.
                  margin: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
                  child: ListTile(
                    leading: Icon(Icons.check_circle, color: Colors.green),
                    title: Text(_selectedDayHabits[index]),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}