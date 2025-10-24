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
        title: Text(context.t.appTitle),  // 다국어 교체!
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
            await context.push('/settings');  // 이건 폴더 경로!
            if (mounted) setState(() => bottomIndex = 0); // 돌아오면 메인 탭으로
            } else {
              setState(() => bottomIndex = i);
            }
          },
        destinations: [
          NavigationDestination(
              icon: const Icon(Icons.home_outlined),
              selectedIcon: const Icon(Icons.home),
              label: context.t.tabHome,
          ),
          NavigationDestination(
              icon: const Icon(Icons.emoji_events_outlined),
              selectedIcon: const Icon(Icons.emoji_events),
              label: context.t.tabAwards,
          ),
          NavigationDestination(
              icon: const Icon(Icons.settings_outlined),
              selectedIcon: const Icon(Icons.settings),
              label: context.t.tabSettings,
          ),
        ],
      ),
    );
  }

  void _startDaily(BuildContext context) {
    final seed = DateTime.now().toIso8601String().substring(0, 10);
    Navigator.of(context).push(MaterialPageRoute(
      builder: (_) => PuzzleGameScreen(
        title: context.t.dailyTitle,                 // ✅ 다국어
        generator: () => NumberSumPuzzle.daily(seed),   // ✅ 함수로 전달
      ),
    ));
  }

  void _startLevel(BuildContext context, int level) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (_) => PuzzleGameScreen(
        title: context.t.levelN(level),              // ✅ 다국어(포지셔널)
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
                  Text(context.t.homeDaily, style: Theme.of(context).textTheme.titleLarge),  // 다국어
                  const SizedBox(height: 8),
                  FilledButton(onPressed: onPlayDaily, child: Text(context.t.play)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          Text(context.t.homeDaily, style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 12),
          //FilledButton(onPressed: onPlayLevel1, child: const Text('레벨 1')),
          FilledButton(onPressed: onPlayLevel1, child: Text(context.t.levelN(1))),
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
          // Text('어워드', style: Theme.of(context).textTheme.headlineSmall),
          Text(context.t.tabAwards, style: Theme.of(context).textTheme.titleLarge),  // 다국어 치환
          const SizedBox(height: 8),
          Text(context.t.awardsHint, style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: 16),
          FilledButton(onPressed: () => context.go('/awards'), child: Text(context.t.details)),
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
