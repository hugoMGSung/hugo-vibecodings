import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'features/home/home_page.dart';
import 'features/onboarding/consent_page.dart';
import 'features/settings/settings_page.dart';
import 'features/awards/awards_page.dart';

final router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(path: '/', builder: (_, __) => const ConsentGate()),
    GoRoute(path: '/home', builder: (_, __) => const HomePage()),
    GoRoute(path: '/settings', builder: (_, __) => const SettingsPage()),
    GoRoute(path: '/awards', builder: (_, __) => const AwardsPage()),
  ],
);
