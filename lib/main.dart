import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:provider/provider.dart' as legacy;

import 'core/di/injection.dart';
import 'providers/auth_provider.dart';
import 'providers/bootstrap_provider.dart';
import 'providers/quote_provider.dart';
import 'providers/sound_provider.dart';
import 'providers/theme_provider.dart';
import 'services/bootstrap_service.dart';
import 'services/quote_service.dart';
import 'views/auth/login_view.dart';
import 'views/dashboard/dashboard_view.dart';
import 'views/investments/investments_view.dart';
import 'views/marketplace/marketplace_view.dart';
import 'views/settings/settings_view.dart';
import 'views/transactions/transactions_view.dart';
import 'widgets/template_footer.dart';
import 'widgets/common_sticky_header.dart';
import 'widgets/top_menu.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize DI - this is fast
  await configureDependencies();

  final bootstrapService = getIt<BootstrapService>();
  final container = ProviderContainer(
    overrides: [
      bootstrapServiceProvider.overrideWithValue(bootstrapService),
    ],
  );

  // Create theme provider but don't await initialization - load lazily
  final themeProvider = ThemeProvider();
  // Initialize theme in background (non-blocking)
  themeProvider.initialize().catchError((e) {
    debugPrint('Theme initialization error: $e');
  });

  // Load quotes in background (non-blocking) - will be available when needed
  QuoteService.loadQuotes().catchError((e) {
    debugPrint('Quote loading error: $e');
  });

  // Create and restore auth session
  final authProvider = AuthProvider();
  await authProvider.restoreSession();

  // Start app immediately - bootstrap happens in FutureProvider
  runApp(
    legacy.MultiProvider(
      providers: [
        legacy.ChangeNotifierProvider.value(value: authProvider),
        legacy.ChangeNotifierProvider(create: (_) => QuoteProvider()),
        legacy.ChangeNotifierProvider(create: (_) => SoundProvider()),
        legacy.ChangeNotifierProvider.value(value: themeProvider),
      ],
      child: UncontrolledProviderScope(
        container: container,
        child: const MillionaireLifeSimulatorApp(),
      ),
    ),
  );
}

class MillionaireLifeSimulatorApp extends ConsumerWidget {
  const MillionaireLifeSimulatorApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return legacy.Consumer<ThemeProvider>(
      builder: (context, themeProvider, _) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Millionaire Life Simulator',
          theme: themeProvider.getLightTheme(),
          darkTheme: themeProvider.getDarkTheme(),
          themeMode: themeProvider.themeMode,
          home: const _RootRouter(),
        );
      },
    );
  }
}

class _RootRouter extends ConsumerWidget {
  const _RootRouter();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return legacy.Consumer<AuthProvider>(
      builder: (context, authProvider, _) {
        // Show loading while auth state is being restored
        if (!authProvider.isReady) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        // If not authenticated, show login screen
        if (!authProvider.isAuthenticated) {
          return const LoginView();
        }

        // If authenticated, proceed with app initialization
        final initialization = ref.watch(appInitializationProvider);
        
        return initialization.when(
          data: (_) => const _RootShell(),
          loading: () => const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          ),
          error: (error, stackTrace) => Scaffold(
            body: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Icon(Icons.error_outline, size: 64, color: Colors.redAccent),
                  const SizedBox(height: 16),
                  Text(
                    'Initialization failed',
                    style: Theme.of(context).textTheme.headlineSmall,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    error.toString(),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _RootShell extends ConsumerStatefulWidget {
  const _RootShell();

  @override
  ConsumerState<_RootShell> createState() => _RootShellState();
}

class _RootShellState extends ConsumerState<_RootShell> {
  int _currentIndex = 0;

  // Define menu items for the template header
  final List<TemplateMenuItem> _menuItems = const [
    TemplateMenuItem(id: 'dashboard', label: 'Dashboard', icon: Icons.dashboard_outlined),
    TemplateMenuItem(id: 'marketplace', label: 'Marketplace', icon: Icons.storefront_outlined),
    TemplateMenuItem(id: 'investments', label: 'Investments', icon: Icons.trending_up_outlined),
    TemplateMenuItem(id: 'transactions', label: 'Transactions', icon: Icons.receipt_long_outlined),
    TemplateMenuItem(id: 'settings', label: 'Settings', icon: Icons.settings_outlined),
  ];

  @override
  void initState() {
    super.initState();
    // Initialize providers
    WidgetsBinding.instance.addPostFrameCallback((_) {
      legacy.Provider.of<SoundProvider>(context, listen: false).initialize();
      // Quotes are already loaded in main() via QuoteService.loadQuotes()
    });
  }

  String get _activeMenuId => _menuItems[_currentIndex].id;

  void _onMenuSelected(String menuId) {
    final index = _menuItems.indexWhere((item) => item.id == menuId);
    if (index >= 0) {
      setState(() => _currentIndex = index);
    }
  }

  Future<void> _handleLogout() async {
    final authProvider = legacy.Provider.of<AuthProvider>(context, listen: false);
    await authProvider.logout();
    // The _RootRouter will automatically navigate to LoginView when isAuthenticated becomes false
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Logged out successfully')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final userBootstrap = ref.watch(userBootstrapProvider);
    // Get user name from AuthProvider
    final authProvider = legacy.Provider.of<AuthProvider>(context, listen: false);
    final userName = authProvider.name ?? 'Millionaire';

    return userBootstrap.when(
      data: (_) => Scaffold(
        body: Column(
          children: [
            // Common Sticky Header with navigation icons and motivational quote
            CommonStickyHeader(
              currentScreen: _activeMenuId,
              userName: userName,
              menuItems: _menuItems,
              onMenuSelected: _onMenuSelected,
              onLogout: _handleLogout,
            ),
            // Main content area
            Expanded(
              child: IndexedStack(
                index: _currentIndex,
                children: const [
                  DashboardView(),
                  MarketplaceView(),
                  InvestmentsView(),
                  TransactionsView(),
                  SettingsView(),
                ],
              ),
            ),
            // Template Footer
            const TemplateFooter(),
          ],
        ),
      ),
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (error, stackTrace) => Scaffold(
        body: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Icon(Icons.error_outline, size: 64, color: Colors.redAccent),
                const SizedBox(height: 16),
                Text(
                  'Bootstrap Failed',
                  style: Theme.of(context).textTheme.headlineSmall,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  error.toString(),
                  textAlign: TextAlign.center,
                  maxLines: 10,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 16),
                Text(
                  'Check console for details',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

