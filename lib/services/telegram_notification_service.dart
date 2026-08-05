import '../models/customer.dart';
import '../services/customer_service.dart';
import 'telegram_service.dart';

class TelegramNotificationService {
  final TelegramService telegramService = TelegramService();

  Future<void> checkExpiringMemberships() async {
    final customers = CustomerService.customers;

    final now = DateTime.now();

    for (Customer customer in customers) {
      final days = customer.endDate.difference(now).inDays;

      if (days != 7 &&
          days != 5 &&
          days != 3 &&
          days != 1) {
        continue;
      }

      // Bugun allaqachon xabar yuborilganmi?
      if (customer.lastNotificationDate != null) {
        final last = customer.lastNotificationDate!;

        if (last.year == now.year &&
            last.month == now.month &&
            last.day == now.day) {
          continue;
        }
      }

      final success = await telegramService.sendMessage(
        text: """
⚠️ Abonement muddati tugamoqda

👤 ${customer.name}

📞 ${customer.phone}

💳 Abonement:
${customer.membership}

⏳ $days kun qoldi

📅 Tugash sanasi:
${customer.endDate.day.toString().padLeft(2, '0')}.
${customer.endDate.month.toString().padLeft(2, '0')}.
${customer.endDate.year}

FitLife CRM
""",
      );

      if (success) {
        customer.lastNotificationDate = now;
        await customer.save();
      }
    }
  }
}