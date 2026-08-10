import 'package:flutter/material.dart';

import '../../services/customer_service.dart';
import '../../services/payment_service.dart';
import '../../services/pdf_service.dart';
import '../../services/excel_service.dart';

class ReportsPage extends StatelessWidget {
  const ReportsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final customers = CustomerService.customers;
    final payments = PaymentService.payments;

    final today = DateTime.now();

    final todayIncome = payments
        .where((p) =>
            p.date.year == today.year &&
            p.date.month == today.month &&
            p.date.day == today.day)
        .fold<double>(0, (sum, p) => sum + p.amount);

    final monthIncome = payments
        .where((p) =>
            p.date.year == today.year &&
            p.date.month == today.month)
        .fold<double>(0, (sum, p) => sum + p.amount);

    final totalIncome =
        payments.fold<double>(0, (sum, p) => sum + p.amount);

    final activeCustomers = customers
        .where((c) => c.endDate.isAfter(today))
        .length;

    return Scaffold(
      backgroundColor: const Color(0xffF4F7FC),
      appBar: AppBar(
        title: const Text("Hisobotlar"),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [

          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: 15,
            mainAxisSpacing: 15,
            childAspectRatio: 1.3,
            children: [

              _statCard(
                "Bugungi tushum",
                "${todayIncome.toStringAsFixed(0)} so'm",
                Icons.today,
                Colors.blue,
              ),

              _statCard(
                "Oylik tushum",
                "${monthIncome.toStringAsFixed(0)} so'm",
                Icons.calendar_month,
                Colors.green,
              ),

              _statCard(
                "Jami tushum",
                "${totalIncome.toStringAsFixed(0)} so'm",
                Icons.payments,
                Colors.orange,
              ),

              _statCard(
                "Faol mijozlar",
                "$activeCustomers",
                Icons.people,
                Colors.deepPurple,
              ),
            ],
          ),

          const SizedBox(height: 30),

          _reportCard(
            context,
            Icons.today,
            Colors.blue,
            "Bugungi tushum",
            "Bugungi barcha to'lovlarni ko'rish",
          ),

          const SizedBox(height: 15),

          _reportCard(
            context,
            Icons.calendar_month,
            Colors.green,
            "Oylik tushum",
            "Oylik statistika",
          ),

          const SizedBox(height: 15),

          _reportCard(
            context,
            Icons.bar_chart,
            Colors.orange,
            "Statistika",
            "Grafiklar va hisobotlar",
          ),

          const SizedBox(height: 15),

          _reportCard(
            context,
            Icons.picture_as_pdf,
            Colors.red,
            "PDF eksport",
            "Hisobotni PDF formatida saqlash",
            onTap: () async {
              await PdfService.generateReport();
            },
          ),

          const SizedBox(height: 15),

          _reportCard(
            context,
            Icons.table_chart,
            Colors.teal,
            "Excel eksport",
            "Excel hisobot yaratish",
            onTap: () async {
              await ExcelService.exportReport();
            },
          ),
        ],
      ),
    );
  }

  Widget _statCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            CircleAvatar(
              radius: 24,
              backgroundColor: color.withOpacity(0.15),
              child: Icon(
                icon,
                color: color,
                size: 28,
              ),
            ),

            const SizedBox(height: 12),

            Text(
              value,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 6),

            Text(
              title,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _reportCard(
    BuildContext context,
    IconData icon,
    Color color,
    String title,
    String subtitle, {
    VoidCallback? onTap,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withOpacity(0.15),
          child: Icon(
            icon,
            color: color,
          ),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: onTap ??
            () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("$title moduli ishlab chiqilmoqda"),
                ),
              );
            },
      ),
    );
  }
}