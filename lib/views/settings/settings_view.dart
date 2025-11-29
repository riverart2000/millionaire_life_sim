import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
// Conditional import for web-specific functionality
import 'settings_web_utils.dart' if (dart.library.io) 'settings_stub.dart' as web_utils;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart' as legacy;
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/constants/hive_box_constants.dart';
import '../../core/config/app_config.dart';
import '../../providers/affirmation_provider.dart';
import '../../core/constants/jar_constants.dart';
import '../../core/utils/result.dart';
import '../../models/investment_price_model.dart';
import '../../models/jar_model.dart';
import '../../models/marketplace_item_model.dart';
import '../../models/transaction_model.dart';
import '../../models/user_profile_model.dart';
import '../../providers/data_providers.dart';
import '../../providers/bootstrap_provider.dart';
import '../../providers/investment_provider.dart';
import '../../providers/session_providers.dart';
import '../../providers/simulation_date_provider.dart';
import '../../providers/theme_provider.dart';
import '../../services/bills_service.dart';
import '../../services/interest_service.dart';
import '../../services/investment_return_service.dart';

class SettingsView extends ConsumerStatefulWidget {
  const SettingsView({super.key});

  @override
  ConsumerState<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends ConsumerState<SettingsView> {
  final Map<String, TextEditingController> _jarControllers = {};
  final TextEditingController _incomeController = TextEditingController();
  final TextEditingController _rentController = TextEditingController();
  final TextEditingController _foodController = TextEditingController();
  final TextEditingController _travelController = TextEditingController();
  final TextEditingController _accessoriesController = TextEditingController();
  bool _autoSimulate = true;  // Auto-simulate is ON by default
  bool _firebaseSyncEnabled = true;
  bool _initialized = false;
  DateTime? _lastSyncedAt;
  bool _isSyncing = false;
  bool _interestLoading = true;
  bool _savingInterest = false;
  bool _investmentReturnLoading = true;
  bool _savingInvestmentReturn = false;
  bool _billsLoading = true;
  bool _savingBills = false;
  Map<String, double> _interestRatesPercent = {};
  Map<String, double> _investmentReturnRatesPercent = {};
  AppConfig? _appConfig;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadConfig();
      _loadInterestRates();
      _loadInvestmentReturnRates();
      _loadBills();
    });
  }

  Future<void> _loadConfig() async {
    _appConfig = await AppConfig.load();
  }

  @override
  void dispose() {
    for (final controller in _jarControllers.values) {
      controller.dispose();
    }
    _incomeController.dispose();
    _rentController.dispose();
    _foodController.dispose();
    _travelController.dispose();
    _accessoriesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final profileAsync = ref.watch(userProfileProvider);
    final jarsAsync = ref.watch(jarsProvider);

    return profileAsync.when(
      data: (profile) => jarsAsync.when(
        data: (jars) {
          if (!_initialized && profile != null) {
            _syncState(profile, jars);
            _initialized = true;
          }
          return _buildContent(context, profile, jars);
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('Failed to load jars: $error')),
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => Center(child: Text('Failed to load profile: $error')),
    );
  }

  Widget _buildContent(BuildContext context, UserProfile? profile, List<Jar> jars) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Settings',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          _buildThemeCard(context),
          const SizedBox(height: 16),
          _buildSubliminalAffirmationsCard(context),
          const SizedBox(height: 16),
          _buildIncomeCard(context),
          const SizedBox(height: 16),
          _buildBillsCard(context),
          const SizedBox(height: 16),
          _buildInterestCard(context),
          const SizedBox(height: 16),
          _buildInvestmentReturnCard(context),
          const SizedBox(height: 16),
          _buildJarAllocationCard(context, jars),
          const SizedBox(height: 16),
          _buildSyncCard(context),
          const SizedBox(height: 16),
          _buildDataManagementCard(context),
        ],
      ),
    );
  }

  Widget _buildThemeCard(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AnimatedTextKit(
              animatedTexts: [
                WavyAnimatedText(
                  'Appearance',
                  textStyle: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ) ?? const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
              ],
              totalRepeatCount: 1,
              displayFullTextOnTap: true,
            ),
            const SizedBox(height: 16),
            legacy.Consumer<ThemeProvider>(
              builder: (context, themeProvider, _) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Dark Mode Toggle
                    SwitchListTile(
                      title: const Text('Dark Mode'),
                      subtitle: const Text('Switch between light and dark themes'),
                      value: themeProvider.isDarkMode,
                      onChanged: (value) {
                        themeProvider.toggleDarkMode();
                      },
                      secondary: Icon(
                        themeProvider.isDarkMode ? Icons.dark_mode : Icons.light_mode,
                      ),
                    ),
                    
                    const Divider(),
                    
                    // Color Scheme Selection
                    ListTile(
                      title: const Text('Color Scheme'),
                      subtitle: Text('Current: ${themeProvider.colorScheme}'),
                      leading: const Icon(Icons.palette),
                      trailing: const Icon(Icons.arrow_forward_ios),
                      onTap: () {
                        _showColorSchemeDialog(context, themeProvider);
                      },
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
  
  void _showColorSchemeDialog(BuildContext context, ThemeProvider themeProvider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Choose Color Theme'),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: themeProvider.availableSchemes.length,
            itemBuilder: (context, index) {
              final schemeName = themeProvider.availableSchemes[index];
              final isSelected = themeProvider.colorScheme == schemeName;
              
              return Card(
                elevation: isSelected ? 4 : 1,
                margin: const EdgeInsets.symmetric(vertical: 4),
                child: ListTile(
                  selected: isSelected,
                  leading: Icon(
                    isSelected ? Icons.check_circle : Icons.circle_outlined,
                    color: isSelected ? Theme.of(context).colorScheme.primary : null,
                  ),
                  title: Text(
                    schemeName,
                    style: TextStyle(
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                  subtitle: isSelected ? const Text('Current theme') : null,
                  trailing: Icon(
                    Icons.palette,
                    color: isSelected ? Theme.of(context).colorScheme.primary : Colors.grey,
                  ),
                  onTap: () {
                    themeProvider.setColorScheme(schemeName);
                    Navigator.of(context).pop();
                  },
                ),
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Widget _buildSubliminalAffirmationsCard(BuildContext context) {
    final settings = ref.watch(affirmationSettingsProvider);
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.psychology),
                const SizedBox(width: 8),
                Text(
                  'Subliminal Affirmations',
                  style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Brief affirmations flash on screen to reinforce positive money beliefs subconsciously.',
              style: theme.textTheme.bodySmall,
            ),
            const SizedBox(height: 16),
            
            // Enable/Disable
            SwitchListTile(
              title: const Text('Enable subliminal affirmations'),
              subtitle: const Text('Show brief affirmation flashes during app use'),
              value: settings.enabled,
              onChanged: (value) {
                ref.read(affirmationSettingsProvider.notifier).setEnabled(value);
              },
            ),
            
            const Divider(),
            
            // Flash Duration
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Flash Duration'),
                      Text('${settings.flashDurationMs}ms', style: theme.textTheme.titleSmall),
                    ],
                  ),
                  Slider(
                    value: settings.flashDurationMs.toDouble(),
                    min: 100,
                    max: 500,
                    divisions: 40,
                    label: '${settings.flashDurationMs}ms',
                    onChanged: (value) {
                      ref.read(affirmationSettingsProvider.notifier).setFlashDuration(value.toInt());
                    },
                  ),
                ],
              ),
            ),
            
            // Opacity
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Opacity'),
                      Text('${(settings.opacity * 100).toInt()}%', style: theme.textTheme.titleSmall),
                    ],
                  ),
                  Slider(
                    value: settings.opacity,
                    min: 0.05,
                    max: 0.50,
                    divisions: 45,
                    label: '${(settings.opacity * 100).toInt()}%',
                    onChanged: (value) {
                      ref.read(affirmationSettingsProvider.notifier).setOpacity(value);
                    },
                  ),
                ],
              ),
            ),
            
            // Interval
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Interval'),
                      Text('${settings.intervalSeconds}s', style: theme.textTheme.titleSmall),
                    ],
                  ),
                  Slider(
                    value: settings.intervalSeconds.toDouble(),
                    min: 5,
                    max: 120,
                    divisions: 23,
                    label: '${settings.intervalSeconds}s',
                    onChanged: (value) {
                      ref.read(affirmationSettingsProvider.notifier).setInterval(value.toInt());
                    },
                  ),
                ],
              ),
            ),
            
            const Divider(),
            
            // Random Position
            SwitchListTile(
              title: const Text('Random positions'),
              subtitle: const Text('Show affirmations at random screen positions'),
              value: settings.randomPosition,
              onChanged: (value) {
                ref.read(affirmationSettingsProvider.notifier).setRandomPosition(value);
              },
            ),
            
            // Font Size
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Font Size'),
                      Text('${settings.fontSize.toInt()}', style: theme.textTheme.titleSmall),
                    ],
                  ),
                  Slider(
                    value: settings.fontSize,
                    min: 24,
                    max: 48,
                    divisions: 24,
                    label: '${settings.fontSize.toInt()}',
                    onChanged: (value) {
                      ref.read(affirmationSettingsProvider.notifier).setFontSize(value);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIncomeCard(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Daily Income', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            TextFormField(
              controller: _incomeController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                labelText: 'Simulated daily income',
                prefixText: '\$',
                prefixStyle: TextStyle(color: Colors.black87),
              ),
            ),
            const SizedBox(height: 16),
            SwitchListTile(
              title: const Text('Auto-simulate daily income'),
              subtitle: const Text('Automatically allocate income at app start when enabled.'),
              value: _autoSimulate,
              onChanged: (value) => setState(() => _autoSimulate = value),
            ),
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.centerRight,
              child: FilledButton.icon(
                onPressed: _saveIncomeSettings,
                icon: const Icon(Icons.save),
                label: const Text('Save income settings'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBillsCard(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Daily Bills',
              style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Configure daily expenses deducted from NEC jar each day. NEC jar can go negative.',
              style: theme.textTheme.bodySmall,
            ),
            const SizedBox(height: 16),
            if (_billsLoading)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 24),
                child: Center(child: CircularProgressIndicator()),
              )
            else
              Column(
                children: [
                  TextFormField(
                    controller: _rentController,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    decoration: const InputDecoration(
                      labelText: 'Rent (per day)',
                      prefixText: '\$',
                      prefixStyle: TextStyle(color: Colors.black87),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _foodController,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    decoration: const InputDecoration(
                      labelText: 'Food (per day)',
                      prefixText: '\$',
                      prefixStyle: TextStyle(color: Colors.black87),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _travelController,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    decoration: const InputDecoration(
                      labelText: 'Travel (per day)',
                      prefixText: '\$',
                      prefixStyle: TextStyle(color: Colors.black87),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _accessoriesController,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    decoration: const InputDecoration(
                      labelText: 'Accessories (per day)',
                      prefixText: '\$',
                      prefixStyle: TextStyle(color: Colors.black87),
                      border: OutlineInputBorder(),
                    ),
                  ),
                ],
              ),
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.centerRight,
              child: FilledButton.icon(
                onPressed: _billsLoading || _savingBills ? null : _saveBills,
                icon: _savingBills
                    ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))
                    : const Icon(Icons.receipt_long),
                label: const Text('Save bills'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInterestCard(BuildContext context) {
    final theme = Theme.of(context);
    final jarLabels = <String, String>{
      JarConstants.ffa: 'Financial Freedom (FFA)',
      JarConstants.ltss: 'Long-Term Savings (LTSS)',
      JarConstants.edu: 'Education (EDU)',
    };

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Interest Settings',
                  style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
                if (_interestLoading)
                  const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              'Set the daily interest rate for your long-term jars (0.1% - 2.0% per day). Interest compounds daily after income allocation.',
              style: theme.textTheme.bodySmall,
            ),
            const SizedBox(height: 16),
            if (_interestLoading)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 24),
                child: Center(child: CircularProgressIndicator()),
              )
            else
              ...jarLabels.entries.map((entry) {
                final jarId = entry.key;
                final label = entry.value;
                final current = _interestRatesPercent[jarId] ?? 0.1;

                return Padding(
                  padding: const EdgeInsets.only(bottom: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            label,
                            style: theme.textTheme.titleMedium,
                          ),
                          Text(
                            '${current.toStringAsFixed(1)}%',
                            style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      Slider(
                        value: current,
                        min: 0.1,
                        max: 2.0,
                        divisions: 19, // 0.1% increments from 0.1 to 2.0
                        label: '${current.toStringAsFixed(1)}%',
                        onChanged: (value) {
                          setState(() {
                            _interestRatesPercent[jarId] = double.parse(value.toStringAsFixed(1));
                          });
                        },
                      ),
                    ],
                  ),
                );
              }).toList(),
            Align(
              alignment: Alignment.centerRight,
              child: FilledButton.icon(
                onPressed: _interestLoading || _savingInterest ? null : _saveInterestRates,
                icon: _savingInterest
                    ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))
                    : const Icon(Icons.savings_outlined),
                label: const Text('Save interest rates'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInvestmentReturnCard(BuildContext context) {
    final theme = Theme.of(context);
    final investmentLabels = <String, String>{
      'GOLD': 'Gold',
      'SILVER': 'Silver',
      'BTC': 'Bitcoin',
      'REALESTATE': 'Real Estate',
    };

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Investment Return Rates',
                  style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
                if (_investmentReturnLoading)
                  const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              'Set the daily return rate for your investments (0.1% - 2.0% per day). Returns are calculated based on your investment value and added to FFA jar.',
              style: theme.textTheme.bodySmall,
            ),
            const SizedBox(height: 16),
            if (_investmentReturnLoading)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 24),
                child: Center(child: CircularProgressIndicator()),
              )
            else
              ...investmentLabels.entries.map((entry) {
                final symbol = entry.key;
                final label = entry.value;
                final current = _investmentReturnRatesPercent[symbol] ?? 0.1;

                return Padding(
                  padding: const EdgeInsets.only(bottom: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            label,
                            style: theme.textTheme.titleMedium,
                          ),
                          Text(
                            '${current.toStringAsFixed(1)}%',
                            style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      Slider(
                        value: current,
                        min: 0.1,
                        max: 2.0,
                        divisions: 19, // 0.1% increments from 0.1 to 2.0
                        label: '${current.toStringAsFixed(1)}%',
                        onChanged: (value) {
                          setState(() {
                            _investmentReturnRatesPercent[symbol] = double.parse(value.toStringAsFixed(1));
                          });
                        },
                      ),
                    ],
                  ),
                );
              }).toList(),
            Align(
              alignment: Alignment.centerRight,
              child: FilledButton.icon(
                onPressed: _investmentReturnLoading || _savingInvestmentReturn ? null : _saveInvestmentReturnRates,
                icon: _savingInvestmentReturn
                    ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))
                    : const Icon(Icons.trending_up),
                label: const Text('Save return rates'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildJarAllocationCard(BuildContext context, List<Jar> jars) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Jar Allocation Percentages', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 3.5,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: jars.length,
              itemBuilder: (context, index) {
                final jar = jars[index];
                final controller = _jarControllers[jar.id]!;
                return TextFormField(
                  controller: controller,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  decoration: InputDecoration(
                    labelText: '${jar.name} (%)',
                    suffixText: '%',
                    border: const OutlineInputBorder(),
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.centerRight,
              child: FilledButton.icon(
                onPressed: () => _saveJarPercentages(jars),
                icon: const Icon(Icons.save_as_outlined),
                label: const Text('Update percentages'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSyncCard(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Sync & Data Export', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            SwitchListTile(
              title: const Text('Enable Firebase sync'),
              subtitle: Text(
                _firebaseSyncEnabled
                    ? 'Cloud sync is enabled. Last sync: ${_formatLastSync()}.'
                    : 'Sync disabled; app operates offline only.',
              ),
              value: _firebaseSyncEnabled,
              onChanged: (value) async {
                await _toggleSync(value);
              },
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                FilledButton.icon(
                  onPressed: _isSyncing || !_firebaseSyncEnabled ? null : _manualSync,
                  icon: const Icon(Icons.sync),
                  label: Text(_isSyncing ? 'Syncing…' : 'Sync now'),
                ),
                const SizedBox(width: 12),
                OutlinedButton.icon(
                  onPressed: _exportData,
                  icon: const Icon(Icons.download_outlined),
                  label: const Text('Export data to JSON'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _syncState(UserProfile profile, List<Jar> jars) {
    _incomeController.text = profile.dailyIncome.toStringAsFixed(2);
    _autoSimulate = profile.autoSimulateDaily;
    _firebaseSyncEnabled = profile.syncEnabled;
    _lastSyncedAt = profile.lastSyncedAt;

    final percentages = profile.jarPercentages;
    for (final jar in jars) {
      _jarControllers.putIfAbsent(jar.id, () => TextEditingController());
      final controller = _jarControllers[jar.id]!;
      controller.text = (percentages[jar.id] ?? jar.percentage).toStringAsFixed(1);
    }
  }

  Future<void> _loadInterestRates() async {
    final interestService = ref.read(interestServiceProvider);
    final rates = await interestService.loadRates();

    if (!mounted) return;

    setState(() {
      if (rates.isEmpty && _appConfig != null) {
        // Use config defaults
        _interestRatesPercent = _appConfig!.interestRates;
      } else {
        _interestRatesPercent = rates.map(
          (key, value) => MapEntry(key, ((value * 100).clamp(0.1, 2.0)).toDouble()),
        );
      }
      _interestLoading = false;
    });
  }

  Future<void> _loadInvestmentReturnRates() async {
    final investmentReturnService = ref.read(investmentReturnServiceProvider);
    final rates = await investmentReturnService.loadRates();

    if (!mounted) return;

    setState(() {
      if (rates.isEmpty && _appConfig != null) {
        // Use config defaults
        _investmentReturnRatesPercent = _appConfig!.investmentReturns;
      } else {
        _investmentReturnRatesPercent = rates.map(
          (key, value) => MapEntry(key, ((value * 100).clamp(0.1, 2.0)).toDouble()),
        );
      }
      _investmentReturnLoading = false;
    });
  }

  Future<void> _loadBills() async {
    final billsService = ref.read(billsServiceProvider);
    final bills = await billsService.loadBills();

    if (!mounted) return;

    final billsConfig = _appConfig?.bills;
    setState(() {
      _rentController.text = bills[BillsService.rentKey]?.toStringAsFixed(2) ?? 
          billsConfig?.rent.toStringAsFixed(2) ?? '10.00';
      _foodController.text = bills[BillsService.foodKey]?.toStringAsFixed(2) ?? 
          billsConfig?.food.toStringAsFixed(2) ?? '10.00';
      _travelController.text = bills[BillsService.travelKey]?.toStringAsFixed(2) ?? 
          billsConfig?.travel.toStringAsFixed(2) ?? '10.00';
      _accessoriesController.text = bills[BillsService.accessoriesKey]?.toStringAsFixed(2) ?? 
          billsConfig?.accessories.toStringAsFixed(2) ?? '10.00';
      _billsLoading = false;
    });
  }

  Future<void> _saveBills() async {
    setState(() => _savingBills = true);

    final billsService = ref.read(billsServiceProvider);
    final rent = double.tryParse(_rentController.text) ?? 0.0;
    final food = double.tryParse(_foodController.text) ?? 0.0;
    final travel = double.tryParse(_travelController.text) ?? 0.0;
    final accessories = double.tryParse(_accessoriesController.text) ?? 0.0;

    await billsService.saveBills(
      rent: rent,
      food: food,
      travel: travel,
      accessories: accessories,
    );

    if (!mounted) return;

    setState(() => _savingBills = false);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Bills settings updated.')),
    );
  }

  Future<void> _saveIncomeSettings() async {
    final userRepository = ref.read(userRepositoryProvider);
    final profile = await userRepository.fetchProfile();
    if (profile == null) return;

    final parsedIncome = double.tryParse(_incomeController.text) ?? profile.dailyIncome;
    final updated = profile.copyWith(
      dailyIncome: parsedIncome,
      autoSimulateDaily: _autoSimulate,
      lastSyncedAt: DateTime.now(),
    );

    await userRepository.saveProfile(updated);
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Income settings saved.')),
      );
    }
  }

  Future<void> _saveJarPercentages(List<Jar> jars) async {
    final jarService = ref.read(jarServiceProvider);
    final userId = ref.read(userIdProvider);
    final percentages = <String, double>{};

    for (final jar in jars) {
      final value = double.tryParse(_jarControllers[jar.id]?.text ?? '') ?? jar.percentage;
      percentages[jar.id] = value;
    }

    final result = await jarService.updatePercentages(userId: userId, percentages: percentages);
    if (context.mounted) {
      if (result is Success<void>) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Jar percentages updated.')),
        );
      } else if (result is Failure<void>) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update percentages: ${result.exception}')),
        );
      }
    }
  }

  Future<void> _toggleSync(bool enabled) async {
    // Sync is not available in offline mode
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cloud sync not available in offline mode')),
      );
    }
  }

  Future<void> _manualSync() async {
    // Sync is not available in offline mode
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cloud sync not available in offline mode')),
      );
    }
  }

  Future<void> _saveInterestRates() async {
    setState(() => _savingInterest = true);

    final interestService = ref.read(interestServiceProvider);
    final ratesToSave = _interestRatesPercent.map(
      (key, value) => MapEntry(
        key,
        ((value / 100).clamp(InterestService.minRate, InterestService.maxRate)).toDouble(),
      ),
    );

    await interestService.saveRates(ratesToSave);

    if (!mounted) return;

    setState(() => _savingInterest = false);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Interest rates updated.')),
    );
  }

  Future<void> _saveInvestmentReturnRates() async {
    setState(() => _savingInvestmentReturn = true);

    final investmentReturnService = ref.read(investmentReturnServiceProvider);
    final ratesToSave = _investmentReturnRatesPercent.map(
      (key, value) => MapEntry(
        key,
        ((value / 100).clamp(InvestmentReturnService.minRate, InvestmentReturnService.maxRate)).toDouble(),
      ),
    );

    await investmentReturnService.saveRates(ratesToSave);

    if (!mounted) return;

    setState(() => _savingInvestmentReturn = false);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Investment return rates updated.')),
    );
  }

  Future<void> _runSync(Future<Result<void>> Function() operation) async {
    setState(() => _isSyncing = true);
    final result = await operation();
    setState(() => _isSyncing = false);

    if (!mounted) return;
    if (result is Success<void>) {
      final profile = await ref.read(userRepositoryProvider).fetchProfile();
      setState(() => _lastSyncedAt = profile?.lastSyncedAt);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Synced successfully with Firebase.')),
      );
    } else if (result is Failure<void>) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Sync failed: ${result.exception}')),
      );
    }
  }

  Future<void> _exportData() async {
    final exporter = ref.read(dataExportServiceProvider);
    final json = await exporter.exportToJson();
    if (!mounted) return;

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 24,
            right: 24,
            top: 24,
            bottom: MediaQuery.of(context).viewInsets.bottom + 24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Data Export', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 12),
              const Text('Copy the JSON below into your secure backup location:'),
              const SizedBox(height: 12),
              SizedBox(
                height: 240,
                child: SingleChildScrollView(
                  child: SelectableText(json, style: const TextStyle(fontFamily: 'monospace', fontSize: 12)),
                ),
              ),
              const SizedBox(height: 12),
              Align(
                alignment: Alignment.centerRight,
                child: FilledButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Close'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDataManagementCard(BuildContext context) {
    return Card(
      color: Colors.red.shade50,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.warning_amber_rounded, color: Colors.red.shade700),
                const SizedBox(width: 8),
                Text(
                  'Data Management',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.red.shade700,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              'Reset all your data and start fresh. This will clear all jars, transactions, investments, marketplace items, and reset the simulation date to today.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.centerRight,
              child: FilledButton.icon(
                onPressed: () => _showResetConfirmationDialog(context),
                icon: const Icon(Icons.restore),
                label: const Text('Reset All Data'),
                style: FilledButton.styleFrom(
                  backgroundColor: Colors.red.shade700,
                  foregroundColor: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showResetConfirmationDialog(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reset All Data?'),
        content: const Text(
          'This will permanently delete all your progress including:\n\n'
          '• All jar balances\n'
          '• Transaction history\n'
          '• Investments\n'
          '• Marketplace items\n'
          '• Simulation date (reset to today)\n'
          '• Settings (except theme)\n\n'
          'This action cannot be undone!',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: FilledButton.styleFrom(
              backgroundColor: Colors.red.shade700,
            ),
            child: const Text('Reset Everything'),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      await _resetAllData();
    }
  }

  Future<void> _resetAllData() async {
    try {
      // Show loading indicator
      if (mounted) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => const Center(
            child: Card(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text('Resetting all data...'),
                  ],
                ),
              ),
            ),
          ),
        );
      }

      print('🗑️ Starting complete data reset...');

      // Step 1: Clear SharedPreferences first (except theme)
      final prefs = await SharedPreferences.getInstance();
      final allKeys = prefs.getKeys().toList();
      for (final key in allKeys) {
        if (!key.startsWith('theme_') && !key.startsWith('flex_')) {
          await prefs.remove(key);
          print('Removed pref key: $key');
        }
      }
      print('✅ SharedPreferences cleared');

      // Step 2: Clear all Hive boxes completely
      final jarBox = Hive.box<Jar>(HiveBoxConstants.jars);
      final transactionBox = Hive.box<MoneyTransaction>(HiveBoxConstants.transactions);
      final userProfileBox = Hive.box<UserProfile>(HiveBoxConstants.userProfile);
      final marketplaceBox = Hive.box<MarketplaceItem>(HiveBoxConstants.marketplaceItems);
      final ownedItemsBox = Hive.box<MarketplaceItem>(HiveBoxConstants.ownedItems);
      final investmentPricesBox = Hive.box<InvestmentPrice>(HiveBoxConstants.investmentPrices);
      
      await jarBox.clear();
      print('Cleared jars box (${jarBox.length} items)');
      
      await transactionBox.clear();
      print('Cleared transactions box (${transactionBox.length} items)');
      
      await userProfileBox.clear();
      print('Cleared user profile box (${userProfileBox.length} items)');
      
      await marketplaceBox.clear();
      print('Cleared marketplace box (${marketplaceBox.length} items)');
      
      await ownedItemsBox.clear();
      print('Cleared owned items box (${ownedItemsBox.length} items)');
      
      await investmentPricesBox.clear();
      print('Cleared investment prices box (${investmentPricesBox.length} items)');
      
      // Force Hive to flush changes to disk
      await jarBox.compact();
      await transactionBox.compact();
      await userProfileBox.compact();
      await marketplaceBox.compact();
      await ownedItemsBox.compact();
      await investmentPricesBox.compact();
      
      print('✅ All Hive boxes cleared and compacted');

      // Step 3: On web, also clear IndexedDB and localStorage directly
      if (kIsWeb) {
        try {
          web_utils.clearWebStorage();
          print('✅ localStorage cleared');
        } catch (e) {
          print('Error clearing localStorage: $e');
        }
      }

      // Wait for all async operations to complete
      await Future.delayed(const Duration(milliseconds: 1000));

      // Close loading dialog
      if (mounted) {
        Navigator.of(context).pop();
      }

      print('🔄 Forcing reload...');

      // Force a complete page reload on web, or invalidate everything on other platforms
      if (kIsWeb) {
        // On web, do a hard refresh to clear everything and let bootstrap recreate data
        web_utils.reloadPage();
      } else {
        // On mobile/desktop, invalidate all providers
        ref.invalidate(jarsProvider);
        ref.invalidate(userProfileProvider);
        ref.invalidate(transactionsProvider);
        ref.invalidate(simulationDateProvider);
        ref.invalidate(totalWealthProvider);
        ref.invalidate(userBootstrapProvider);
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('✅ Data reset complete!'),
              backgroundColor: Colors.green,
              duration: Duration(seconds: 2),
            ),
          );
        }
      }
    } catch (error, stackTrace) {
      // Close loading dialog if still showing
      if (mounted) {
        Navigator.of(context).pop();
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to reset data: $error'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 5),
          ),
        );
      }
      // Log the error for debugging
      print('Reset error: $error');
      print('Stack trace: $stackTrace');
    }
  }

  String _formatLastSync() {
    final last = _lastSyncedAt;
    if (last == null) return 'never';
    return '${last.year}-${last.month.toString().padLeft(2, '0')}-${last.day.toString().padLeft(2, '0')} ${last.hour.toString().padLeft(2, '0')}:${last.minute.toString().padLeft(2, '0')}';
  }
}

