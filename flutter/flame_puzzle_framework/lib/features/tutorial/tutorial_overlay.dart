import 'package:flutter/material.dart';

void showTutorial(BuildContext context) {
  showDialog(
    context: context,
    builder: (ctx) => const _TutorialDialog(),
  );
}

class _TutorialDialog extends StatelessWidget {
  const _TutorialDialog();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('플레이 방법'),
      content: const Text('목표 숫자에 맞게 타일들의 합을 맞추세요. '
          '원/엑스 토글을 바꾸며 정답 후보를 표시할 수 있습니다. (튜토리얼 1/3)'),
      actions: [
        TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('건너뛰기')),
        FilledButton(onPressed: () => Navigator.of(context).pop(), child: const Text('탭하여 시작')),
      ],
    );
  }
}
