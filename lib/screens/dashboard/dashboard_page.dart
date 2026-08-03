import 'package:flutter/material.dart';

import '../../services/customer_service.dart';
import '../../widgets/dashboard_card.dart';
import '../customers/customers_page.dart';
import '../payments/payments_page.dart';
import '../memberships/memberships_page.dart';
import '../../pages/telegram_settings_page.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final customers = CustomerService.customers;

    final expiringCustomers = customers.where((customer) {
      final days = customer.endDate.difference(DateTime.now()).inDays;
      return days >= 0 && days <= 7;
    }).toList();

    final totalCustomers = customers.length;

    final activeCustomers = customers.where((customer) {
      return customer.endDate.isAfter(DateTime.now());
    }).length;

    final expiredCustomers = customers.where((customer) {
      return !customer.endDate.isAfter(DateTime.now());
    }).length;

    final totalIncome = customers.fold<double>(
      0,
      (sum, customer) => sum + customer.payment,
    );

    return Scaffold(
      backgroundColor: const Color(0xfff5f7fb),
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        title: const Text(
          "FitLife CRM",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: [
          if (expiringCustomers.isNotEmpty)
            Container(
              width: double.infinity,
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.orange.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.warning_amber_rounded,
                    color: Colors.orange,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      "${expiringCustomers.length} ta mijozning abonementi 7 kun ichida tugaydi.",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Expanded(
                  child: _StatCard(
                    icon: Icons.people,
                    color: Colors.blue,
                    value: "$totalCustomers",
                    title: "Jami mijoz",
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _StatCard(
                    icon: Icons.attach_money,
                    color: Colors.green,
                    value: totalIncome.toStringAsFixed(0),
                    title: "Tushum",
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Expanded(
                  child: _StatCard(
                    icon: Icons.check_circle,
                    color: Colors.green,
                    value: "$activeCustomers",
                    title: "Faol",
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _StatCard(
                    icon: Icons.cancel,
                    color: Colors.red,
                    value: "$expiredCustomers",
                    title: "Tugagan",
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                children: [
                  DashboardCard(
                    icon: Icons.people,
                    title: "Mijozlar",
                    color: Colors.blue,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const CustomersPage(),
                        ),
                      );
                    },
                  ),

                  DashboardCard(
                    icon: Icons.payments,
                    title: "To'lovlar",
                    color: Colors.orange,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const PaymentsPage(),
                        ),
                      );
                    },
                  ),

                  DashboardCard(
                    icon: Icons.card_membership,
                    title: "Abonementlar",
                    color: Colors.green,
                    onTap: () {
                     Navigator.push(
                      context,
                       MaterialPageRoute(
                         builder: (_) => const MembershipsPage(),
                       ),
                     );
                   },
                  ),

                  DashboardCard(
                    icon: Icons.bar_chart,
                    title: "Hisobot",
                    color: Colors.purple,
                    onTap: () {},
                  ),

     DashboardCard(
  icon: Icons.telegram,
  title: "Telegram",
  color: Colors.lightBlue,
  onTap: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const TelegramSettingsPage(),
      ),
    );
  },
),

                  DashboardCard(
                    icon: Icons.settings,
                    title: "Sozlamalar",
                    color: Colors.teal,
                    onTap: () {},
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String value;
  final String title;

  const _StatCard({
    required this.icon,
    required this.color,
    required this.value,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 18,
          horizontal: 12,
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: color,
              size: 30,
            ),
            const SizedBox(height: 10),
            Text(
              value,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 6),
            Text(title),
          ],
        ),
      ),
    );
  }
}