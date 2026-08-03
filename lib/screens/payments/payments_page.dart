import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../models/customer.dart';
import '../../models/payment.dart';
import '../../services/customer_service.dart';
import '../../services/payment_service.dart';
import 'add_payment_page.dart';

class PaymentsPage extends StatelessWidget {
  const PaymentsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("To'lovlar"),
      ),

      body: ValueListenableBuilder(
        valueListenable: PaymentService.box.listenable(),
        builder: (context, Box<Payment> box, _) {
          final payments = PaymentService.payments;

          if (payments.isEmpty) {
            return const Center(
              child: Text(
                "Hozircha to'lovlar mavjud emas",
                style: TextStyle(fontSize: 18),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: payments.length,
            itemBuilder: (context, index) {
              final payment = payments[index];

              Customer? customer;

              try {
                customer = CustomerService.customers.firstWhere(
                  (c) => c.id == payment.customerId,
                );
              } catch (_) {
                customer = null;
              }

              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  leading: const CircleAvatar(
                    child: Icon(Icons.payments),
                  ),

                  title: Text(
                    customer?.name ?? "Noma'lum mijoz",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Usul: ${payment.method}"),
                      Text("Sana: ${payment.date.day}.${payment.date.month}.${payment.date.year}"),
                    ],
                  ),

                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "${payment.amount.toStringAsFixed(0)} so'm",
                        style: const TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.delete,
                          color: Colors.red,
                        ),
                        onPressed: () async {
                          await PaymentService.deletePayment(index);
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),

      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const AddPaymentPage(),
            ),
          );
        },
      ),
    );
  }
}