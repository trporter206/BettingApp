// payout_utils.dart

double calculatePayout(int placePosition, int numTeams, double potSize, Map<int, double> placePortion) {
  final payout = placePortion[placePosition]! * potSize;
  return payout;
}

Map<int, double> getPlacePortions(int numTeams) {
  final placePortions = {
    2: {1: 1.0, 2: 0.0},
    3: {1: 0.7, 2: 0.3, 3: 0.0},
    4: {1: 0.6, 2: 0.3, 3: 0.1, 4: 0.0},
    5: {1: 0.5, 2: 0.25, 3: 0.15, 4: 0.1, 5: 0.0},
    6: {1: 0.44, 2: 0.25, 3: 0.15, 4: 0.1, 5: 0.06, 6: 0.0},
    7: {1: 0.37, 2: 0.22, 3: 0.16, 4: 0.12, 5: 0.08, 6: 0.05, 7: 0.0},
    8: {1: 0.32, 2: 0.2, 3: 0.15, 4: 0.12, 5: 0.09, 6: 0.07, 7: 0.05, 8: 0.0},
    9: {1: 0.31, 2: 0.19, 3: 0.14, 4: 0.11, 5: 0.09, 6: 0.07, 7: 0.05, 8: 0.04, 9: 0.0},
    10: {1: 0.27, 2: 0.18, 3: 0.14, 4: 0.11, 5: 0.09, 6: 0.07, 7: 0.06, 8: 0.05, 9: 0.03, 10: 0.0},
  };
  return placePortions[numTeams]!;
}