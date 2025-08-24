import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:online_medicine/widgets/quantity_selector.dart';

void main() {
  group('QuantitySelector Tests', () {
    testWidgets('should display predefined quantity options', (WidgetTester tester) async {
      const quantityOptions = [1, 2, 3, 5, 10];
      int selectedQuantity = 1;
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: QuantitySelector(
              quantityOptions: quantityOptions,
              selectedQuantity: selectedQuantity,
              onQuantitySelected: (quantity) {
                selectedQuantity = quantity;
              },
              unitName: 'Box',
            ),
          ),
        ),
      );

      // Check if predefined options are displayed
      for (final quantity in quantityOptions) {
        expect(find.text('$quantity Box${quantity > 1 ? 's' : ''}'), findsOneWidget);
      }

      // Check if custom quantity option is displayed
      expect(find.text('Custom: '), findsOneWidget);
      expect(find.byType(TextField), findsOneWidget);
    });

    testWidgets('should select predefined quantity option', (WidgetTester tester) async {
      const quantityOptions = [1, 2, 3, 5, 10];
      int selectedQuantity = 1;
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: QuantitySelector(
              quantityOptions: quantityOptions,
              selectedQuantity: selectedQuantity,
              onQuantitySelected: (quantity) {
                selectedQuantity = quantity;
              },
              unitName: 'Box',
            ),
          ),
        ),
      );

      // Tap on quantity 5
      await tester.tap(find.text('5 Boxes'));
      await tester.pumpAndSettle();

      // Tap Apply button
      await tester.tap(find.text('Apply'));
      await tester.pumpAndSettle();

      // Verify the selected quantity
      expect(selectedQuantity, equals(5));
    });

    testWidgets('should handle custom quantity input', (WidgetTester tester) async {
      const quantityOptions = [1, 2, 3, 5, 10];
      int selectedQuantity = 1;
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: QuantitySelector(
              quantityOptions: quantityOptions,
              selectedQuantity: selectedQuantity,
              onQuantitySelected: (quantity) {
                selectedQuantity = quantity;
              },
              unitName: 'Box',
            ),
          ),
        ),
      );

      // Tap on custom quantity option
      await tester.tap(find.text('Custom: '));
      await tester.pumpAndSettle();

      // Enter custom quantity
      await tester.enterText(find.byType(TextField), '25');
      await tester.pumpAndSettle();

      // Tap Apply button
      await tester.tap(find.text('Apply'));
      await tester.pumpAndSettle();

      // Verify the selected quantity
      expect(selectedQuantity, equals(25));
    });

    testWidgets('should show error for empty custom quantity', (WidgetTester tester) async {
      const quantityOptions = [1, 2, 3, 5, 10];
      int selectedQuantity = 1;
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: QuantitySelector(
              quantityOptions: quantityOptions,
              selectedQuantity: selectedQuantity,
              onQuantitySelected: (quantity) {
                selectedQuantity = quantity;
              },
              unitName: 'Box',
            ),
          ),
        ),
      );

      // Tap on custom quantity option
      await tester.tap(find.text('Custom: '));
      await tester.pumpAndSettle();

      // Leave custom quantity field empty and tap Apply
      await tester.tap(find.text('Apply'));
      await tester.pumpAndSettle();

      // Verify error message is shown
      expect(find.text('Please enter a quantity'), findsOneWidget);
    });

    testWidgets('should show error for invalid custom quantity', (WidgetTester tester) async {
      const quantityOptions = [1, 2, 3, 5, 10];
      int selectedQuantity = 1;
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: QuantitySelector(
              quantityOptions: quantityOptions,
              selectedQuantity: selectedQuantity,
              onQuantitySelected: (quantity) {
                selectedQuantity = quantity;
              },
              unitName: 'Box',
            ),
          ),
        ),
      );

      // Tap on custom quantity option
      await tester.tap(find.text('Custom: '));
      await tester.pumpAndSettle();

      // Enter invalid quantity (0)
      await tester.enterText(find.byType(TextField), '0');
      await tester.pumpAndSettle();

      // Tap Apply button
      await tester.tap(find.text('Apply'));
      await tester.pumpAndSettle();

      // Verify error message is shown
      expect(find.text('Please enter a valid quantity'), findsOneWidget);
    });

    testWidgets('should handle pre-selected custom quantity', (WidgetTester tester) async {
      const quantityOptions = [1, 2, 3, 5, 10];
      const selectedQuantity = 25; // Custom quantity not in predefined options
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: QuantitySelector(
              quantityOptions: quantityOptions,
              selectedQuantity: selectedQuantity,
              onQuantitySelected: (quantity) {
                // Do nothing for this test
              },
              unitName: 'Box',
            ),
          ),
        ),
      );

      // Verify that custom quantity field shows the pre-selected value
      expect(find.text('25'), findsOneWidget);
    });
  });
}
