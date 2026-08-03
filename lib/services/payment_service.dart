import 'package:hive_flutter/hive_flutter.dart';

import '../models/payment.dart';

class PaymentService {
  static Box<Payment> get box =>
      Hive.box<Payment>('payments');

  static List<Payment> get payments =>
      box.values.toList();

  static Future<void> addPayment(
    Payment payment,
  ) async {
    await box.add(payment);
  }

  static Future<void> deletePayment(
    int index,
  ) async {
    await box.deleteAt(index);
  }

  static List<Payment> paymentsByCustomer(
    String customerId,
  ) {
    return payments
        .where((payment) =>
            payment.customerId == customerId)
        .toList();
  }

  static double totalByCustomer(
    String customerId,
  ) {
    return paymentsByCustomer(customerId)
        .fold(
      0,
      (sum, payment) => sum + payment.amount,
    );
  }
}
