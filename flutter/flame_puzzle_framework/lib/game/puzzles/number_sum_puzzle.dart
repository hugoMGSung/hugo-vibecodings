import 'dart:math';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import 'package:flame/events.dart';  // 추가

/// Very small sample puzzle: select tiles to match a target sum.
class NumberSumPuzzle extends FlameGame<World> with TapCallbacks {  // version up, class change
  final List<int> numbers;
  final int target;

  NumberSumPuzzle({required this.numbers, required this.target});

  static Future<FlameGame> daily(String seed) async {
    final r = Random(seed.hashCode);
    final numbers = List.generate(5, (_) => r.nextInt(5) + 1);
    final target = numbers.take(3).reduce((a, b) => a + b);
    return NumberSumPuzzle(numbers: numbers, target: target).._setup();
  }

  static Future<FlameGame> level(int level) async {
    final r = Random(level);
    final numbers = List.generate(5 + level, (_) => r.nextInt(9) + 1);
    final target = numbers.take(3).reduce((a, b) => a + b);
    return NumberSumPuzzle(numbers: numbers, target: target).._setup();
  }

  void _setup() {
    add(ScreenHitbox());
    final w = size.x;
    final spacing = 8.0;
    final tileSize = (w - spacing * (numbers.length + 1)) / numbers.length;
    var x = spacing;
    for (var i = 0; i < numbers.length; i++) {
      add(_Tile(numbers[i])..position = Vector2(x, size.y / 2)..size = Vector2(tileSize, tileSize));
      x += tileSize + spacing;
    }
    add(_HUD(target));
  }
}

class _Tile extends PositionComponent with TapCallbacks {  // version up, class change
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
      text: TextSpan(text: '$value', style: const TextStyle(fontSize: 28, color: Colors.black87, fontWeight: FontWeight.w600)),
      textDirection: TextDirection.ltr,
    )..layout();
    tp.paint(canvas, Offset(-tp.width / 2, -tp.height / 2));
  }

  @override
  void onTapDown(TapDownEvent event) {
    selected = !selected;
    // event.handled = true; // (선택) 이벤트 소비 표시
  }
}

class _HUD extends PositionComponent with HasGameRef<NumberSumPuzzle> {
  final int target;
  _HUD(this.target);

  @override
  void render(Canvas canvas) {
    final sum = (game.children.whereType<_Tile>().where((t) => t.selected).map((t) => t.value).fold<int>(0, (a, b) => a + b));
    final text = '목표: $target  선택 합: $sum';
    final tp = TextPainter(
      text: TextSpan(text: text, style: const TextStyle(fontSize: 18, color: Colors.black)),
      textDirection: TextDirection.ltr,
    )..layout();
    tp.paint(canvas, const Offset(16, 16));
  }
}
