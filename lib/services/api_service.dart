import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/constants.dart';

class ApiService {
  Future<String> fetchRandomMessage() async {
    try {
      final response = await http
          .get(
            Uri.parse('${AppConstants.apiBaseUrl}/comments?postId=1'),
          )
          .timeout(AppConstants.apiTimeout);

      if (response.statusCode == 200) {
        final List<dynamic> comments = jsonDecode(response.body);
        if (comments.isNotEmpty) {
          final randomIndex =
              DateTime.now().millisecondsSinceEpoch % comments.length;
          return comments[randomIndex]['body'] ?? 'No message';
        }
        return 'No messages available';
      } else {
        throw Exception('Failed to fetch message: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching message: $e');
    }
  }

  Future<String> getWordDefinition(String word) async {
    try {
      final response = await http
          .get(
            Uri.parse('${AppConstants.dictionaryApiUrl}/$word'),
          )
          .timeout(AppConstants.apiTimeout);

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        if (data.isNotEmpty) {
          final definitions = data[0]['meanings'];
          if (definitions.isNotEmpty) {
            return definitions[0]['definitions'][0]['definition'] ??
                'Definition not found';
          }
        }
        return 'Definition not found';
      } else {
        return 'Word not found in dictionary';
      }
    } catch (e) {
      throw Exception('Error fetching definition: $e');
    }
  }
}
