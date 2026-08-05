import 'dart:io';

import 'package:flutter/material.dart';

import '../../services/backup_service.dart';

class BackupPage extends StatefulWidget {
  const BackupPage({super.key});

  @override
  State<BackupPage> createState() => _BackupPageState();
}

class _BackupPageState extends State<BackupPage> {
  String? backupPath;

  Future<void> _createBackup() async {
    final path = await BackupService.createBackup();

    if (!mounted) return;

    if (path == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("❌ Backup yaratishda xatolik yuz berdi"),
        ),
      );
      return;
    }

    setState(() {
      backupPath = path;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("✅ Backup muvaffaqiyatli yaratildi\n\n$path"),
      ),
    );
  }

  Future<void> _restoreBackup() async {
    File? file = await BackupService.pickBackupFile();

    if (!mounted) return;

    if (file == null) return;

    setState(() {
      backupPath = file.path;
    });

    final restored = await BackupService.restoreBackup(file);

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          restored
              ? "✅ Backup muvaffaqiyatli tiklandi"
              : "❌ Backupni tiklab bo'lmadi",
        ),
      ),
    );
  }

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
          "Backup",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Card(
            elevation: 3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
            child: ListTile(
              leading: const CircleAvatar(
                backgroundColor: Colors.green,
                child: Icon(
                  Icons.backup,
                  color: Colors.white,
                ),
              ),
              title: const Text(
                "Backup yaratish",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: const Text(
                "Barcha mijozlar va to'lovlarni JSON faylga saqlaydi",
              ),
              trailing: ElevatedButton(
                onPressed: _createBackup,
                child: const Text("Yaratish"),
              ),
            ),
          ),

          const SizedBox(height: 20),

          Card(
            elevation: 3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
            child: ListTile(
              leading: const CircleAvatar(
                backgroundColor: Colors.orange,
                child: Icon(
                  Icons.restore,
                  color: Colors.white,
                ),
              ),
              title: const Text(
                "Backup tiklash",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: const Text(
                "JSON backup faylni tanlang",
              ),
              trailing: ElevatedButton(
                onPressed: _restoreBackup,
                child: const Text("Tiklash"),
              ),
            ),
          ),

          const SizedBox(height: 20),

          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
            child: ListTile(
              leading: const CircleAvatar(
                backgroundColor: Colors.blue,
                child: Icon(
                  Icons.insert_drive_file,
                  color: Colors.white,
                ),
              ),
              title: const Text(
                "Oxirgi backup",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(
                backupPath ?? "Hali backup yaratilmagan",
              ),
            ),
          ),

          const SizedBox(height: 25),

          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
            child: const Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                children: [
                  Icon(
                    Icons.info_outline,
                    size: 40,
                    color: Colors.blue,
                  ),
                  SizedBox(height: 15),
                  Text(
                    "Backup funksiyasi barcha mijozlar va to'lovlarni JSON fayl ko'rinishida saqlaydi.\n\n"
                    "Restore funksiyasi orqali ushbu fayldan ma'lumotlarni qayta tiklash mumkin.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}