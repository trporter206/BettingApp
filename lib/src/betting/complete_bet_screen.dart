import 'package:flutter/material.dart';
import 'bet.dart';
import 'payout_utils.dart';

class CompleteBetScreen extends StatefulWidget {
  final Bet bet;

  const CompleteBetScreen({super.key, required this.bet});

  @override
  _CompleteBetScreenState createState() => _CompleteBetScreenState();
}

class _CompleteBetScreenState extends State<CompleteBetScreen> {
  late List<String> _teamOrder;
  Map<String, double> _payouts = {};

  @override
  void initState() {
    super.initState();
    _teamOrder = List.from(widget.bet.participatingTeams);
    _updatePayouts();
  }

  void _onReorder(int oldIndex, int newIndex) {
    setState(() {
      if (newIndex > oldIndex) {
        newIndex -= 1;
      }
      final item = _teamOrder.removeAt(oldIndex);
      _teamOrder.insert(newIndex, item);
      _updatePayouts();
    });
  }

  void _updatePayouts() {
    final placePortion = getPlacePortions(_teamOrder.length);

    final payouts = <String, double>{};
    for (int position = 1; position <= _teamOrder.length; position++) {
      final payout = calculatePayout(position, _teamOrder.length, widget.bet.potAmount, placePortion);
      payouts[_teamOrder[position - 1]] = payout;
    }

    setState(() {
      _payouts = payouts;
    });
  }

  void _confirmOrder() {
    print('Final Payouts:');
    for (final entry in _payouts.entries) {
      print('${entry.key}: ${entry.value.toStringAsFixed(2)}');
    }

    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Complete Bet'),
      ),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Drag and drop the teams to order them based on the results.',
              style: TextStyle(fontSize: 16.0),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            child: ReorderableListView.builder(
              itemCount: _teamOrder.length,
              itemBuilder: (BuildContext context, int index) {
                final team = _teamOrder[index];
                final payout = _payouts[team] ?? 0.0;
                final profileImageUrl = 'https://example.com/teams/$team.jpg'; // Replace with actual profile image URL
                return Container(
                  key: Key('$index'),
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundImage: NetworkImage(profileImageUrl),
                        radius: 20.0,
                      ),
                      const SizedBox(width: 16.0),
                      Expanded(child: Text(team)),
                      Text('\$${payout.toStringAsFixed(2)}'),
                      const SizedBox(width: 8.0),
                      const Icon(Icons.drag_handle),
                    ],
                  ),
                );
              },
              onReorder: _onReorder,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: _confirmOrder,
              child: const Text('Confirm Order'),
            ),
          ),
        ],
      ),
    );
  }
}