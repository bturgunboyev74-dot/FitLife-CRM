import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../services/update_service.dart';

class UpdatePage extends StatefulWidget {
  const UpdatePage({super.key});

  @override
  State<UpdatePage> createState() => _UpdatePageState();
}

class _UpdatePageState extends State<UpdatePage> {
  Map<String, dynamic>? release;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadRelease();
  }

  Future<void> loadRelease() async {
    release = await UpdateService.checkForUpdate();

    setState(() {
      loading = false;
    });
  }

  Future<void> download() async {
    if (release == null) return;

    if (release!["assets"].isEmpty) return;

    final url = release!["assets"][0]["browser_download_url"];

    await launchUrl(
      Uri.parse(url),
      mode: LaunchMode.externalApplication,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Ilovani yangilash"),
      ),
      body: loading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : release == null
              ? const Center(
                  child: Text("Internet mavjud emas"),
                )
              : Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Oxirgi versiya",
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        release!["tag_name"],
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(release!["body"] ?? ""),
                      const Spacer(),
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton.icon(
                          onPressed: download,
                          icon: const Icon(Icons.download),
                          label: const Text("Yangilashni yuklab olish"),
                        ),
                      )
                    ],
                  ),
                ),
    );
  }
}