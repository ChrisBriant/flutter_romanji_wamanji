import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:loggy/loggy.dart';

String baseUrl = "https://10.0.2.2:8000";


class NetworkServices {
  static Future<Map<String,dynamic>?> addNewVerbApi(String englishText) async {
    try {
      Uri url = Uri.parse('$baseUrl/translate/addnewverb');

      final Map<String,dynamic> body = {
        "verb" : englishText 
      };

      final res = await http.post(url,headers: {
        "Content-Type": "application/json"
      },body: jsonEncode(body)).timeout(const Duration(seconds: 5));

      logInfo("RESPONSE ${res.statusCode}");

      if (res.statusCode == 200) {
        final Map<String, dynamic> data =
            Map<String, dynamic>.from(jsonDecode(res.body));
        return data;
      }
    } catch (err) {
        logError("ERROR: $err");
    }

    return null;

  }
}