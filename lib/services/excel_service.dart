import 'dart:io';

import 'package:excel/excel.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';

import 'customer_service.dart';
import 'payment_service.dart';

class ExcelService {
  static Future<void> exportReport() async {
    final excel = Excel.createExcel();

    final customerSheet = excel['Customers'];

    customerSheet.appendRow([
      '№',
      'Ism',
      'Telefon',
      'Abonement',
    ]);

    final customers = CustomerService.customers;

    for (int i = 0; i < customers.length; i++) {
      final c = customers[i];

      customerSheet.appendRow([
        i + 1,
        c.name,
        c.phone,
        c.membership,
      ]);
    }

    final paymentSheet = excel['Payments'];

    paymentSheet.appendRow([
      '№',
      'Miqdor',
      'To\'lov turi',
      'Sana',
    ]);

    final payments = PaymentService.payments;

    for (int i = 0; i < payments.length; i++) {
      final p = payments[i];

      paymentSheet.appendRow([
        i + 1,
        p.amount,
        p.method,
        "${p.date.day}.${p.date.month}.${p.date.year}",
      ]);
    }

    final statSheet = excel['Statistics'];

    final totalIncome =
        payments.fold<double>(0, (sum, p) => sum + p.amount);

    statSheet.appendRow(['Ko\'rsatkich', 'Qiymat']);
    statSheet.appendRow(['Jami mijozlar', customers.length]);
    statSheet.appendRow(['Jami to\'lovlar', payments.length]);
    statSheet.appendRow(['Jami tushum', totalIncome]);

    final dir = await getApplicationDocumentsDirectory();

    final file = File("${dir.path}/FitLife_Report.xlsx");

    final bytes = excel.save();

    if (bytes != null) {
      await file.writeAsBytes(bytes);

      await OpenFile.open(file.path);
    }
  }
}