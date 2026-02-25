import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'features/home/dashboard_page.dart';
import 'features/onboarding/consent_page.dart';
import 'features/settings/settings_page.dart';
import 'features/portfolio/portfolio_page.dart';
import 'features/risk/risk_result_page.dart';

final router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(path: '/', builder: (_, __) => const ConsentGate()),
    GoRoute(path: '/home', builder: (_, __) => const DashboardPage()),
    GoRoute(path: '/portfolio', builder: (_, __) => const PortfolioPage()),
    GoRoute(path: '/risk', builder: (_, __) => const RiskResultPage()),
    GoRoute(path: '/settings', builder: (_, __) => const SettingsPage()),
  ],
);
