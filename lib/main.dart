import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'api/ApiService.dart';

void main() {
  // Create an ApiService instance
  ApiService apiService = ApiService();

  // Run the app and pass the ApiService instance to MyApp
  runApp(MyApp(apiService: apiService));
}

class MyApp extends StatelessWidget {
  final ApiService apiService;

  // Constructor now accepts 'apiService'
  const MyApp({Key? key, required this.apiService}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Thunder Scout 2.0',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(apiService: apiService), // Pass apiService to MyHomePage
    );
  }
}

class MyHomePage extends StatefulWidget {
  final ApiService apiService;

  const MyHomePage({Key? key, required this.apiService}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String? selectedEvent;
  String? selectedQualification;
  List<Map<String, dynamic>> events = [];
  List<Map<String, dynamic>> qualifications = [];

  @override
  void initState() {
    super.initState();
    fetchEvents();
  }

  Future<void> fetchEvents() async {
    final response = await http.get(Uri.parse('https://www.thebluealliance.com/api/v3/events/2024')); // Example event year
    if (response.statusCode == 200) {
      setState(() {
        events = List<Map<String, dynamic>>.from(json.decode(response.body));
      });
    } else {
      // Handle error
      print('Failed to load events');
    }
  }

  Future<void> fetchQualifications(String eventKey) async {
    final response = await http.get(Uri.parse('https://www.thebluealliance.com/api/v3/event/$eventKey/matches'));
    if (response.statusCode == 200) {
      setState(() {
        qualifications = List<Map<String, dynamic>>.from(json.decode(response.body));
      });
    } else {
      // Handle error
      print('Failed to load qualifications');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thunder Scout 2.0'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Select Event:"),
              DropdownButton<String>(
                value: selectedEvent?.isNotEmpty == true ? selectedEvent : null, // Prevent selecting empty value
                hint: const Text("Choose an event"),
                items: events.map((event) {
                  return DropdownMenuItem<String>(
                    value: event['key']?.toString() ?? '', // Ensure a non-null string
                    child: Text(event['name'] ?? 'No Name'), // Handle null name
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedEvent = value;
                    qualifications = []; // Reset qualifications
                  });
                  if (value != null) fetchQualifications(value);
                },
              ),
              const SizedBox(height: 20),
              const Text("Select Qualification:"),
              DropdownButton<String>(
                value: selectedQualification?.isNotEmpty == true ? selectedQualification : null, // Prevent selecting empty value
                hint: const Text("Choose a qualification"),
                items: qualifications.map((qualification) {
                  return DropdownMenuItem<String>(
                    value: qualification['key']?.toString() ?? '',
                    child: Text(qualification['name'] ?? 'No Name'),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedQualification = value;
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
