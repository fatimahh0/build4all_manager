// lib/features/owner/ownernav/presentation/screens/owner_nav_shell.dart
import 'package:flutter/material.dart';
import 'package:build4all_manager/l10n/app_localizations.dart';

enum OwnerMenuType { top, bottom, drawer }

OwnerMenuType _parseOwnerMenu(String? s) {
  switch ((s ?? '').toLowerCase().trim()) {
    case 'top':
      return OwnerMenuType.top;
    case 'drawer':
      return OwnerMenuType.drawer;
    case 'bottom':
    default:
      return OwnerMenuType.bottom;
  }
}

class OwnerDestination {
  final IconData icon;
  final IconData selectedIcon;
  final String label; // localized
  final Widget page;
  const OwnerDestination({
    required this.icon,
    required this.selectedIcon,
    required this.label,
    required this.page,
  });
}

class OwnerNavShell extends StatefulWidget {
  final String? backendMenuType; // "top" | "bottom" | "drawer"
  final OwnerMenuType? override; // force locally
  final List<OwnerDestination> destinations;
  final int initialIndex;

  const OwnerNavShell({
    super.key,
    required this.destinations,
    this.backendMenuType,
    this.override,
    this.initialIndex = 0,
  });

  State<OwnerNavShell> createState() => _OwnerNavShellState();
}

class _OwnerNavShellState extends State<OwnerNavShell>
    with TickerProviderStateMixin {
  late int _index;
  TabController? _tab;

  OwnerMenuType get _mode =>
      widget.override ?? _parseOwnerMenu(widget.backendMenuType);

  @override
  void initState() {
    super.initState();
    _index = widget.initialIndex;
    _attachTabIfNeeded();
  }

  @override
  void didUpdateWidget(covariant OwnerNavShell oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.destinations.length != widget.destinations.length ||
        oldWidget.override != widget.override ||
        oldWidget.backendMenuType != widget.backendMenuType) {
      if (_index >= widget.destinations.length) {
        _index =
            widget.destinations.isEmpty ? 0 : widget.destinations.length - 1;
      }
      _attachTabIfNeeded();
    }
  }

  void _attachTabIfNeeded() {
    _tab?.dispose();
    if (widget.destinations.isEmpty) return;
    _index = _index.clamp(0, widget.destinations.length - 1);
    if (_mode == OwnerMenuType.top) {
      _tab = TabController(length: widget.destinations.length, vsync: this)
        ..index = _index
        ..addListener(() {
          if (_tab!.indexIsChanging) setState(() => _index = _tab!.index);
        });
    } else {
      _tab = null;
    }
  }

  @override
  void dispose() {
    _tab?.dispose();
    super.dispose();
  }

  PreferredSizeWidget _appBar(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;
    return AppBar(
      titleSpacing: 8,
      title: Row(children: [
        Container(
          width: 10,
          height: 10,
          margin: const EdgeInsets.only(right: 8),
          decoration: BoxDecoration(
            color: cs.primary,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        Text(
          l10n.owner_nav_title, // localized title
          style: Theme.of(context).textTheme.titleMedium,
        ),
      ]),
      bottom: _mode == OwnerMenuType.top
          ? TabBar(
              controller: _tab,
              isScrollable: true,
              tabAlignment: TabAlignment.start,
              tabs: [
                for (final d in widget.destinations)
                  Tab(text: d.label, icon: Icon(d.icon))
              ],
            )
          : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    final pages = widget.destinations;

    switch (_mode) {
      case OwnerMenuType.top:
        return Scaffold(
          appBar: _appBar(context),
          body: TabBarView(
            controller: _tab,
            children: [for (final d in pages) d.page],
          ),
        );

      case OwnerMenuType.drawer:
        return Scaffold(
          appBar: _appBar(context),
          drawer: _buildDrawer(context, pages),
          body: AnimatedSwitcher(
            duration: const Duration(milliseconds: 220),
            child: IndexedStack(
              index: _index,
              children: [for (final d in pages) d.page],
            ),
          ),
        );

      case OwnerMenuType.bottom:
      default:
        return Scaffold(
          appBar: _appBar(context),
          body: AnimatedSwitcher(
            duration: const Duration(milliseconds: 220),
            child: IndexedStack(
              index: _index,
              children: [for (final d in pages) d.page],
            ),
          ),
          bottomNavigationBar: NavigationBar(
            height: 64,
            elevation: 0,
            selectedIndex: _index,
            onDestinationSelected: (i) => setState(() => _index = i),
            indicatorColor:
                Theme.of(context).colorScheme.primary.withOpacity(0.10),
            // 👇 ensure labels appear under icons
            labelBehavior:
                NavigationDestinationLabelBehavior.alwaysShow, // <- important
            destinations: [
              for (final d in pages)
                NavigationDestination(
                  icon: Icon(d.icon),
                  selectedIcon: Icon(d.selectedIcon),
                  label: d.label, // localized label under the icon
                ),
            ],
          ),
        );
    }
  }

  Widget _buildDrawer(BuildContext context, List<OwnerDestination> pages) {
    final cs = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;
    return NavigationDrawer(
      selectedIndex: _index,
      onDestinationSelected: (i) {
        setState(() => _index = i);
        Navigator.of(context).maybePop();
      },
      children: [
        DrawerHeader(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [cs.primary, cs.secondary],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Align(
            alignment: Alignment.bottomLeft,
            child: Text(
              l10n.owner_nav_title,
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall
                  ?.copyWith(color: cs.onPrimary, fontWeight: FontWeight.w800),
            ),
          ),
        ),
        for (final d in pages)
          NavigationDrawerDestination(
            icon: Icon(d.icon),
            selectedIcon: Icon(d.selectedIcon),
            label: Text(d.label),
          ),
      ],
    );
  }
}
