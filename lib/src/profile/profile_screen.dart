import 'package:flutter/material.dart';
import 'package:tournament_betting/src/profile/profile.dart';

class ProfileScreen extends StatelessWidget {
  final Profile profile;

  const ProfileScreen({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          CircleAvatar(
            radius: 80.0,
            backgroundImage: NetworkImage(profile.imageUrl),
          ),
          const SizedBox(height: 16.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                profile.name,
                style: const TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
              ),
              const SizedBox(width: 8.0),
              Icon(
                profile.isVerified ? Icons.check_circle : Icons.cancel,
                color: profile.isVerified ? Colors.green : Colors.red,
              ),
            ],
          ),
          const SizedBox(height: 8.0),
          Center(
            child: Text(
              profile.email,
              style: TextStyle(fontSize: 16.0, color: Colors.grey[600]),
            ),
          ),
          const SizedBox(height: 24.0),
          const Text(
            'Betting History',
            style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8.0),
          if (profile.bettingHistory.isEmpty)
            const Text('No betting history available.')
          else
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: profile.bettingHistory.length,
              itemBuilder: (context, index) {
                final bet = profile.bettingHistory[index];
                return ListTile(
                  title: Text(bet),
                );
              },
            ),
        ],
      ),
    );
  }
}