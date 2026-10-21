import 'package:flutter/material.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1240),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Good to see you',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                'Here is the current overview of your campaign operations.',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: const Color(0xFF667085),
                    ),
              ),
              const SizedBox(height: 24),
              LayoutBuilder(
                builder: (context, constraints) {
                  final columns = constraints.maxWidth >= 900
                      ? 4
                      : constraints.maxWidth >= 560
                          ? 2
                          : 1;
                  const gap = 14.0;
                  final width =
                      (constraints.maxWidth - gap * (columns - 1)) / columns;
                  return Wrap(
                    spacing: gap,
                    runSpacing: gap,
                    children: [
                      MetricCard(
                        width: width,
                        label: 'Active campaigns',
                        value: '12',
                        note: 'Across 4 regions',
                        icon: Icons.campaign_outlined,
                      ),
                      MetricCard(
                        width: width,
                        label: 'Booths mapped',
                        value: '86',
                        note: 'Of 120 planned',
                        icon: Icons.location_on_outlined,
                      ),
                      MetricCard(
                        width: width,
                        label: 'Upcoming events',
                        value: '08',
                        note: 'Next 14 days',
                        icon: Icons.event_outlined,
                      ),
                      MetricCard(
                        width: width,
                        label: 'Team members',
                        value: '34',
                        note: 'Across all campaigns',
                        icon: Icons.groups_outlined,
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 24),
              LayoutBuilder(
                builder: (context, constraints) {
                  if (constraints.maxWidth < 760) {
                    return const Column(
                      children: [
                        ActivityPanel(),
                        SizedBox(height: 16),
                        QuickActionsPanel(),
                      ],
                    );
                  }
                  return const Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(flex: 3, child: ActivityPanel()),
                      SizedBox(width: 16),
                      Expanded(flex: 2, child: QuickActionsPanel()),
                    ],
                  );
                },
              ),
              const SizedBox(height: 18),
              const DemoNotice(),
            ],
          ),
        ),
      ),
    );
  }
}

class MetricCard extends StatelessWidget {
  const MetricCard({
    required this.width,
    required this.label,
    required this.value,
    required this.note,
    required this.icon,
    super.key,
  });

  final double width;
  final String label;
  final String value;
  final String note;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              const SizedBox(height: 18),
              Text(
                value,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
              ),
              const SizedBox(height: 4),
              Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: 4),
              Text(
                note,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: const Color(0xFF667085),
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ActivityPanel extends StatelessWidget {
  const ActivityPanel({super.key});

  @override
  Widget build(BuildContext context) {
    const activities = [
      (
        'Field report submitted',
        'Demo area · 25 minutes ago',
        Icons.assignment_turned_in_outlined,
      ),
      (
        'New event scheduled',
        'Community meeting · Today',
        Icons.event_available_outlined,
      ),
      (
        'Campaign updated',
        'Outreach planning · Yesterday',
        Icons.campaign_outlined,
      ),
    ];

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Recent activity',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            for (final activity in activities) ...[
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: CircleAvatar(
                  backgroundColor:
                      Theme.of(context).colorScheme.secondaryContainer,
                  child: Icon(activity.$3),
                ),
                title: Text(activity.$1),
                subtitle: Text(activity.$2),
              ),
              if (activity != activities.last) const Divider(height: 8),
            ],
          ],
        ),
      ),
    );
  }
}

class QuickActionsPanel extends StatelessWidget {
  const QuickActionsPanel({super.key});

  @override
  Widget build(BuildContext context) {
    const actions = [
      ('Create campaign', Icons.add_circle_outline),
      ('Schedule an event', Icons.calendar_month_outlined),
      ('Add booth report', Icons.assignment_outlined),
      ('Manage team', Icons.person_add_alt_outlined),
    ];

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Quick actions',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 10),
            for (final action in actions)
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Icon(
                  action.$2,
                  color: Theme.of(context).colorScheme.primary,
                ),
                title: Text(action.$1),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      '${action.$1} is a placeholder until its workflow is built.',
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class DemoNotice extends StatelessWidget {
  const DemoNotice({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF7E6),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFF1D69B)),
      ),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.info_outline, color: Color(0xFF946200)),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              'Demo data only. Authentication, API services, and persistent storage are not connected yet.',
              style: TextStyle(color: Color(0xFF694A00)),
            ),
          ),
        ],
      ),
    );
  }
}
