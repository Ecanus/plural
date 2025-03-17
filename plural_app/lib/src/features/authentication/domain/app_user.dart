class AppUser {
  AppUser({
    required this.email,
    required this.id,
    required this.username,
  });

  final String email;
  final String id;
  final String username;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is AppUser && other.id == id && other.email == email;
  }

  @override
  int get hashCode => id.hashCode ^ email.hashCode;

  @override
  String toString() => "AppUser(id: $id, username: $username, email: $email)";
}