import 'package:flutter/material.dart';

import '../repositories/telegram_repository.dart';
import '../services/telegram_service.dart';

class TelegramSettingsPage extends StatefulWidget {
  const TelegramSettingsPage({super.key});

  @override
  State<TelegramSettingsPage> createState() =>
      _TelegramSettingsPageState();
}

class _TelegramSettingsPageState extends State<TelegramSettingsPage> {
  final _tokenController = TextEditingController();
  final _chatIdController = TextEditingController();

  final TelegramRepository repository = TelegramRepository();
  final TelegramService telegramService = TelegramService();

  @override
  void initState() {
    super.initState();
    loadSettings();
  }

  Future<void> loadSettings() async {
    _tokenController.text = await repository.getBotToken();
    _chatIdController.text = await repository.getChatId();

    if (mounted) {
      setState(() {});
    }
  }

  Future<void> saveSettings() async {
    await repository.saveSettings(
      botToken: _tokenController.text.trim(),
      chatId: _chatIdController.text.trim(),
    );

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("✅ Telegram sozlamalari saqlandi"),
      ),
    );
  }

  Future<void> sendTestMessage() async {
    final success = await telegramService.sendMessage(
      text: "🎉 FitLife CRM muvaffaqiyatli ulandi!\n\nBu test xabari.",
    );

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          success
              ? "✅ Test xabari yuborildi."
              : "❌ Xabar yuborilmadi.",
        ),
      ),
    );
  }

  @override
  void dispose() {
    _tokenController.dispose();
    _chatIdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Telegram Sozlamalari"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _tokenController,
              decoration: const InputDecoration(
                labelText: "Bot Token",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.key),
              ),
            ),

            const SizedBox(height: 16),

            TextField(
              controller: _chatIdController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Administrator Chat ID",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.person),
              ),
            ),

            const SizedBox(height: 24),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                onPressed: saveSettings,
                icon: const Icon(Icons.save),
                label: const Text("Saqlash"),
              ),
            ),

            const SizedBox(height: 12),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                onPressed: sendTestMessage,
                icon: const Icon(Icons.send),
                label: const Text("Test yuborish"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}