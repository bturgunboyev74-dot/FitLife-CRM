import 'package:flutter/material.dart';

import '../../services/customer_service.dart';
import '../../services/payment_service.dart';

import '../../widgets/dashboard_card.dart';
import '../../widgets/income_chart.dart';

import '../customers/customers_page.dart';
import '../payments/payments_page.dart';
import '../memberships/memberships_page.dart';

import '../../pages/telegram_settings_page.dart';
import '../settings/settings_page.dart';
import 'package:fitlife_crm/pages/update_page.dart';
import '../reports/reports_page.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final customers = CustomerService.customers;

    final expiringCustomers = customers.where((customer) {
      final days =
          customer.endDate.difference(DateTime.now()).inDays;
      return days >= 0 && days <= 7;
    }).toList();

    final totalCustomers = customers.length;

    final activeCustomers = customers.where((customer) {
      return customer.endDate.isAfter(DateTime.now());
    }).length;

    final expiredCustomers = customers.where((customer) {
      return !customer.endDate.isAfter(DateTime.now());
    }).length;

    final totalIncome = PaymentService.payments.fold<double>(
      0,
      (sum, payment) => sum + payment.amount,
    );

    final todayIncome = PaymentService.payments
        .where(
          (payment) =>
              payment.date.year == DateTime.now().year &&
              payment.date.month == DateTime.now().month &&
              payment.date.day == DateTime.now().day,
        )
        .fold<double>(
          0,
          (sum, payment) => sum + payment.amount,
        );

    final monthIncome = PaymentService.payments
        .where(
          (payment) =>
              payment.date.year == DateTime.now().year &&
              payment.date.month == DateTime.now().month,
        )
        .fold<double>(
          0,
          (sum, payment) => sum + payment.amount,
        );

    return Scaffold(
      backgroundColor: const Color(0xffF4F7FC),

      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.blue.shade700,
        foregroundColor: Colors.white,

        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "FitLife CRM",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 22,
              ),
            ),
            Text(
              "${DateTime.now().day}.${DateTime.now().month}.${DateTime.now().year}",
              style: const TextStyle(fontSize: 12),
            ),
          ],
        ),

        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.notifications_none),
          ),
          const SizedBox(width: 8),
        ],
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [Container(
  width: double.infinity,
  padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
  decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(24),
    gradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        Colors.blue.shade800,
        Colors.blue.shade600,
        Colors.lightBlue.shade400,
      ],
    ),
    boxShadow: [
      BoxShadow(
        color: Colors.blue.withOpacity(0.25),
        blurRadius: 20,
        offset: const Offset(0, 10),
      ),
    ],
  ),
  child: Row(
    children: [
      Container(
        width: 90,
        height: 90,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Image.asset(
            "assets/images/logo.png",
            fit: BoxFit.contain,
          ),
        ),
      ),

      const SizedBox(width: 20),

      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Assalomu alaykum 👋",
              style: TextStyle(
                color: Colors.white70,
                fontSize: 18,
              ),
            ),

            const SizedBox(height: 6),

            const Text(
              "Administrator",
              style: TextStyle(
                color: Colors.white,
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 18),

            Text(
              "💰 Bugungi tushum: ${todayIncome.toStringAsFixed(0)} so'm",
              style: const TextStyle(
                color: Colors.white,
                fontSize: 17,
              ),
            ),

            const SizedBox(height: 6),

            Text(
              "📅 Oylik tushum: ${monthIncome.toStringAsFixed(0)} so'm",
              style: const TextStyle(
                color: Colors.white,
                fontSize: 17,
              ),
            ),
          ],
        ),
      ),

      Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.18),
          shape: BoxShape.circle,
        ),
        child: const Icon(
          Icons.notifications_active,
          color: Colors.white,
          size: 30,
        ),
      ),
    ],
  ),
),

const SizedBox(height: 20),

if (expiringCustomers.isNotEmpty)
  Container(
    width: double.infinity,
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.orange.shade100,
      borderRadius: BorderRadius.circular(18),
      border: Border.all(
        color: Colors.orange.shade300,
      ),
    ),
    child: Row(
      children: [
        const Icon(
          Icons.warning_amber_rounded,
          color: Colors.orange,
          size: 36,
        ),
        const SizedBox(width: 15),
        Expanded(
          child: Text(
            "${expiringCustomers.length} ta mijozning abonementi 7 kun ichida tugaydi.",
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
      ],
    ),
  ),

const SizedBox(height: 22),

const Text(
  "Statistika",
  style: TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.bold,
  ),
),

