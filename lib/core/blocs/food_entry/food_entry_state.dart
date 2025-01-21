import 'package:equatable/equatable.dart';
import 'package:food_tracker/shared/models/food_entry.dart';

abstract class FoodEntryState extends Equatable {
  const FoodEntryState();

  @override
  List<Object?> get props => [];
}

class FoodEntryInitial extends FoodEntryState {}

class FoodEntryLoading extends FoodEntryState {}

class FoodEntryLoaded extends FoodEntryState {
  final List<FoodEntry> entries;

  const FoodEntryLoaded(this.entries);

  @override
  List<Object?> get props => [entries];
}

class FoodEntryError extends FoodEntryState {
  final String message;

  const FoodEntryError(this.message);

  @override
  List<Object?> get props => [message];
}

class FoodEntrySaved extends FoodEntryState {
  final FoodEntry entry;

  const FoodEntrySaved(this.entry);

  @override
  List<Object?> get props => [entry];
}

class FoodEntryDeleted extends FoodEntryState {
  final int id;

  const FoodEntryDeleted(this.id);

  @override
  List<Object?> get props => [id];
}
