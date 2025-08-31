import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/task.dart';

class TaskService {
  // Your API base URL
//   static const String baseUrl = 'http://localhost:8080';
    static const String baseUrl = 'https://delia.onrender.com';
  
  // Fetch all tasks from the API
  static Future<List<Task>> getTasks() async {
    print('🔗 Attempting to fetch tasks from: $baseUrl/api/tasks');
    
    try {
      // Make GET request to /api/tasks
      final response = await http.get(
        Uri.parse('$baseUrl/api/tasks'),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      print('📡 Response status: ${response.statusCode}');
      print('📝 Response body: ${response.body}');

      // Check if request was successful
      if (response.statusCode == 200) {
        // Parse JSON response
        try {
          final List<dynamic> jsonList = json.decode(response.body);
          print('✅ Successfully parsed JSON. Found ${jsonList.length} tasks');
          
          // Convert each JSON object to Task object
          final List<Task> tasks = jsonList
              .map((json) => Task.fromJson(json))
              .toList();
              
          print('🎯 Successfully converted to Task objects');
          return tasks;
        } catch (parseError) {
          print('❌ JSON parsing error: $parseError');
          throw Exception('Failed to parse response as JSON: $parseError');
        }
      } else {
        // Handle error response
        print('❌ HTTP Error ${response.statusCode}: ${response.body}');
        throw Exception('HTTP ${response.statusCode}: ${response.reasonPhrase}\nResponse: ${response.body}');
      }
    } catch (e) {
      print('💥 Network/General error: $e');
      // Handle network or other errors
      if (e.toString().contains('SocketException')) {
        throw Exception('Network error: Cannot connect to server. Check your internet connection.');
      } else if (e.toString().contains('TimeoutException')) {
        throw Exception('Request timeout: Server took too long to respond.');
      } else if (e.toString().contains('FormatException')) {
        throw Exception('Invalid response format from server.');
      } else {
        throw Exception('Unexpected error: $e');
      }
    }
  }
}
