import 'package:equatable/equatable.dart';
import 'package:food_tracker/shared/models/food_entry.dart';

abstract class SyncState extends Equatable {
  const SyncState();

  @override
  List<Object?> get props => [];
}

class SyncInitial extends SyncState {}

class SyncInProgress extends SyncState {}

class SyncSuccess extends SyncState {
  final List<FoodEntry> entries;

  const SyncSuccess(this.entries);

  @override
  List<Object?> get props => [entries];
}

class SyncError extends SyncState {
  final String message;

  const SyncError(this.message);

  @override
  List<Object?> get props => [message];
}
