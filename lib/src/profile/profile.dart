class Profile {
  final String userId;
  final String name;
  final String email;
  final String imageUrl;
  List<String> bettingHistory;
  bool isVerified;

  Profile({
    required this.name,
    required this.email,
    required this.imageUrl,
    required this.userId,
    this.bettingHistory = const [],
    this.isVerified = false,
  });
}
