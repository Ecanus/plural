// Constants
import 'package:plural_app/src/constants/fields.dart';

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
      GardenField.creator: creator.id,
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

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Garden && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}