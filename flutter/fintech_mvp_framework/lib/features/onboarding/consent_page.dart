import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../services/storage/local_storage.dart';
import '../../core/i18n.dart';

/// First-run consent gate: shows ToS/Privacy text and moves to home after consent.
class ConsentGate extends StatefulWidget {
  const ConsentGate({super.key});

  @override
  State<ConsentGate> createState() => _ConsentGateState();
}

class _ConsentGateState extends State<ConsentGate> {
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _bootstrap();
  }

  Future<void> _bootstrap() async {
    final ok = await LocalStorage.instance.getBool('consentAccepted') ?? false;
    if (ok && mounted) {
      context.go('/home');
      return;
    }
    setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(),
              Text(context.t.consentTitle, style: Theme.of(context).textTheme.headlineMedium, textAlign: TextAlign.center),
              const SizedBox(height: 16),
              const Text(
                '앱의 약관과 개인정보 처리방침을 읽고 동의해주세요. '
                '동의하지 않으면 옵션 보기를 통해 제한적으로 이용할 수 있습니다.',
                textAlign: TextAlign.center,
              ),
              const Spacer(),
              FilledButton(
                onPressed: () async {
                  await LocalStorage.instance.setBool('consentAccepted', true);
                  if (context.mounted) context.go('/home');
                },
                style: FilledButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 18)),
                child: const Text('동의'),
              ),
              const SizedBox(height: 16),
              TextButton(onPressed: () => context.go('/home'), child: const Text('옵션 보기')),
            ],
          ),
        ),
      ),
    );
  }
}
