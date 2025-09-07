import 'package:flutter_riverpod/flutter_riverpod.dart';

enum Gender { male, female }

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

  String getChannelId() {
    return state.channelId;
  }

  bool isChannelIDPresent() {
    return state.channelId == "" ? false : true;
  }
}

final channelLobbyProvider =
    StateNotifierProvider<ChannelLobbyNotifier, ChannelLobbyState>(
      (ref) => ChannelLobbyNotifier(),
    );
