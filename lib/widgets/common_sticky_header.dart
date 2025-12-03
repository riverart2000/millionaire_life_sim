import 'package:flutter/material.dart';
import 'package:provider/provider.dart' as legacy;

import '../models/quote.dart';
import '../services/quote_service.dart';
import '../providers/sound_provider.dart';
import 'top_menu.dart';

class CommonStickyHeader extends StatefulWidget {
  final String? currentScreen; // To highlight current screen icon
  final String userName;
  final List<TemplateMenuItem> menuItems;
  final ValueChanged<String> onMenuSelected;
  final Future<void> Function() onLogout;
  
  const CommonStickyHeader({
    super.key,
    this.currentScreen,
    required this.userName,
    required this.menuItems,
    required this.onMenuSelected,
    required this.onLogout,
  });

  @override
  State<CommonStickyHeader> createState() => _CommonStickyHeaderState();
}

class _CommonStickyHeaderState extends State<CommonStickyHeader> {
  Quote? _currentQuote;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeHeader();
  }

  @override
  void didUpdateWidget(CommonStickyHeader oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Get new quote when screen changes
    if (oldWidget.currentScreen != widget.currentScreen && _isInitialized) {
      debugPrint('🔄 Screen changed from ${oldWidget.currentScreen} to ${widget.currentScreen}');
      _currentQuote = QuoteService.getRandomQuote();
      if (mounted) {
        setState(() {});
      }
    }
  }

  Future<void> _initializeHeader() async {
    if (!_isInitialized) {
      // Ensure quotes are loaded
      if (!QuoteService.isLoaded) {
        await QuoteService.loadQuotes();
      }
      _currentQuote = QuoteService.getRandomQuote();
      _isInitialized = true;
      if (mounted) {
        setState(() {});
      }
    }
  }

  void _refreshQuote() {
    debugPrint('🔄 Manually refreshing quote');
    setState(() {
      _currentQuote = QuoteService.getRandomQuote();
    });
  }

  /// Returns shortened label for compact screens
  String _getShortLabel(String fullLabel, bool isCompact) {
    if (!isCompact) return fullLabel;
    
    const shortLabels = {
      'Dashboard': 'Dash',
      'Marketplace': 'Market',
      'Education': 'Edu',
      'Investments': 'Invest',
      'Transactions': 'Trans',
      'Settings': 'Settings',
    };
    
    return shortLabels[fullLabel] ?? fullLabel;
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 4,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Theme.of(context).colorScheme.primaryContainer,
              Theme.of(context).colorScheme.secondaryContainer,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          bottom: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Navigation Icons Row
              LayoutBuilder(
                builder: (context, constraints) {
                  // Check if we're on a narrow screen
                  final isNarrowScreen = constraints.maxWidth < 600;
                  
                  return Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: isNarrowScreen ? 2.0 : 8.0,
                      vertical: isNarrowScreen ? 4.0 : 8.0,
                    ),
                    child: Wrap(
                      alignment: WrapAlignment.spaceEvenly,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      spacing: isNarrowScreen ? 2.0 : 4.0,
                      runSpacing: isNarrowScreen ? 2.0 : 4.0,
                      children: [
                        // Dynamically render menu items
                        ...widget.menuItems.where((item) => item.id != 'settings').map((item) {
                          return _buildIconButton(
                            icon: item.icon,
                            label: _getShortLabel(item.label, isNarrowScreen),
                            isActive: widget.currentScreen == item.id,
                            isCompact: isNarrowScreen,
                            onPressed: () {
                              if (widget.currentScreen != item.id) {
                                widget.onMenuSelected(item.id);
                              }
                            },
                          );
                        }),
                        // Sound toggle
                        legacy.Consumer<SoundProvider>(
                          builder: (context, soundProvider, _) =>
                              _buildIconButton(
                            icon: soundProvider.isEnabled ? Icons.volume_up : Icons.volume_off,
                            label: 'Sound',
                            isActive: false,
                            isCompact: isNarrowScreen,
                            onPressed: () async {
                              await soundProvider.toggleSound();
                            },
                          ),
                        ),
                        // Settings (always last)
                        ...widget.menuItems.where((item) => item.id == 'settings').map((item) {
                          return _buildIconButton(
                            icon: item.icon,
                            label: _getShortLabel(item.label, isNarrowScreen),
                            isActive: widget.currentScreen == item.id,
                            isCompact: isNarrowScreen,
                            onPressed: () {
                              if (widget.currentScreen != item.id) {
                                widget.onMenuSelected(item.id);
                              }
                            },
                          );
                        }),
                        // Logout Button
                        _buildIconButton(
                          icon: Icons.logout,
                          label: 'Logout',
                          isActive: false,
                          isCompact: isNarrowScreen,
                          onPressed: () async {
                            final confirmed = await showDialog<bool>(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text('Logout'),
                                content: const Text('Are you sure you want to logout?'),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.of(context).pop(false),
                                    child: const Text('Cancel'),
                                  ),
                                  TextButton(
                                    onPressed: () => Navigator.of(context).pop(true),
                                    child: const Text('Logout'),
                                  ),
                                ],
                              ),
                            );
                            
                            if (confirmed == true) {
                              await widget.onLogout();
                            }
                          },
                        ),
                      ],
                    ),
                  );
                },
              ),
              
              // Quote Section
              if (_currentQuote != null)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 12.0),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.9),
                    border: Border(
                      top: BorderSide(
                        color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
                        width: 1,
                      ),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.format_quote,
                        size: 20,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${_currentQuote!.text} — ${_currentQuote!.author}',
                              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                fontSize: 11,
                                fontStyle: FontStyle.italic,
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.refresh,
                          size: 20,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        onPressed: _refreshQuote,
                        tooltip: 'New Quote',
                        padding: const EdgeInsets.all(4),
                        constraints: const BoxConstraints(),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIconButton({
    required IconData icon,
    required String label,
    required bool isActive,
    required VoidCallback onPressed,
    bool isCompact = false,
  }) {
    return Tooltip(
      message: label,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(isCompact ? 8 : 12),
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: isCompact ? 4 : 12,
            vertical: isCompact ? 4 : 8,
          ),
          decoration: BoxDecoration(
            color: isActive
                ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.2)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(isCompact ? 8 : 12),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: isCompact ? 20 : 24,
                color: isActive
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              SizedBox(height: isCompact ? 2 : 4),
              Text(
                label,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: isActive
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).colorScheme.onSurfaceVariant,
                  fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                  fontSize: isCompact ? 9 : null,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

