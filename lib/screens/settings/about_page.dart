import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF4F7FC),
      appBar: AppBar(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        centerTitle: true,
        title: const Text(
          "Dastur haqida",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            CircleAvatar(
              radius: 55,
              backgroundColor: Colors.blue.shade100,
              child: const Icon(
                Icons.fitness_center,
                size: 60,
                color: Colors.blue,
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              "FitLife CRM",
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 5),

            const Text(
              "Fitness Club Management System",
              style: TextStyle(
                color: Colors.grey,
                fontSize: 16,
              ),
            ),

            const SizedBox(height: 30),

            _infoTile(
              Icons.verified,
              "Versiya",
              "1.0.0",
            ),

            _infoTile(
              Icons.person,
              "Developer",
              "FitLife Team",
            ),

            _infoTile(
              Icons.code,
              "Framework",
              "Flutter",
            ),

            _infoTile(
              Icons.storage,
              "Database",
              "Hive",
            ),

            _infoTile(
              Icons.update,
              "Oxirgi yangilanish",
              "2026",
            ),

            const SizedBox(height: 30),

            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
              child: const Padding(
                padding: EdgeInsets.all(20),
                child: Text(
                  "FitLife CRM fitness markazlarini boshqarish uchun ishlab chiqilgan zamonaviy dasturdir.\n\n"
                  "Dastur yordamida mijozlar, abonementlar, to'lovlar va hisobotlarni bir joydan boshqarish mumkin.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    height: 1.6,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 30),

            const Text(
              "© 2026 FitLife CRM\nBarcha huquqlar himoyalangan.",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Widget _infoTile(
    IconData icon,
    String title,
    String value,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.blue.shade100,
          child: Icon(
            icon,
            color: Colors.blue,
          ),
        ),
        title: Text(title),
        trailing: Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}