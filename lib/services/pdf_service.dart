import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import 'customer_service.dart';
import 'payment_service.dart';

class PdfService {
  static Future<void> generateReport() async {
    final pdf = pw.Document();

    final customers = CustomerService.customers;
    final payments = PaymentService.payments;

    final totalIncome = payments.fold<double>(
      0,
      (sum, p) => sum + p.amount,
    );

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [

              pw.Text(
                "FitLife CRM Report",
                style: pw.TextStyle(
                  fontSize: 24,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),

              pw.SizedBox(height: 20),

              pw.Text("Jami mijozlar: ${customers.length}"),
              pw.Text("Jami to'lovlar: ${payments.length}"),
              pw.Text(
                "Jami tushum: ${totalIncome.toStringAsFixed(0)} so'm",
              ),

              pw.SizedBox(height: 30),

              pw.Text(
                "Mijozlar ro'yxati",
                style: pw.TextStyle(
                  fontSize: 18,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),

              pw.SizedBox(height: 10),

              ...customers.map(
                (c) => pw.Text(
                  "${c.name} • ${c.phone} • ${c.membership}",
                ),
              ),
            ],
          );
        },
      ),
    );

    await Printing.layoutPdf(
      onLayout: (format) async => pdf.save(),
    );
  }
}