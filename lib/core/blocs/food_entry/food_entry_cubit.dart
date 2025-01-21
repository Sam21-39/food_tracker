import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_tracker/core/blocs/food_entry/food_entry_state.dart';
import 'package:food_tracker/core/blocs/sync/sync_cubit.dart';
import 'package:food_tracker/core/config/objectbox.dart';
import 'package:food_tracker/shared/models/food_entry.dart';

class FoodEntryCubit extends Cubit<FoodEntryState> {
  final ObjectBox _objectBox;
  final SyncCubit _syncCubit;

  FoodEntryCubit(this._objectBox, this._syncCubit) : super(FoodEntryInitial()) {
    _loadEntries();
  }

  Future<void> _loadEntries() async {
    try {
      emit(FoodEntryLoading());
      final entries = _objectBox.getAllFoodEntries();
      emit(FoodEntryLoaded(entries));
    } catch (e) {
      emit(FoodEntryError(e.toString()));
    }
  }

  Future<void> addEntry(FoodEntry entry) async {
    try {
      emit(FoodEntryLoading());
      _objectBox.addFoodEntry(entry);
      await _syncCubit.syncEntry(entry);
      await _loadEntries();
      emit(FoodEntrySaved(entry));
    } catch (e) {
      emit(FoodEntryError(e.toString()));
    }
  }

  Future<void> updateEntry(FoodEntry entry) async {
    try {
      emit(FoodEntryLoading());
      _objectBox.addFoodEntry(entry);
      await _syncCubit.syncEntry(entry);
      await _loadEntries();
      emit(FoodEntrySaved(entry));
    } catch (e) {
      emit(FoodEntryError(e.toString()));
    }
  }

  Future<void> deleteEntry(int id) async {
    try {
      emit(FoodEntryLoading());
      _objectBox.deleteFoodEntry(id);
      await _loadEntries();
      emit(FoodEntryDeleted(id));
    } catch (e) {
      emit(FoodEntryError(e.toString()));
    }
  }

  Stream<List<FoodEntry>> watchEntries() {
    return _objectBox.watchAllFoodEntries();
  }
}
