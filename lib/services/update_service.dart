import 'dart:convert';

import 'package:http/http.dart' as http;

class UpdateService {
  static const String owner = "bturgunboyev74-dot";
  static const String repo = "FitLife-CRM";

  static Future<Map<String, dynamic>?> checkForUpdate() async {
    try {
      final url = Uri.parse(
        "https://api.github.com/repos/$owner/$repo/releases/latest",
      );

      final response = await http.get(url);

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }

      return null;
    } catch (e) {
      return null;
    }
  }
}