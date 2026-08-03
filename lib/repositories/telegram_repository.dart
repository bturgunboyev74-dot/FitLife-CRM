import 'package:hive_flutter/hive_flutter.dart';

class TelegramRepository {
  static const String boxName = 'telegram_settings';

  Future<Box> _openBox() async {
    return await Hive.openBox(boxName);
  }

  Future<void> saveSettings({
    required String botToken,
    required String chatId,
  }) async {
    final box = await _openBox();

    await box.put('botToken', botToken);
    await box.put('chatId', chatId);
  }

  Future<String> getBotToken() async {
    final box = await _openBox();
    return box.get('botToken', defaultValue: '');
  }

  Future<String> getChatId() async {
    final box = await _openBox();
    return box.get('chatId', defaultValue: '');
  }
}