// bet.dart

import 'package:intl/intl.dart';

class Bet {
  final String title;
  final double potAmount;
  final List<String> participatingTeams;
  final double buyInAmount;
  final DateTime createdAt;

  Bet({
    required this.title,
    required this.potAmount,
    required this.participatingTeams,
    required this.buyInAmount,
    required this.createdAt,
  });

  String get formattedCreatedAt {
    final formatter = DateFormat('MMMM d, y');
    return formatter.format(createdAt);
  }
}
