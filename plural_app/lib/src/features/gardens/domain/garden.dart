// Constants
import 'package:plural_app/src/constants/fields.dart';

// Auth
import 'package:plural_app/src/features/authentication/domain/app_user.dart';

class Garden {
  Garden({
    required this.creator,
    required this.doDocument,
    required this.id,
    required this.name,
  });

  final AppUser creator;
  final String doDocument;
  final String id;
  final String name;

  Garden.fromJson(Map<String, dynamic> json, this.creator) :
    doDocument = json[GardenField.doDocument] as String,
    id = json[GenericField.id] as String,
    name = json[GardenField.name] as String;

  Map<String, dynamic> toMap() {
    return {
      GardenField.creator: creator.id,
      GardenField.doDocument: doDocument,
      GenericField.id: id,
      GardenField.name: name,
    };
  }

  static Map<String, dynamic> emptyMap() {
    return {
      GardenField.creator: null,
      GardenField.doDocument: null,
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

  @override
  String toString() => "Garden(id: $id, name: $name, creator: $creator)";
}