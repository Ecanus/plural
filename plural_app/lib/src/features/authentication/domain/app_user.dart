class AppUser {
  const AppUser({
    required this.uid,
    required this.email,
    required this.password,
    required this.firstName,
    required this.lastName,
  });

  final String uid;
  final String email;
  final String password;
  final String firstName;
  final String lastName;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is AppUser && other.uid == uid && other.email == email;
  }

  @override
  int get hashCode => uid.hashCode ^ email.hashCode;

  @override
  String toString() => 'AppUser(uid: $uid, email: $email)';
}