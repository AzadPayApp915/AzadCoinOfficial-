import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../theme/app_theme.dart';
import '../widgets/glass_card.dart';
import 'financial_screens.dart';
import 'program_screens.dart';

class ServicesScreen extends StatelessWidget {
  const ServicesScreen({super.key});

  static const _items = <(IconData, String)>[
    (Icons.verified_user_outlined, 'KYC Verification'),
    (Icons.groups_outlined, 'Referral'),
    (Icons.bolt_outlined, 'Mining'),
    (Icons.confirmation_number_outlined, 'Lottery'),
    (Icons.credit_card_outlined, 'AZAD Card'),
    (Icons.card_giftcard_outlined, 'Gift Code'),
    (Icons.support_agent_outlined, 'Support & AI'),
    (Icons.notifications_none, 'Notifications'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Services')),
      body: CustomScrollView(
        slivers: [
          const SliverPadding(
            padding: EdgeInsets.fromLTRB(16, 16, 16, 14),
            sliver: SliverToBoxAdapter(
              child: AzadSectionHero(
                icon: Icons.grid_view_rounded,
                title: 'Azad Services',
                subtitle: 'Secure tools connected to your Azad Coin account',
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: .94,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) => _ServiceTile(
                  icon: _items[index].$1,
                  title: _items[index].$2,
                  onTap: () => _openService(context, index),
                ),
                childCount: _items.length,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _openService(BuildContext context, int index) async {
    if (index == 0) {
      final opened = await launchUrl(
        Uri.parse('https://azad-coin.com/profile'),
        mode: LaunchMode.externalApplication,
      );
      if (!context.mounted || opened) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not open the secure KYC website.')),
      );
      return;
    }

    final Widget? page = switch (index) {
      1 => const ReferralScreen(),
      2 => const MiningScreen(),
      4 => const AzadVisaCardScreen(),
      5 => const GiftScreen(),
      _ => null,
    };
    if (page != null) {
      await Navigator.of(context).push(
        MaterialPageRoute<void>(builder: (_) => page),
      );
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${_items[index].$2} uses the Azad Coin backend.')),
    );
  }
}

class _ServiceTile extends StatelessWidget {
  const _ServiceTile({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(24),
      onTap: onTap,
      child: GlassCard(
        padding: const EdgeInsets.all(14),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 54,
              height: 54,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFFFFF6DF),
                border: Border.all(color: const Color(0xFFF1D38B)),
              ),
              child: Icon(icon, color: AppColors.gold, size: 29),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
          ],
        ),
      ),
    );
  }
}
