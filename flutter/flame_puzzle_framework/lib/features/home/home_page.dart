import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../game/puzzles/number_sum_puzzle.dart';
import '../../game/base_puzzle_game.dart';
import '../../features/tutorial/tutorial_overlay.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int bottomIndex = 0;

  @override
  Widget build(BuildContext context) {
    final tabs = [
      _MainTab(onPlayDaily: () => _startDaily(context), onPlayLevel1: () => _startLevel(context, 1)),
      const AwardsTab(),
      const SettingsStub(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('숫자 총합'),
        actions: [
          IconButton(onPressed: () => showTutorial(context), icon: const Icon(Icons.help_outline)),
        ],
      ),
      body: tabs[bottomIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: bottomIndex,
        onDestinationSelected: (i) => setState(() => bottomIndex = i),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home), label: '메인'),
          NavigationDestination(icon: Icon(Icons.emoji_events_outlined), selectedIcon: Icon(Icons.emoji_events), label: '일일 도전'),
          NavigationDestination(icon: Icon(Icons.settings_outlined), selectedIcon: Icon(Icons.settings), label: '설정'),
        ],
      ),
    );
  }

  void _startDaily(BuildContext context) {
    final seed = DateTime.now().toIso8601String().substring(0, 10); // YYYY-MM-DD
    Navigator.of(context).push(MaterialPageRoute(
      builder: (_) => PuzzleGameScreen(
        title: '일일 도전',
        generator: NumberSumPuzzle.daily(seed),
      ),
    ));
  }

  void _startLevel(BuildContext context, int level) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (_) => PuzzleGameScreen(
        title: '레벨 $level',
        generator: NumberSumPuzzle.level(level),
      ),
    ));
  }
}

class _MainTab extends StatelessWidget {
  final VoidCallback onPlayDaily;
  final VoidCallback onPlayLevel1;
  const _MainTab({required this.onPlayDaily, required this.onPlayLevel1});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Text('일일 도전', style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 8),
                  FilledButton(onPressed: onPlayDaily, child: const Text('플레이')),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          Text('숫자 총합', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 12),
          FilledButton(onPressed: onPlayLevel1, child: const Text('레벨 1')),
        ],
      ),
    );
  }
}

class AwardsTab extends StatelessWidget {
  const AwardsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('어워드', style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 8),
          Text('월별/이벤트 기반 도전 진행도를 여기에 표시하세요.', style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: 16),
          FilledButton(onPressed: () => context.go('/awards'), child: const Text('자세히')),
        ],
      ),
    );
  }
}

class SettingsStub extends StatelessWidget {
  const SettingsStub({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FilledButton(onPressed: () => context.go('/settings'), child: const Text('설정 열기')),
    );
  }
}
