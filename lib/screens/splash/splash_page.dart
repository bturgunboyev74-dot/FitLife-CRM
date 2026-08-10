import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:fitlife_crm/pages/update_page.dart';

import '../../services/update_service.dart';
import '../dashboard/dashboard_page.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    startApp();
  }

  Future<void> startApp() async {
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    final hasUpdate = await checkUpdate();

    if (!mounted) return;

    if (!hasUpdate) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const DashboardPage(),
        ),
      );
    }
  }

  Future<bool> checkUpdate() async {
    final release = await UpdateService.checkForUpdate();

    if (release == null) return false;

    final package = await PackageInfo.fromPlatform();

    final currentVersion = package.version;
    final latestVersion =
        release["tag_name"].toString().replaceAll("v", "");

    if (currentVersion != latestVersion && mounted) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => AlertDialog(
          title: const Text("Yangi versiya mavjud"),
          content: Text(
            "Joriy versiya: $currentVersion\n"
            "Yangi versiya: $latestVersion\n\n"
            "Ilovani yangilashni xohlaysizmi?",
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);

                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const DashboardPage(),
                  ),
                );
              },
              child: const Text("Keyinroq"),
            ),
            FilledButton.icon(
              icon: const Icon(Icons.system_update),
              label: const Text("Yangilash"),
              onPressed: () {
                Navigator.pop(context);

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const UpdatePage(),
                  ),
                );
              },
            ),
          ],
        ),
      );

      return true;
    }

    return false;
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}