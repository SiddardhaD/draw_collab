import 'dart:math';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum Gender { male, female, other }

class ChannelLobbyState {
  final String displayName;
  final Gender gender;
  final String channelId;
  final String? userId;

  const ChannelLobbyState({
    this.displayName = '',
    this.gender = Gender.male,
    this.channelId = '',
    this.userId,
  });

  ChannelLobbyState copyWith({
    String? displayName,
    Gender? gender,
    String? channelId,
    String? userId,
  }) {
    return ChannelLobbyState(
      displayName: displayName ?? this.displayName,
      gender: gender ?? this.gender,
      channelId: channelId ?? this.channelId,
      userId: userId ?? this.userId,
    );
  }
}

class ChannelLobbyNotifier extends StateNotifier<ChannelLobbyState> {
  ChannelLobbyNotifier() : super(const ChannelLobbyState());

  void setDisplayName(String name) {
    state = state.copyWith(displayName: name.trim());
  }

  void setGender(Gender g) {
    state = state.copyWith(gender: g);
  }

  void setChannelId(String id) {
    state = state.copyWith(channelId: id.trim().toUpperCase());
  }

  void ensureUserId() {
    if (state.userId == null || state.userId!.isEmpty) {
      final newId =
          'u_${DateTime.now().millisecondsSinceEpoch}_${_randomCode(4)}';
      state = state.copyWith(userId: newId);
    }
  }

  bool isChannelIDPresent() {
    return state.channelId == "" ? false : true;
  }

  String _randomCode([int length = 6]) {
    const chars = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789';
    final r = Random.secure();
    return List.generate(length, (_) => chars[r.nextInt(chars.length)]).join();
  }
}

final channelLobbyProvider =
    StateNotifierProvider<ChannelLobbyNotifier, ChannelLobbyState>(
      (ref) => ChannelLobbyNotifier(),
    );
