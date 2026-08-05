import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF4F7FC),

      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        title: const Text(
          "Sozlamalar",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [

          const SizedBox(height: 5),

          const Center(
            child: CircleAvatar(
              radius: 42,
              backgroundColor: Colors.blue,
              child: Icon(
                Icons.settings,
                color: Colors.white,
                size: 42,
              ),
            ),
          ),

          const SizedBox(height: 15),

          const Center(
            child: Text(
              "FitLife CRM",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          const Center(
            child: Text(
              "Version 1.0",
              style: TextStyle(
                color: Colors.grey,
              ),
            ),
          ),

          const SizedBox(height: 30),

          _item(
            context,
            Icons.person,
            "Administrator",
          ),

          _item(
            context,
            Icons.dark_mode,
            "Dark Mode",
          ),

          _item(
            context,
            Icons.notifications,
            "Bildirishnomalar",
          ),

          _item(
            context,
            Icons.backup,
            "Backup",
          ),

          _item(
            context,
            Icons.upload_file,
            "Export",
          ),

          _item(
            context,
            Icons.download,
            "Import",
          ),

          _item(
            context,
            Icons.info,
            "Dastur haqida",
          ),

          const SizedBox(height: 25),

          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              minimumSize: const Size(
                double.infinity,
                52,
              ),
            ),
            onPressed: () {},
            icon: const Icon(Icons.delete),
            label: const Text(
              "Barcha ma'lumotlarni tozalash",
            ),
          ),
        ],
      ),
    );
  }

  Widget _item(
    BuildContext context,
    IconData icon,
    String title,
  ) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.blue.shade100,
          child: Icon(
            icon,
            color: Colors.blue,
          ),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          size: 18,
        ),
        onTap: () {},
      ),
    );
  }
}