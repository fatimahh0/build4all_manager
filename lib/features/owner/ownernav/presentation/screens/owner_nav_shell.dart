// lib/features/owner/ownernav/presentation/screens/owner_nav_shell.dart
import 'package:flutter/material.dart';
import 'package:build4all_manager/l10n/app_localizations.dart';
import '../widgets/owner_pill_nav_bar.dart';

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
  final String label;
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
  final _scaffoldKey = GlobalKey<ScaffoldState>();

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

  @override
  Widget build(BuildContext context) {
    final pages = widget.destinations;
    final l10n = AppLocalizations.of(context)!;

    // super simple breakpoint: rail on wide screens
    final width = MediaQuery.of(context).size.width;
    final useRail = width >= 900 && _mode == OwnerMenuType.bottom;

    // Shared body (keeps state of each page)
    final body = AnimatedSwitcher(
      duration: const Duration(milliseconds: 220),
      child: IndexedStack(
        key: ValueKey(_index),
        index: _index,
        children: [for (final d in pages) d.page],
      ),
    );

    switch (_mode) {
      case OwnerMenuType.top:
        // Top tab bar *inside* body (no AppBar).
        return Scaffold(
          key: _scaffoldKey,
          body: SafeArea(
            child: Column(
              children: [
                _TopTabsStrip(tab: _tab!, pages: pages),
                const SizedBox(height: 8),
                Expanded(child: body),
              ],
            ),
          ),
        );

      case OwnerMenuType.drawer:
        // Drawer with a floating hamburger (no AppBar).
        return Scaffold(
          key: _scaffoldKey,
          drawer: _buildDrawer(context, pages),
          body: SafeArea(
            child: Stack(
              children: [
                Positioned.fill(child: body),
                Positioned(
                  top: 12,
                  left: 12,
                  child: _FabHamburger(onTap: () {
                    _scaffoldKey.currentState?.openDrawer();
                  }),
                ),
              ],
            ),
          ),
        );

      case OwnerMenuType.bottom:
      default:
        // Phones: bottom pill nav; Tablets/Desktops: left NavigationRail
        if (useRail) {
          return Scaffold(
            key: _scaffoldKey,
            body: SafeArea(
              child: Row(
                children: [
                  _OwnerRail(
                    index: _index,
                    onSelect: (i) => setState(() => _index = i),
                    pages: pages,
                  ),
                  const VerticalDivider(width: 1),
                  Expanded(child: body),
                ],
              ),
            ),
          );
        }

        return Scaffold(
          key: _scaffoldKey,
          body: SafeArea(child: body),
          bottomNavigationBar: OwnerPillNavBar(
            currentIndex: _index,
            onTap: (i) => setState(() => _index = i),
            items: [
              OwnerPillNavItem(
                icon: const Text('🏠', style: TextStyle(fontSize: 22)),
                label: l10n.owner_nav_home,
              ),
              OwnerPillNavItem(
                icon: const Text('🧮', style: TextStyle(fontSize: 22)),
                label: l10n.owner_nav_projects,
              ),
              OwnerPillNavItem(
                icon: const Text('👤', style: TextStyle(fontSize: 22)),
                label: l10n.owner_nav_profile,
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

class _TopTabsStrip extends StatelessWidget {
  final TabController tab;
  final List<OwnerDestination> pages;
  const _TopTabsStrip({required this.tab, required this.pages});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      margin: const EdgeInsets.fromLTRB(12, 8, 12, 0),
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: cs.outlineVariant.withOpacity(.4)),
      ),
      child: TabBar(
        controller: tab,
        isScrollable: true,
        tabAlignment: TabAlignment.start,
        dividerColor: Colors.transparent,
        tabs: [
          for (final d in pages)
            Tab(
              icon: Icon(d.icon),
              text: d.label,
            )
        ],
      ),
    );
  }
}

class _FabHamburger extends StatelessWidget {
  final VoidCallback onTap;
  const _FabHamburger({required this.onTap});
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Material(
      color: cs.surface,
      shape: const StadiumBorder(),
      elevation: 2,
      child: InkWell(
        customBorder: const StadiumBorder(),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Icon(Icons.menu, color: cs.onSurface),
        ),
      ),
    );
  }
}

class _OwnerRail extends StatelessWidget {
  final int index;
  final ValueChanged<int> onSelect;
  final List<OwnerDestination> pages;
  const _OwnerRail({
    required this.index,
    required this.onSelect,
    required this.pages,
  });

  @override
  Widget build(BuildContext context) {
    return NavigationRail(
      selectedIndex: index,
      onDestinationSelected: onSelect,
      labelType: NavigationRailLabelType.all,
      destinations: [
        for (final d in pages)
          NavigationRailDestination(
            icon: Icon(d.icon),
            selectedIcon: Icon(d.selectedIcon),
            label: Text(d.label),
          ),
      ],
    );
  }
}
