import 'package:draw/app/viewmodels/channel_lobby_view_model.dart';
import 'package:draw/app/views/split_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChannelLobbyScreen extends ConsumerWidget {
  const ChannelLobbyScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lobby = ref.watch(channelLobbyProvider);
    final lobbyNotifier = ref.read(channelLobbyProvider.notifier);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Spacer(),
              Text(
                "Join a Channel",
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),

              Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 16,
                        backgroundColor:
                            lobby.gender == Gender.female
                                ? Colors.pink.shade100
                                : Colors.deepPurple.shade100,
                        child: Icon(
                          lobby.gender == Gender.female
                              ? Icons.female
                              : Icons.male,
                          color:
                              lobby.gender == Gender.female
                                  ? Colors.pink
                                  : Colors.deepPurple,
                          size: 18,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextField(
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintStyle: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                            hintText: "Enter your name",
                          ),
                          onChanged: lobbyNotifier.setDisplayName,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Gender Selection
              Wrap(
                spacing: 8,
                children: [
                  ChoiceChip(
                    label: const Text("Male"),
                    selected: lobby.gender == Gender.male,
                    onSelected: (_) => lobbyNotifier.setGender(Gender.male),
                  ),
                  ChoiceChip(
                    label: const Text("Female"),
                    selected: lobby.gender == Gender.female,
                    onSelected: (_) => lobbyNotifier.setGender(Gender.female),
                  ),
                ],
              ),
              const SizedBox(height: 32),

              // Channel Code Entry
              Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 4,
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.meeting_room, color: Colors.deepPurple),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextField(
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 12,
                          ),
                          textCapitalization: TextCapitalization.characters,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintStyle: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 12,
                            ),
                            hintText: "Channel code (e.g. ABC123)",
                          ),
                          onChanged: lobbyNotifier.setChannelId,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 40),

              // Join Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.login, color: Colors.white),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  label: const Text(
                    "Join Channel",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                      color: Colors.white,
                    ),
                  ),

                  onPressed: () async {
                    lobbyNotifier.ensureUserId();
                    if (!lobbyNotifier.isChannelIDPresent()) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            "Enter Channel Code",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      );
                      return;
                    }

                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const SplitScreen()),
                    );
                  },
                ),
              ),

              const Spacer(flex: 2),
            ],
          ),
        ),
      ),
    );
  }
}
