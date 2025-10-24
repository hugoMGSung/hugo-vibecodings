import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../services/storage/local_storage.dart';
import '../../core/theme_controller.dart';

class SettingsPage extends ConsumerStatefulWidget {
  const SettingsPage({super.key});

  @override
  ConsumerState<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends ConsumerState<SettingsPage> {
  bool sound = true;
  bool autoSleep = false;
  bool showIntro = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    sound = await LocalStorage.instance.getBool('sound') ?? true;
    autoSleep = await LocalStorage.instance.getBool('autoSleep') ?? false;
    showIntro = await LocalStorage.instance.getBool('showIntro') ?? true;
    if (mounted) setState(() {});
  }

  Future<void> _save(String key, bool value) async {
    await LocalStorage.instance.setBool(key, value);
  }

  @override
  Widget build(BuildContext context) {
    final themeCtrl = ref.watch(themeModeProvider); // 현재 모드
    final isDark = themeCtrl == ThemeMode.dark;

    return Scaffold(
      appBar: AppBar(title: const Text('설정')),
      body: ListView(
        children: [
          // 1) 사운드
          SwitchListTile(
            value: sound,
            title: const Text('사운드'),
            onChanged: (v) => setState(() {
              sound = v;
              _save('sound', v);
            }),
          ),
          // 2) 다크 모드 (사운드 바로 아래)
          SwitchListTile(
            value: isDark,
            title: const Text('다크 모드'),
            onChanged: (v) {
              ref.read(themeModeProvider.notifier).setDark(v);
              // 로컬에도 저장은 컨트롤러에서 처리 중
            },
          ),
          // 3) 자동 잠금
          SwitchListTile(
            value: autoSleep,
            title: const Text('자동 잠금'),
            onChanged: (v) => setState(() {
              autoSleep = v;
              _save('autoSleep', v);
            }),
          ),
          // 4) 소개 표시
          SwitchListTile(
            value: showIntro,
            title: const Text('소개 표시'),
            onChanged: (v) => setState(() {
              showIntro = v;
              _save('showIntro', v);
            }),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.menu_book_outlined),
            title: const Text('플레이 방법'),
            onTap: () => showAboutDialog(
              context: context,
              applicationName: '숫자 총합',
              children: const [Text('여기에 플레이 방법을 적어주세요.')],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.help_outline),
            title: const Text('도움말'),
            onTap: () => showAboutDialog(
              context: context,
              applicationName: '숫자 총합',
              children: const [Text('FAQ/지원 링크를 넣어주세요.')],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text('게임 정보'),
            onTap: () => showAboutDialog(
              context: context,
              applicationName: '숫자 총합',
              children: const [Text('버전 정보 / 빌드 번호')],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.privacy_tip_outlined),
            title: const Text('개인 정보 보호 권리'),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.lock_reset),
            title: const Text('개인정보 기본 설정'),
            onTap: () {},
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.block),
            title: const Text('광고 제거'),
            onTap: () => ScaffoldMessenger.of(context)
                .showSnackBar(const SnackBar(content: Text('IAP 미구현 - 샘플입니다.'))),
          ),
        ],
      ),
    );
  }
}
