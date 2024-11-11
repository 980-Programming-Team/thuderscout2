import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:thunderscout2/main.dart';
import 'package:thunderscout2/api/ApiService.dart';

void main() {
  testWidgets('Main menu UI test', (WidgetTester tester) async {
    // Create an ApiService instance and load the API key.
    ApiService apiService = ApiService();
    await apiService.loadApiKey();

    // Build the app with the ApiService passed in.
    await tester.pumpWidget(MyApp(apiService: apiService));

    // Wait for the events to be fetched
    await tester.pumpAndSettle();

    // Verify that the event dropdown is displayed and has data.
    expect(find.byType(DropdownButton<String>), findsNWidgets(2)); // Two Dropdowns (Event and Qualification)
    expect(find.text('Select Event:'), findsOneWidget); // Ensure 'Select Event' label is present.
    expect(find.text('Select Qualification:'), findsOneWidget); // Ensure 'Select Qualification' label is present.

    // Verify that the events dropdown has items.
    expect(find.byType(DropdownMenuItem<String>), findsWidgets);
    expect(find.text('Choose an event'), findsOneWidget);

    // Simulate selecting an event
    await tester.tap(find.text('Choose an event'));
    await tester.pump(); // Rebuild after selection

    // Verify that qualifications dropdown is now visible and contains items.
    expect(find.byType(DropdownButton<String>), findsNWidgets(2));
    expect(find.text('Choose a qualification'), findsOneWidget);
    expect(find.byType(DropdownMenuItem<String>), findsWidgets);

    // Simulate selecting a qualification
    await tester.tap(find.text('Choose a qualification'));
    await tester.pump(); // Rebuild after qualification selection

    // Check that the qualification dropdown still exists after selection
    expect(find.byType(DropdownButton<String>), findsNWidgets(2));
    expect(find.text('Choose a qualification'), findsOneWidget);
  });
}
