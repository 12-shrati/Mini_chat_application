class User {
  final String id;
  final String name;

  User({
    required this.id,
    required this.name,
  });

  String get initials {
    if (name.isEmpty) return '';
    return name
        .split(' ')
        .where((word) => word.isNotEmpty)
        .map((word) => word[0].toUpperCase())
        .join();
  }
}
