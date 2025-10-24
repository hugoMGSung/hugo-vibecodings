import 'package:flame/game.dart';
import 'package:flame/components.dart'; // ← World 가져옴

import 'package:flutter/material.dart';

/// Boilerplate wrapper that mounts a FlameGame inside a Material screen.
class PuzzleGameScreen extends StatelessWidget {
  final String title;
  final Future<FlameGame<World>> Function() generator; // ✅ World 제네릭

  const PuzzleGameScreen({
    super.key,
    required this.title,
    required this.generator,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<FlameGame<World>>(
      future: generator(),
      builder: (context, snapshot) {
        final game = snapshot.data;
        return Scaffold(
          appBar: AppBar(title: Text(title)),
          body: game == null
              ? const Center(child: CircularProgressIndicator())
              : GameWidget(game: game),
        );
      },
    );
  }
}
