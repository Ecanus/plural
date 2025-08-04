// Invitations
import 'package:plural_app/src/features/invitations/domain/invitation.dart';

/// Returns the [InvitationType] enum that corresponds to [typeString].
InvitationType? getInvitationTypeFromString(String typeString) {
  try {
    return InvitationType.values.firstWhere(
      (a) => a.name == typeString
    );
  } on StateError {
    return null;
  }
}