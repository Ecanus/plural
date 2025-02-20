// Constants
import 'package:plural_app/src/constants/strings.dart';

// Auth
import "package:plural_app/src/features/authentication/domain/app_user.dart";

class Garden {
  Garden({
    required this.creator,
    required this.id,
    required this.name,
  });

  final AppUser creator;
  final String id;
  final String name;

  Map toMap() {
    return {
      GardenField.creator: creator,
      GenericField.id: id,
      GardenField.name: name,
    };
  }

  static Map emptyMap() {
    return {
      GardenField.creator: null,
      GenericField.id: null,
      GardenField.name: null,
    };
  }
}