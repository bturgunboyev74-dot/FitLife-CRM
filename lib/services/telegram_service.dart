import 'package:http/http.dart' as http;

import '../models/customer.dart';
import '../repositories/telegram_repository.dart';
import '../models/payment.dart';

class TelegramService {
  final TelegramRepository _repository = TelegramRepository();

  Future<bool> sendMessage({
    required String text,
  }) async {
    try {
      final botToken = await _repository.getBotToken();
      final chatId = await _repository.getChatId();

      if (botToken.isEmpty || chatId.isEmpty) {
        return false;
      }

      final url = Uri.parse(
        "https://api.telegram.org/bot$botToken/sendMessage",
      );

      final response = await http.post(
        url,
        body: {
          "chat_id": chatId,
          "text": text,
        },
      );

      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  Future<bool> sendNewCustomer(Customer customer) async {
    final message = """
🆕 Yangi mijoz qo'shildi

👤 Ismi: ${customer.name}

📞 Telefon: ${customer.phone}

💳 Abonement: ${customer.membership}

💰 To'lov: ${customer.payment.toStringAsFixed(0)} so'm

📅 Tugaydi:
${customer.endDate.day.toString().padLeft(2, '0')}.
${customer.endDate.month.toString().padLeft(2, '0')}.
${customer.endDate.year}
""";

    return await sendMessage(text: message);
  }
  Future<bool> sendPayment({
  required Customer customer,
  required Payment payment,
}) async {
  final message = """
💰 Yangi to'lov

👤 Mijoz:
${customer.name}

💵 Summa:
${payment.amount.toStringAsFixed(0)} so'm

💳 To'lov turi:
${payment.method}

📅 Yangi tugash sanasi:
${customer.endDate.day.toString().padLeft(2, '0')}.
${customer.endDate.month.toString().padLeft(2, '0')}.
${customer.endDate.year}
""";

  return await sendMessage(text: message);
}

}