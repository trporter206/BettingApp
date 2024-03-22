import 'package:flutter/material.dart';
// import 'package:tournament_betting/src/betting/payout_utils.dart';

import 'bet.dart';
import 'complete_bet_screen.dart';


class BettingScreen extends StatefulWidget {
  const BettingScreen({super.key});

  @override
  _BettingScreenState createState() => _BettingScreenState();
}

class _BettingScreenState extends State<BettingScreen> {
  int _numTeams = 2;
  double _buyInAmount = 0.0;
  List<Bet> _bets = [];

  void _incrementTeams() {
    setState(() {
      if (_numTeams < 10) {
        _numTeams++;
      }
    });
  }

  void _decrementTeams() {
    setState(() {
      if (_numTeams > 2) {
        _numTeams--;
      }
    });
  }

  void _createPot() {
    // Check if the buy-in amount is less than the minimum required.
    if (_buyInAmount < 5.0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Minimum buy-in amount is 5 dollars.')),
      );
      return; // Exit the method early if the buy-in amount is not enough.
    }

    if (_buyInAmount > 100.0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Maximum buy-in amount is 100 dollars.')),
      );
      return; // Exit the method early if the buy-in amount is not enough.
    }

    if (_bets.length < 3) {
      final teamBuyIns = <String, double>{};
      for (int i = 1; i <= _numTeams; i++) {
        teamBuyIns['Team $i'] = _buyInAmount;
      }

      final potSize = _buyInAmount * _numTeams;

      setState(() {
        _bets.add(Bet(
          title: 'Bet ${_bets.length + 1}',
          potAmount: potSize,
          participatingTeams: teamBuyIns.keys.toList(),
          buyInAmount: _buyInAmount,
          createdAt: DateTime.now(),
        ));
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('You can have a maximum of 3 bets at a time.')),
      );
    }
  }


  void _completeBet(int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CompleteBetScreen(bet: _bets[index]),
      ),
    ).then((result) {
      if (result != null && result) {
        setState(() {
          _bets.removeAt(index);
        });
      }
    });
  }

  void _cancelBet(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Cancel Bet'),
          content: const Text('You may receive a penalty fee for deleting the bet. Are you sure you want to cancel?'),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                setState(() {
                  _bets.removeAt(index);
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Betting'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Create a New Pot',
              style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16.0),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Buy-in Amount',
              ),
              keyboardType: TextInputType.number,
              onChanged: (value) {
                setState(() {
                  _buyInAmount = double.tryParse(value) ?? 0.0;
                });
              },
            ),
            const SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Number of Teams'),
                Row(
                  children: [
                    IconButton(
                      onPressed: _decrementTeams,
                      icon: const Icon(Icons.remove),
                    ),
                    Text(_numTeams.toString()),
                    IconButton(
                      onPressed: _incrementTeams,
                      icon: const Icon(Icons.add),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _createPot,
              child: const Text('Start New Bet'),
            ),
            const SizedBox(height: 16.0),
            Expanded(
              child: ListView.builder(
                itemCount: _bets.length,
                itemBuilder: (context, index) {
                  final bet = _bets[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Bet ${index + 1} Details:',
                            style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8.0),
                          Text('Pot Amount: \$${bet.potAmount.toStringAsFixed(2)}'),
                          const SizedBox(height: 4.0),
                          const Text('Participating Teams:'),
                          const SizedBox(height: 4.0),
                          SizedBox(
                            height: 50.0,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: bet.participatingTeams.length,
                              itemBuilder: (context, teamIndex) {
                                final teamName = bet.participatingTeams[teamIndex];
                                final teamImageUrl = 'https://example.com/teams/$teamName.jpg';
                                return Padding(
                                  padding: const EdgeInsets.only(right: 8.0),
                                  child: CircleAvatar(
                                    backgroundImage: NetworkImage(teamImageUrl),
                                  ),
                                );
                              },
                            ),
                          ),
                          const SizedBox(height: 4.0),
                          Text('Buy-in Amount: \$${bet.buyInAmount.toStringAsFixed(2)}'),
                          const SizedBox(height: 8.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              ElevatedButton(
                                onPressed: () => _completeBet(index),
                                child: const Text('Complete Bet'),
                              ),
                              ElevatedButton(
                                onPressed: () => _cancelBet(index),
                                child: const Text('Cancel Bet'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

