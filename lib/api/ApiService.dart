import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

class ApiService {
  String? apiKey;

  // Load API key from config.json
  Future<void> loadApiKey() async {
    try {
      final String response = await rootBundle.loadString('assets/config.json');
      final Map<String, dynamic> config = jsonDecode(response);

      if (config.containsKey('api_key') && config['api_key'] is String) {
        apiKey = config['api_key'];
        if (apiKey == null || apiKey!.isEmpty) {
          throw Exception("API key is empty.");
        }
      } else {
        throw Exception("API key is missing or not a valid string.");
      }
    } catch (e) {
      print("Error loading API key: $e");
      apiKey = null; // Fallback in case of failure
    }
  }

  // Fetch events for a specific year from the API
  Future<List<dynamic>> fetchEvents(int year) async {
    if (apiKey == null) {
      print("Error: API key is not available.");
      return []; // Return an empty list if API key is missing
    }

    try {
      // Construct the full URL for events for the specific year
      final Uri url = Uri.parse('https://www.thebluealliance.com/api/v3/events/$year');
      print('Requesting URL: $url'); // Debugging: log the URL

      final response = await http.get(url, headers: {
        HttpHeaders.acceptHeader: 'application/json', // Accept header for JSON response
        'X-TBA-Auth-Key': apiKey!,  // Correct header for the API key
      });

      print('Response status: ${response.statusCode}'); // Debugging: log the status code
      print('Response body: ${response.body}'); // Debugging: log the body of the response

      if (response.statusCode == 200) {
        return jsonDecode(response.body) as List<dynamic>;
      } else {
        print("Error fetching events: ${response.statusCode}");
        return [];
      }
    } catch (e) {
      print("Error fetching events: $e");
      return []; // Return an empty list on error
    }
  }

  // Fetch qualifications for a given event from the API
  Future<List<dynamic>> fetchQualifications(String eventKey) async {
    if (apiKey == null) {
      print("Error: API key is not available.");
      return []; // Return an empty list if API key is missing
    }

    try {
      // Correct URL for fetching qualifications (matches) for a specific event
      final Uri url = Uri.parse('https://www.thebluealliance.com/api/v3/event/$eventKey/matches');
      print('Requesting URL: $url'); // Debugging: log the URL

      final response = await http.get(url, headers: {
        HttpHeaders.acceptHeader: 'application/json', // Accept header for JSON response
        'X-TBA-Auth-Key': apiKey!,  // Correct header for the API key
      });

      print('Response status: ${response.statusCode}'); // Debugging: log the status code
      print('Response body: ${response.body}'); // Debugging: log the body of the response

      if (response.statusCode == 200) {
        return jsonDecode(response.body) as List<dynamic>;
      } else {
        print("Error fetching qualifications: ${response.statusCode}");
        return [];
      }
    } catch (e) {
      print("Error fetching qualifications: $e");
      return []; // Return an empty list on error
    }
  }
}