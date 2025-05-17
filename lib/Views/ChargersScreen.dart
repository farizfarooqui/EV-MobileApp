import 'package:flutter/material.dart';

class ChargersScreen extends StatelessWidget {
  const ChargersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 12),
                Center(
                  child: Text(
                    'HELLO FARIZ 👋',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2,
                        ),
                  ),
                ),
                const SizedBox(height: 20),
                // Getting Started Card
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Theme.of(context).shadowColor.withOpacity(0.07),
                        blurRadius: 16,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'GETTING STARTED WITH EVigo',
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5,
                            ),
                      ),
                      const SizedBox(height: 18),
                      _GettingStartedRow(
                        icon: Icons.directions_car,
                        title: 'Add a vehicle',
                        subtitle:
                            'Benefit from features compatible with your vehicle (Autocharge, reservation, etc...)',
                        onTap: () {},
                        showDot: true,
                      ),
                      const SizedBox(height: 12),
                      _GettingStartedRow(
                        icon: Icons.credit_card,
                        title: 'Add payment method',
                        subtitle:
                            'Save time by adding your payment method before you hit the road',
                        onTap: () {},
                        showDot: true,
                      ),
                    ],
                  ),
                ),
                // CO2 Avoided Card
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Theme.of(context).shadowColor.withOpacity(0.07),
                        blurRadius: 16,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('CO2 AVOIDED',
                                style: Theme.of(context)
                                    .textTheme
                                    .labelMedium
                                    ?.copyWith(
                                      color: Theme.of(context).hintColor,
                                      fontWeight: FontWeight.bold,
                                    )),
                            const SizedBox(height: 4),
                            Text('0.00 kg',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleLarge
                                    ?.copyWith(fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                      Icon(Icons.eco,
                          color: Theme.of(context).colorScheme.primary),
                    ],
                  ),
                ),
                // Charge Section
                const SizedBox(height: 8),
                Text('CHARGE',
                    style: Theme.of(context)
                        .textTheme
                        .titleSmall
                        ?.copyWith(fontWeight: FontWeight.bold)),
                Card(
                  color: Theme.of(context).cardColor,
                  elevation: 0,
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                  child: ListTile(
                    leading: Icon(Icons.flash_on,
                        color: Theme.of(context).colorScheme.primary),
                    title: const Text('Sessions & reservations'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {},
                  ),
                ),

                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _GettingStartedRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final bool showDot;
  const _GettingStartedRow({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.showDot = false,
  });
  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          children: [
            Icon(icon, color: Theme.of(context).colorScheme.primary),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(title,
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge
                              ?.copyWith(fontWeight: FontWeight.bold)),
                      if (showDot)
                        const Padding(
                          padding: EdgeInsets.only(left: 4.0),
                          child: Icon(Icons.circle, color: Colors.red, size: 8),
                        ),
                    ],
                  ),
                  Text(subtitle, style: Theme.of(context).textTheme.bodySmall),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 18),
          ],
        ),
      ),
    );
  }
}

class _ProfileRow extends StatelessWidget {
  final IconData icon;
  final String text;
  final VoidCallback onTap;
  const _ProfileRow(
      {required this.icon, required this.text, required this.onTap});
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: Theme.of(context).colorScheme.primary),
      title: Text(text),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}
