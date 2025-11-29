import 'package:flutter/foundation.dart';
import '../models/data_models.dart';
import '../data/mock_data.dart';

class SkinTypeProvider extends ChangeNotifier {
  SkinType _selectedSkinType = skinTypes[2]; // Medium skin type as default
  
  SkinType get selectedSkinType => _selectedSkinType;
  
  void updateSkinType(SkinType skinType) {
    _selectedSkinType = skinType;
    notifyListeners();
  }
}

