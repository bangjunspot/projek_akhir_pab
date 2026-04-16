class Profile {
  final String id;
  final String email;
  final String role;

  Profile({
    required this.id,
    required this.email,
    required this.role,
  });

  factory Profile.fromMap(Map<String, dynamic> map) {
    return Profile(
      id: map['id'].toString(),
      email: (map['email'] ?? '').toString(),
      role: (map['role'] ?? 'kasir').toString(),
    );
  }
}
