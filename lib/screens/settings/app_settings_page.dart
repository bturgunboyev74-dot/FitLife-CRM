import 'package:flutter/material.dart';

class AppSettingsPage extends StatefulWidget {
  const AppSettingsPage({super.key});

  @override
  State<AppSettingsPage> createState() => _AppSettingsPageState();
}

class _AppSettingsPageState extends State<AppSettingsPage> {
  bool darkMode = false;
  bool notifications = true;
  bool telegramNotifications = true;
  bool autoBackup = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF4F7FC),
      appBar: AppBar(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        title: const Text("Dastur sozlamalari"),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
            child: Column(
              children: [
                SwitchListTile(
                  secondary: const Icon(Icons.dark_mode),
                  title: const Text("Dark Mode"),
                  subtitle: const Text("Qorong'i mavzuni yoqish"),
                  value: darkMode,
                  onChanged: (value) {
                    setState(() {
                      darkMode = value;
                    });
                  },
                ),
                const Divider(height: 1),
                SwitchListTile(
                  secondary: const Icon(Icons.notifications),
                  title: const Text("Bildirishnomalar"),
                  subtitle: const Text("Dastur bildirishnomalarini yoqish"),
                  value: notifications,
                  onChanged: (value) {
                    setState(() {
                      notifications = value;
                    });
                  },
                ),
                const Divider(height: 1),
                SwitchListTile(
                  secondary: const Icon(Icons.telegram),
                  title: const Text("Telegram xabarlari"),
                  subtitle: const Text("Telegram orqali ogohlantirish"),
                  value: telegramNotifications,
                  onChanged: (value) {
                    setState(() {
                      telegramNotifications = value;
                    });
                  },
                ),
                const Divider(height: 1),
                SwitchListTile(
                  secondary: const Icon(Icons.backup),
                  title: const Text("Avtomatik Backup"),
                  subtitle: const Text("Har kuni avtomatik backup yaratish"),
                  value: autoBackup,
                  onChanged: (value) {
                    setState(() {
                      autoBackup = value;
                    });
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: 25),

          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
            child: const ListTile(
              leading: Icon(Icons.info, color: Colors.blue),
              title: Text("FitLife CRM"),
              subtitle: Text(
                "Versiya: 1.0.0\nDeveloper: FitLife Team",
              ),
            ),
          ),
        ],
      ),
    );
  }
}