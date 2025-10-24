import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../game/puzzles/number_sum_puzzle.dart';
import '../../game/base_puzzle_game.dart';
import '../../features/tutorial/tutorial_overlay.dart';

import '../../l10n/generated/app_localizations.dart';
import '../../core/i18n.dart'; // (위 확장 사용 시)

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
      // const SettingsStub(), // 설정 부분 삭제
    ];

    Widget body;
      switch (bottomIndex) {
        case 0:
          body = _MainTab(
            onPlayDaily: () => _startDaily(context),
            onPlayLevel1: () => _startLevel(context, 1),
          );
          break;
        case 1:
          body = const AwardsTab();
          break;
        default:
          body = const SizedBox.shrink();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(context.t.appTitle),
        actions: [
          IconButton(onPressed: () => showTutorial(context), icon: const Icon(Icons.help_outline)),
        ],
      ),
      //body: tabs[bottomIndex],
      body: body,
      // bottomNavigationBar: NavigationBar(
      //   selectedIndex: bottomIndex,
      //   onDestinationSelected: (i) => setState(() => bottomIndex = i),
      bottomNavigationBar: NavigationBar(
        selectedIndex: bottomIndex,
        onDestinationSelected: (i) async {
          if (i == 2) {
            // 설정은 별도 화면으로 푸시
            await context.push('/settings');
            if (mounted) setState(() => bottomIndex = 0); // 돌아오면 메인 탭으로
            } else {
              setState(() => bottomIndex = i);
            }
          },
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home), label: '메인'),
          NavigationDestination(icon: Icon(Icons.emoji_events_outlined), selectedIcon: Icon(Icons.emoji_events), label: '일일 도전'),
          NavigationDestination(icon: Icon(Icons.settings_outlined), selectedIcon: Icon(Icons.settings), label: '설정'),
        ],
      ),
    );
  }

  void _startDaily(BuildContext context) {
    final seed = DateTime.now().toIso8601String().substring(0, 10);
    Navigator.of(context).push(MaterialPageRoute(
      builder: (_) => PuzzleGameScreen(
        title: '일일 도전',
        generator: () => NumberSumPuzzle.daily(seed),   // ✅ 함수로 전달
      ),
    ));
  }

  void _startLevel(BuildContext context, int level) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (_) => PuzzleGameScreen(
        title: '레벨 $level',
        generator: () => NumberSumPuzzle.level(level), // ✅ 함수로 전달
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
                  FilledButton(onPressed: onPlayDaily, child: Text(context.t.play)),
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
