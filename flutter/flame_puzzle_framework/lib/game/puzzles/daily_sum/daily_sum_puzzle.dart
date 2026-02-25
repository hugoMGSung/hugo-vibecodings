import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';

import 'daily_sum_generator.dart'; // DailySumGenerator, DailySumData

class DailySumPuzzle extends FlameGame<World> with TapCallbacks {
  final List<int> numbers;
  final int target;

  DailySumPuzzle({required this.numbers, required this.target});

  static Future<FlameGame<World>> daily(String seed) async {
    final date = DateTime.parse(seed); // yyyy-MM-dd
    final data = DailySumGenerator.generate(
      date: date,
      cardCount: 8,
      minValue: 1,
      maxValue: 12,
      minSolutionSize: 2,
      maxSolutionSize: 4,
    );

    // return DailySumPuzzle(numbers: data.cards, target: data.target).._setup();
    return DailySumPuzzle(numbers: data.cards, target: data.target); // setup 호출 X
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    _setup();
  }

  void _setup() {
    // 이제 size.x, size.y 안전
    add(ScreenHitbox());

    // 예시: 타일 배치
    // 예시: 타일 배치
    final spacing = 12.0;
    final cols = 4;
    final tileW = (size.x - spacing * (cols + 1)) / cols;
    final tileH = tileW;

    for (int i = 0; i < numbers.length; i++) {
      final row = i ~/ cols;
      final col = i % cols;

      final x = spacing + col * (tileW + spacing) + tileW / 2;
      final y = 140 + row * (tileH + spacing) + tileH / 2;

      add(_Tile(numbers[i])
        ..position = Vector2(x, y)
        ..size = Vector2(tileW, tileH));
    }

    add(_HUD(target));
  }
}

class _Tile extends PositionComponent with TapCallbacks {
  final int value;
  bool selected = false;
  _Tile(this.value);

  @override
  Future<void> onLoad() async {
    anchor = Anchor.center;
  }

  @override
  void render(Canvas canvas) {
    final r = Rect.fromCenter(center: Offset.zero, width: size.x, height: size.y);
    final paint = Paint()
      ..color = selected ? const Color(0xFFE5F0FF) : Colors.white
      ..style = PaintingStyle.fill;
    final border = Paint()
      ..color = const Color(0xFF90A4AE)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    canvas.drawRRect(RRect.fromRectAndRadius(r, const Radius.circular(16)), paint);
    canvas.drawRRect(RRect.fromRectAndRadius(r, const Radius.circular(16)), border);

    final tp = TextPainter(
      text: TextSpan(
        text: '$value',
        style: const TextStyle(fontSize: 28, color: Colors.black87, fontWeight: FontWeight.w600),
      ),
      textDirection: TextDirection.ltr,
    )..layout();

    tp.paint(canvas, Offset(-tp.width / 2, -tp.height / 2));
  }

  @override
  void onTapDown(TapDownEvent event) {
    selected = !selected;
  }
}

class _HUD extends PositionComponent with HasGameRef<DailySumPuzzle> {
  final int target;
  _HUD(this.target);

  @override
  void render(Canvas canvas) {
    final sum = game.children
        .whereType<_Tile>()
        .where((t) => t.selected)
        .map((t) => t.value)
        .fold<int>(0, (a, b) => a + b);

    final solved = sum == target;
    final text = solved ? '✅ 성공! 목표: $target' : '목표: $target  선택 합: $sum';

    final tp = TextPainter(
      text: TextSpan(text: text, style: const TextStyle(fontSize: 18, color: Colors.black)),
      textDirection: TextDirection.ltr,
    )..layout();

    tp.paint(canvas, const Offset(16, 16));
  }
}