import 'package:flutter_test/flutter_test.dart';
import 'package:health_and_medicine/models/cart_list_models.dart';

void main() {
  group('CartListModels Tests', () {
    test('should parse new API response format with comma-separated values', () {
      // Arrange - New API response format
      final jsonResponse = {
        "status": "200",
        "message": "Cart items retrieved successfully",
        "data": {
          "items": [
            {
              "cart_item_id": 78,
              "product_id": 176,
              "product_name": "3-C 200 (3 C 200) (12 Pcs) 200mg",
              "brand": "edruc Ltd.",
              "mrp_price_single": "420.00",
              "sale_price_single": "203.98",
              "discount_percentage": "51.43%",
              "cart_quantity": 2,
              "mrp_price": "840.00",
              "sale_price": "407.96",
              "image_url": null
            },
            {
              "cart_item_id": 79,
              "product_id": 175,
              "product_name": "3 F 500(20 Pcs) 500 mg",
              "brand": "edruc Ltd.",
              "mrp_price_single": "320.00",
              "sale_price_single": "154.22",
              "discount_percentage": "51.81%",
              "cart_quantity": 2,
              "mrp_price": "640.00",
              "sale_price": "308.44",
              "image_url": null
            }
          ],
          "summary": {
            "total_items": 2,
            "subtotal": "1,480.00",
            "discount": "763.60",
            "total_amount": "716.40"
          }
        }
      };

      // Act
      final cartListResponse = CartListResponse.fromJson(jsonResponse);

      // Assert
      expect(cartListResponse.success, true);
      expect(cartListResponse.message, "Cart items retrieved successfully");
      expect(cartListResponse.data, isNotNull);
      
      final data = cartListResponse.data!;
      expect(data.items.length, 2);
      
      // Test first item parsing
      final firstItem = data.items[0];
      expect(firstItem.cartItemId, 78);
      expect(firstItem.productId, 176);
      expect(firstItem.productName, "3-C 200 (3 C 200) (12 Pcs) 200mg");
      expect(firstItem.brand, "edruc Ltd.");
      expect(firstItem.mrpPriceSingle, 420.00);
      expect(firstItem.salePriceSingle, 203.98);
      expect(firstItem.discountPercentage, "51.43%");
      expect(firstItem.cartQuantity, 2);
      expect(firstItem.mrpPrice, 840.00);
      expect(firstItem.salePrice, 407.96);
      expect(firstItem.imageUrl, null);
      
      // Test summary parsing with comma-separated values
      final summary = data.summary;
      expect(summary.totalItems, 2);
      expect(summary.subtotal, 1480.00); // Should parse "1,480.00" to 1480.00
      expect(summary.discount, 763.60);   // Should parse "763.60" to 763.60
      expect(summary.totalAmount, 716.40); // Should parse "716.40" to 716.40
    });

    test('should handle numeric values without commas', () {
      // Arrange - API response with numeric values (backward compatibility)
      final jsonResponse = {
        "status": "200",
        "message": "Cart items retrieved successfully",
        "data": {
          "items": [],
          "summary": {
            "total_items": 0,
            "subtotal": 0.0,
            "discount": 0.0,
            "total_amount": 0.0
          }
        }
      };

      // Act
      final cartListResponse = CartListResponse.fromJson(jsonResponse);

      // Assert
      expect(cartListResponse.success, true);
      final summary = cartListResponse.data!.summary;
      expect(summary.subtotal, 0.0);
      expect(summary.discount, 0.0);
      expect(summary.totalAmount, 0.0);
    });

    test('should handle null values gracefully', () {
      // Arrange - API response with null values
      final jsonResponse = {
        "status": "200",
        "message": "Cart items retrieved successfully",
        "data": {
          "items": [],
          "summary": {
            "total_items": 0,
            "subtotal": null,
            "discount": null,
            "total_amount": null
          }
        }
      };

      // Act
      final cartListResponse = CartListResponse.fromJson(jsonResponse);

      // Assert
      expect(cartListResponse.success, true);
      final summary = cartListResponse.data!.summary;
      expect(summary.subtotal, 0.0);
      expect(summary.discount, 0.0);
      expect(summary.totalAmount, 0.0);
    });

    test('should calculate discount percentage correctly', () {
      // Arrange
      final summary = CartSummary(
        totalItems: 2,
        subtotal: 1480.00,
        discount: 763.60,
        totalAmount: 716.40,
      );

      // Act
      final discountPercentage = summary.discountPercentage;

      // Assert
      expect(discountPercentage, closeTo(34.04, 0.01)); // ~34.04%
    });
  });
}
