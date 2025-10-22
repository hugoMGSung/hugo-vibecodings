# flame_puzzle_framework

A new Flutter Flame Game framework with VibeCoding

## 채팅으로 생성

![alt text](image.png)

### 프로젝트 ZIP 다운로드

앱 이름 flame_puzzle_framework

- 전체 구조 개요

    ```bash
    flame_puzzle_framework/
    ├─ pubspec.yaml
    ├─ lib/
    │  ├─ main.dart                 # MaterialApp.router + Theme
    │  ├─ app_router.dart           # GoRouter (/, /home, /settings, /awards)
    │  ├─ core/theme.dart           # 통일 테마(버튼/카드/네비바/라운드)
    │  ├─ features/
    │  │  ├─ onboarding/consent_page.dart   # 동의 화면
    │  │  ├─ home/home_page.dart            # 홈 + 하단 네비 + Daily/Level 버튼
    │  │  ├─ settings/settings_page.dart    # 설정 (EasyBrain풍 리스트)
    │  │  ├─ awards/awards_page.dart        # 월별 진행도 뷰
    │  │  └─ tutorial/tutorial_overlay.dart # “플레이 방법” 모달
    │  ├─ game/
    │  │  ├─ base_puzzle_game.dart          # Flame GameWidget 래퍼
    │  │  └─ puzzles/number_sum_puzzle.dart # 샘플 퍼즐(데일리/레벨 팩토리)
    │  └─ services/
    │     ├─ storage/local_storage.dart     # SharedPreferences 래퍼
    │     ├─ ads/ads_service.dart           # 광고 인터페이스(스텁)
    │     ├─ iap/iap_service.dart           # 결제 인터페이스(스텁)
    │     ├─ notifications/…                # 알림 인터페이스(스텁)
    │     └─ analytics/…                    # 분석 로거(프린트 스텁)
    └─ assets/images, assets/audio          # 리소스 폴더(미리 등록)

    ```

- ZIP 내용 덮어쓰기

    - pubspec.yaml 내용 덮어쓰고 Pub upgrade

    ![alt text](image-1.png)

