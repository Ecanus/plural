// Constants
import 'package:plural_app/src/constants/strings.dart';

// Auth
import "package:plural_app/src/features/authentication/domain/app_user.dart";

class Garden {
  Garden({
    required this.id,
    required this.creator,
    required this.name,
  });

  final String id;
  final AppUser creator;
  final String name;

  Map toMap() {
    return {
      GenericField.id: id,
      GardenField.creator: creator,
      GardenField.name: name,
    };
  }

  static Map emptyMap() {
    return {
      GenericField.id: null,
      GardenField.creator: null,
      GardenField.name: null,
    };
  }
}