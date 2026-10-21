import 'package:flutter/material.dart';

class CampaignsPage extends StatefulWidget {
  const CampaignsPage({super.key});

  @override
  State<CampaignsPage> createState() => _CampaignsPageState();
}

class _CampaignsPageState extends State<CampaignsPage> {
  final _searchController = TextEditingController();
  String _statusFilter = 'All';
  final List<_Campaign> _campaigns = [
    _Campaign(name: 'Ward Connect 2026', region: 'Pune West', owner: 'Campaign Team', status: 'Active', progress: 0.68),
    _Campaign(name: 'Community Outreach', region: 'Pimpri-Chinchwad', owner: 'Field Operations', status: 'Planning', progress: 0.18),
    _Campaign(name: 'Youth Engagement Drive', region: 'Pune Central', owner: 'Volunteer Network', status: 'Active', progress: 0.42),
    _Campaign(name: 'Local Issues Survey', region: 'Haveli', owner: 'Research Team', status: 'Completed', progress: 1),
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final query = _searchController.text.trim().toLowerCase();
    final visible = _campaigns.where((campaign) {
      final matchesQuery = [campaign.name, campaign.region, campaign.owner]
          .any((value) => value.toLowerCase().contains(query));
      return matchesQuery &&
          (_statusFilter == 'All' || campaign.status == _statusFilter);
    }).toList();

    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        Wrap(
          alignment: WrapAlignment.spaceBetween,
          runSpacing: 12,
          spacing: 16,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Campaign management', style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w800)),
                const SizedBox(height: 6),
                Text('Plan, track, and manage your field campaigns.', style: Theme.of(context).textTheme.bodyMedium),
              ],
            ),
            FilledButton.icon(
              onPressed: _createCampaign,
              icon: const Icon(Icons.add),
              label: const Text('New campaign'),
            ),
          ],
        ),
        const SizedBox(height: 24),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            _summaryCard('Total campaigns', _campaigns.length.toString(), Icons.campaign_outlined),
            _summaryCard('Active', _campaigns.where((c) => c.status == 'Active').length.toString(), Icons.trending_up, color: Colors.green),
            _summaryCard('Planning', _campaigns.where((c) => c.status == 'Planning').length.toString(), Icons.edit_calendar_outlined, color: Colors.orange),
            _summaryCard('Completed', _campaigns.where((c) => c.status == 'Completed').length.toString(), Icons.task_alt, color: Colors.blue),
          ],
        ),
        const SizedBox(height: 24),
        TextField(
          controller: _searchController,
          onChanged: (_) => setState(() {}),
          decoration: const InputDecoration(
            prefixIcon: Icon(Icons.search),
            hintText: 'Search campaigns, regions, or owners',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          children: ['All', 'Active', 'Planning', 'Completed'].map((status) {
            return ChoiceChip(
              label: Text(status == 'All' ? 'All statuses' : status),
              selected: _statusFilter == status,
              onSelected: (_) => setState(() => _statusFilter = status),
            );
          }).toList(),
        ),
        const SizedBox(height: 16),
        if (visible.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 48),
            child: Center(child: Text('No campaigns match your search.')),
          )
        else
          ...visible.map(_campaignCard),
        const SizedBox(height: 12),
        const Text('Demo data only — campaigns are not yet saved to a backend.', style: TextStyle(color: Colors.grey)),
      ],
    );
  }

  Widget _summaryCard(String label, String value, IconData icon, {Color? color}) {
    return SizedBox(
      width: 205,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              CircleAvatar(backgroundColor: (color ?? Theme.of(context).colorScheme.primary).withValues(alpha: 0.12), child: Icon(icon, color: color ?? Theme.of(context).colorScheme.primary)),
              const SizedBox(width: 12),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(value, style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)), Text(label)])),
            ],
          ),
        ),
      ),
    );
  }

  Widget _campaignCard(_Campaign campaign) {
    final color = switch (campaign.status) {
      'Active' => Colors.green,
      'Planning' => Colors.orange,
      _ => Colors.blue,
    };
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(child: Text(campaign.name, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold))),
                PopupMenuButton<String>(
                  tooltip: 'Campaign actions',
                  onSelected: (action) {
                    if (action == 'delete') _deleteCampaign(campaign);
                    if (action == 'status') _cycleStatus(campaign);
                  },
                  itemBuilder: (_) => const [
                    PopupMenuItem(value: 'status', child: Text('Change status')),
                    PopupMenuItem(value: 'delete', child: Text('Delete campaign')),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text('${campaign.region}  •  Owner: ${campaign.owner}'),
            const SizedBox(height: 14),
            Row(children: [
              Chip(label: Text(campaign.status), visualDensity: VisualDensity.compact, backgroundColor: color.withValues(alpha: 0.12), side: BorderSide.none),
              const Spacer(),
              Text('${(campaign.progress * 100).round()}% complete', style: Theme.of(context).textTheme.bodySmall),
            ]),
            const SizedBox(height: 4),
            LinearProgressIndicator(value: campaign.progress, minHeight: 7, borderRadius: BorderRadius.circular(8)),
          ],
        ),
      ),
    );
  }

  Future<void> _createCampaign() async {
    final formKey = GlobalKey<FormState>();
    final name = TextEditingController();
    final region = TextEditingController();
    final owner = TextEditingController();
    var status = 'Planning';

    final campaign = await showDialog<_Campaign>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Create campaign'),
          content: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: SizedBox(
                width: 420,
                child: Column(mainAxisSize: MainAxisSize.min, children: [
                  TextFormField(controller: name, decoration: const InputDecoration(labelText: 'Campaign name'), validator: (v) => v == null || v.trim().isEmpty ? 'Enter a campaign name' : null),
                  TextFormField(controller: region, decoration: const InputDecoration(labelText: 'Region / constituency'), validator: (v) => v == null || v.trim().isEmpty ? 'Enter a region' : null),
                  TextFormField(controller: owner, decoration: const InputDecoration(labelText: 'Owner / team'), validator: (v) => v == null || v.trim().isEmpty ? 'Enter an owner' : null),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    value: status,
                    decoration: const InputDecoration(labelText: 'Status'),
                    items: const ['Planning', 'Active', 'Completed'].map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
                    onChanged: (value) => setDialogState(() => status = value ?? 'Planning'),
                  ),
                ]),
              ),
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(dialogContext), child: const Text('Cancel')),
            FilledButton(onPressed: () {
              if (formKey.currentState!.validate()) {
                Navigator.pop(dialogContext, _Campaign(name: name.text.trim(), region: region.text.trim(), owner: owner.text.trim(), status: status, progress: status == 'Completed' ? 1 : 0));
              }
            }, child: const Text('Create')),
          ],
        ),
      ),
    );
    name.dispose();
    region.dispose();
    owner.dispose();
    if (campaign != null && mounted) setState(() => _campaigns.insert(0, campaign));
  }

  Future<void> _deleteCampaign(_Campaign campaign) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete campaign?'),
        content: Text('Delete "${campaign.name}" from this demo?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
          FilledButton(onPressed: () => Navigator.pop(context, true), child: const Text('Delete')),
        ],
      ),
    );
    if (confirmed == true && mounted) setState(() => _campaigns.remove(campaign));
  }

  void _cycleStatus(_Campaign campaign) {
    setState(() {
      final index = ['Planning', 'Active', 'Completed'].indexOf(campaign.status);
      campaign.status = ['Planning', 'Active', 'Completed'][(index + 1) % 3];
      if (campaign.status == 'Completed') campaign.progress = 1;
      if (campaign.status == 'Planning' && campaign.progress == 1) campaign.progress = 0;
    });
  }
}

class _Campaign {
  _Campaign({required this.name, required this.region, required this.owner, required this.status, required this.progress});

  final String name;
  final String region;
  final String owner;
  String status;
  double progress;
}