const SizedBox(height: 15),

Row(
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
        title: "Jami tushum",
      ),
    ),
  ],
),

const SizedBox(height: 12),

Row(
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

const SizedBox(height: 25),

const Text(
  "Oxirgi 7 kun statistikasi",
  style: TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.bold,
  ),
),

const SizedBox(height: 15),

Card(
  elevation: 4,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(20),
  ),
  child: const Padding(
    padding: EdgeInsets.all(20),
    child: IncomeChart(),
  ),
),

const SizedBox(height: 25),
const Align(
  alignment: Alignment.centerLeft,
  child: Text(
    "So'nggi qo'shilgan mijozlar",
    style: TextStyle(
      fontSize: 22,
      fontWeight: FontWeight.bold,
    ),
  ),
),

const SizedBox(height: 15),

SizedBox(
  height: 120,
  child: ListView.builder(
    scrollDirection: Axis.horizontal,
    itemCount: customers.length > 5 ? 5 : customers.length,
    itemBuilder: (context, index) {
      final customer = customers.reversed.toList()[index];

      return Container(
        width: 270,
        margin: const EdgeInsets.only(right: 15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: ListTile(
          leading: CircleAvatar(
            radius: 26,
            backgroundColor: Colors.blue.shade100,
            child: const Icon(
              Icons.person,
              color: Colors.blue,
            ),
          ),
          title: Text(
            customer.name,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: Text(customer.phone),
          trailing: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.check_circle,
                color: Colors.green,
              ),
              const SizedBox(height: 4),
              Text(
                customer.membership,
                style: const TextStyle(
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ),
      );
    },
  ),
),

const SizedBox(height: 25),

const Align(
  alignment: Alignment.centerLeft,
  child: Text(
    "Oxirgi to'lovlar",
    style: TextStyle(
      fontSize: 22,
      fontWeight: FontWeight.bold,
    ),
  ),
),

const SizedBox(height: 15),

SizedBox(
  height: 260,
  child: Card(
    elevation: 3,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(18),
    ),
    child: ListView.separated(
      padding: const EdgeInsets.all(12),
      itemCount: PaymentService.payments.length > 5
          ? 5
          : PaymentService.payments.length,
      separatorBuilder: (_, __) => const Divider(),
      itemBuilder: (context, index) {
        final payment =
            PaymentService.payments.reversed.toList()[index];

        final customer = CustomerService.getCustomerById(
          payment.customerId,
        );

        return ListTile(
          leading: CircleAvatar(
            backgroundColor: Colors.green.shade100,
            child: const Icon(
              Icons.payments,
              color: Colors.green,
            ),
          ),
          title: Text(
            customer?.name ?? "Noma'lum mijoz",
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: Text(payment.method),
          trailing: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                "${payment.amount.toStringAsFixed(0)} so'm",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                "${payment.date.day}.${payment.date.month}.${payment.date.year}",
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        );
      },
    ),
  ),
),

const SizedBox(height: 25),
const Text(
  "Tezkor amallar",
  style: TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.bold,
  ),
),

const SizedBox(height: 15),

GridView.count(
  shrinkWrap: true,
  physics: const NeverScrollableScrollPhysics(),
  crossAxisCount: 2,
  crossAxisSpacing: 16,
  mainAxisSpacing: 16,
  childAspectRatio: 1.08,
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
  icon: Icons.bar_chart_rounded,
  title: "Hisobotlar",
  color: Colors.deepPurple,
  onTap: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const ReportsPage(),
      ),
    );
  },
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
  icon: Icons.system_update,
  title: "Yangilash",
  color: Colors.indigo,
  onTap: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const UpdatePage(),
      ),
    );
  },
),

DashboardCard(
  icon: Icons.settings,
  title: "Sozlamalar",
  color: Colors.teal,
  onTap: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const SettingsPage(),
      ),
    );
  },
),
],
),
const SizedBox(height: 25),
],
),
),
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
    elevation: 6,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(20),
    ),
    child: Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            color.withValues(alpha: 0.15),
            Colors.white,
          ],
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 30,
              backgroundColor: color.withValues(alpha: 0.15),
              child: Icon(
                icon,
                color: color,
                size: 32,
              ),
            ),

            const SizedBox(height: 16),

            FittedBox(
              child: Text(
                value,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 8),

            Text(
              title,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.black54,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
}