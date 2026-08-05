import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';

import '../services/customer_service.dart';
import '../services/payment_service.dart';

class BackupService {
  /// Backup yaratish
  static Future<String?> createBackup() async {
    try {
      final customers = CustomerService.customers;
      final payments = PaymentService.payments;

      final data = {
        "createdAt": DateTime.now().toIso8601String(),
        "customers": customers
            .map(
              (e) => {
                "id": e.id,
                "name": e.name,
                "phone": e.phone,
                "membership": e.membership,
                "startDate": e.startDate.toIso8601String(),
                "endDate": e.endDate.toIso8601String(),
                "payment": e.payment,
                "note": e.note,
                "photoPath": e.photoPath,
              },
            )
            .toList(),
        "payments": payments
            .map(
              (e) => {
                "customerId": e.customerId,
                "amount": e.amount,
                "date": e.date.toIso8601String(),
                "method": e.method,
                "note": e.note,
              },
            )
            .toList(),
      };

      final json = const JsonEncoder.withIndent("  ").convert(data);

      final directory = await getApplicationDocumentsDirectory();

      final file = File(
        "${directory.path}/fitlife_backup_${DateTime.now().millisecondsSinceEpoch}.json",
      );

      await file.writeAsString(json);

      return file.path;
    } catch (e) {
      return null;
    }
  }

  /// Backup faylini tanlash
  static Future<File?> pickBackupFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ["json"],
    );

    if (result == null) return null;

    final path = result.files.single.path;

    if (path == null) return null;

    return File(path);
  }

  /// Backupni tiklash
  static Future<bool> restoreBackup(File file) async {
    try {
      final jsonString = await file.readAsString();

      final Map<String, dynamic> data = jsonDecode(jsonString);

      // Hozircha faqat JSON o'qilishini tekshiramiz
      if (!data.containsKey("customers")) return false;
      if (!data.containsKey("payments")) return false;

      // Keyingi bosqichda Hive bazasiga yozamiz

      return true;
    } catch (e) {
      return false;
    }
  }
}