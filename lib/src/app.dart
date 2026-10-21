import 'package:flutter/material.dart';

import 'campaigns_page.dart';
import 'dashboard_page.dart';
import 'placeholder_page.dart';
import 'theme.dart';

class PoliticalAdvisoryApp extends StatelessWidget {
  const PoliticalAdvisoryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Political Advisory',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      home: const DashboardShell(),
    );
  }
}

class DashboardShell extends StatefulWidget {
  const DashboardShell({super.key});

  @override
  State<DashboardShell> createState() => _DashboardShellState();
}

class _DashboardShellState extends State<DashboardShell> {
  int _selectedIndex = 0;

  static const _items = <NavItem>[
    NavItem('Dashboard', Icons.space_dashboard_outlined),
    NavItem('Campaigns', Icons.campaign_outlined),
    NavItem('Booths', Icons.location_on_outlined),
    NavItem('Events', Icons.event_outlined),
    NavItem('Teams', Icons.groups_outlined),
    NavItem('Analytics', Icons.query_stats_outlined),
    NavItem('Settings', Icons.settings_outlined),
  ];

  @override
  Widget build(BuildContext context) {
    final wide = MediaQuery.sizeOf(context).width >= 820;
    final page = _selectedIndex == 0
        ? const DashboardPage()
        : _selectedIndex == 1
            ? const CampaignsPage()
            : PlaceholderPage(
                title: _items[_selectedIndex].label,
                icon: _items[_selectedIndex].icon,
              );

    return Scaffold(
      appBar: AppBar(
        title: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.account_balance_outlined, size: 25),
            SizedBox(width: 10),
            Text(
              'Political Advisory',
              style: TextStyle(fontWeight: FontWeight.w800),
            ),
          ],
        ),
        actions: [
          IconButton(
            tooltip: 'Notifications',
            onPressed: () => _notify('Notifications are not connected yet.'),
            icon: const Icon(Icons.notifications_none),
          ),
          const Padding(
            padding: EdgeInsets.only(right: 20),
            child: CircleAvatar(
              radius: 17,
              child: Icon(Icons.person_outline, size: 20),
            ),
          ),
        ],
      ),
      body: Row(
        children: [
          if (wide)
            NavigationRail(
              selectedIndex: _selectedIndex,
              onDestinationSelected: _select,
              labelType: NavigationRailLabelType.all,
              destinations: _items
                  .map(
                    (item) => NavigationRailDestination(
                      icon: Icon(item.icon),
                      label: Text(item.label),
                    ),
                  )
                  .toList(),
            ),
          if (wide) const VerticalDivider(width: 1),
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 160),
              child: KeyedSubtree(
                key: ValueKey<int>(_selectedIndex),
                child: page,
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: wide
          ? null
          : NavigationBar(
              selectedIndex: _selectedIndex < 4 ? _selectedIndex : 0,
              onDestinationSelected: (index) {
                if (index < 4) {
                  _select(index);
                } else {
                  _showMoreMenu();
                }
              },
              destinations: const [
                NavigationDestination(
                  icon: Icon(Icons.space_dashboard_outlined),
                  label: 'Home',
                ),
                NavigationDestination(
                  icon: Icon(Icons.campaign_outlined),
                  label: 'Campaigns',
                ),
                NavigationDestination(
                  icon: Icon(Icons.location_on_outlined),
                  label: 'Booths',
                ),
                NavigationDestination(
                  icon: Icon(Icons.menu),
                  label: 'More',
                ),
              ],
            ),
    );
  }

  void _select(int index) {
    setState(() => _selectedIndex = index);
  }

  void _showMoreMenu() {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (sheetContext) => SafeArea(
        child: ListView(
          shrinkWrap: true,
          children: [
            for (var i = 4; i < _items.length; i++)
              ListTile(
                leading: Icon(_items[i].icon),
                title: Text(_items[i].label),
                onTap: () {
                  Navigator.pop(sheetContext);
                  _select(i);
                },
              ),
          ],
        ),
      ),
    );
  }

  void _notify(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}

class NavItem {
  const NavItem(this.label, this.icon);

  final String label;
  final IconData icon;
}
