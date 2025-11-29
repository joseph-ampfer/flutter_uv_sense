import 'package:flutter_test/flutter_test.dart';
import 'package:simple_app/models/data_models.dart';
import 'package:simple_app/providers/skin_type_provider.dart';
import 'package:simple_app/data/mock_data.dart';

void main() {
  group('SkinTypeProvider', () {
    late SkinTypeProvider provider;

    setUp(() {
      provider = SkinTypeProvider();
    });

    test('should initialize with medium skin type as default', () {
      expect(provider.selectedSkinType, isNotNull);
      expect(provider.selectedSkinType.id, '3');
      expect(provider.selectedSkinType.name, 'Medium');
      expect(provider.selectedSkinType.burnTime, 15);
    });

    test('should update skin type', () {
      final newSkinType = skinTypes[0]; // Very Fair
      
      provider.updateSkinType(newSkinType);

      expect(provider.selectedSkinType, newSkinType);
      expect(provider.selectedSkinType.id, '1');
      expect(provider.selectedSkinType.name, 'Very Fair');
    });

    test('should update skin type to Fair', () {
      final fairSkinType = skinTypes[1]; // Fair
      
      provider.updateSkinType(fairSkinType);

      expect(provider.selectedSkinType.id, '2');
      expect(provider.selectedSkinType.name, 'Fair');
      expect(provider.selectedSkinType.burnTime, 10);
    });

    test('should update skin type to Olive', () {
      final oliveSkinType = skinTypes[3]; // Olive
      
      provider.updateSkinType(oliveSkinType);

      expect(provider.selectedSkinType.id, '4');
      expect(provider.selectedSkinType.name, 'Olive');
      expect(provider.selectedSkinType.burnTime, 20);
    });

    test('should update skin type to Brown', () {
      final brownSkinType = skinTypes[4]; // Brown
      
      provider.updateSkinType(brownSkinType);

      expect(provider.selectedSkinType.id, '5');
      expect(provider.selectedSkinType.name, 'Brown');
      expect(provider.selectedSkinType.burnTime, 25);
    });

    test('should update skin type to Dark', () {
      final darkSkinType = skinTypes[5]; // Dark
      
      provider.updateSkinType(darkSkinType);

      expect(provider.selectedSkinType.id, '6');
      expect(provider.selectedSkinType.name, 'Dark');
      expect(provider.selectedSkinType.burnTime, 30);
    });

    test('should notify listeners when skin type is updated', () {
      var notified = false;
      
      provider.addListener(() {
        notified = true;
      });

      provider.updateSkinType(skinTypes[0]);

      expect(notified, true);
    });

    test('should notify listeners each time skin type changes', () {
      var notificationCount = 0;
      
      provider.addListener(() {
        notificationCount++;
      });

      provider.updateSkinType(skinTypes[0]);
      provider.updateSkinType(skinTypes[1]);
      provider.updateSkinType(skinTypes[2]);

      expect(notificationCount, 3);
    });

    test('should allow setting same skin type multiple times', () {
      final skinType = skinTypes[0];
      var notificationCount = 0;
      
      provider.addListener(() {
        notificationCount++;
      });

      provider.updateSkinType(skinType);
      provider.updateSkinType(skinType);

      expect(notificationCount, 2);
      expect(provider.selectedSkinType, skinType);
    });

    test('should maintain skin type properties after update', () {
      final veryFairSkin = skinTypes[0];
      
      provider.updateSkinType(veryFairSkin);

      expect(provider.selectedSkinType.id, veryFairSkin.id);
      expect(provider.selectedSkinType.name, veryFairSkin.name);
      expect(provider.selectedSkinType.description, veryFairSkin.description);
      expect(provider.selectedSkinType.color, veryFairSkin.color);
      expect(provider.selectedSkinType.burnTime, veryFairSkin.burnTime);
    });

    test('should update from medium to very fair', () {
      // Starts at medium (index 2)
      expect(provider.selectedSkinType.name, 'Medium');
      
      provider.updateSkinType(skinTypes[0]);
      
      expect(provider.selectedSkinType.name, 'Very Fair');
      expect(provider.selectedSkinType.burnTime, 5);
    });

    test('should update from medium to dark', () {
      // Starts at medium (index 2)
      expect(provider.selectedSkinType.name, 'Medium');
      
      provider.updateSkinType(skinTypes[5]);
      
      expect(provider.selectedSkinType.name, 'Dark');
      expect(provider.selectedSkinType.burnTime, 30);
    });

    test('should be able to iterate through all skin types', () {
      for (var skinType in skinTypes) {
        provider.updateSkinType(skinType);
        expect(provider.selectedSkinType, skinType);
      }

      // Should end with the last skin type (Dark)
      expect(provider.selectedSkinType.name, 'Dark');
    });

    test('should remove listener without error', () {
      void listener() {}
      
      provider.addListener(listener);
      provider.removeListener(listener);
      
      // Should not throw
      provider.updateSkinType(skinTypes[0]);
      
      expect(provider.selectedSkinType.name, 'Very Fair');
    });

    test('should handle multiple listeners', () {
      var listener1Called = false;
      var listener2Called = false;
      var listener3Called = false;
      
      void listener1() {
        listener1Called = true;
      }
      
      void listener2() {
        listener2Called = true;
      }
      
      void listener3() {
        listener3Called = true;
      }
      
      provider.addListener(listener1);
      provider.addListener(listener2);
      provider.addListener(listener3);
      
      provider.updateSkinType(skinTypes[0]);
      
      expect(listener1Called, true);
      expect(listener2Called, true);
      expect(listener3Called, true);
    });

    test('should dispose without error', () {
      expect(() => provider.dispose(), returnsNormally);
    });

    test('selectedSkinType getter should return current skin type', () {
      final currentSkinType = provider.selectedSkinType;
      
      expect(currentSkinType, isA<SkinType>());
      expect(currentSkinType.name, 'Medium');
    });

    test('should preserve skin type reference after update', () {
      final targetSkin = skinTypes[3];
      
      provider.updateSkinType(targetSkin);
      
      expect(provider.selectedSkinType, same(targetSkin));
    });
  });
}

