import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:food_tracker/core/providers/food_entry_provider.dart';
import 'package:food_tracker/features/food_entry/screens/food_entry_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class FoodList extends ConsumerWidget {
  const FoodList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final foodEntries = ref.watch(foodEntriesProvider);

    return foodEntries.when(
      data: (entries) {
        if (entries.isEmpty) {
          return Center(
            child: Text(l10n.noFoodEntries),
          );
        }

        return ListView.builder(
          itemCount: entries.length,
          itemBuilder: (context, index) {
            final entry = entries[index];
            return Slidable(
              key: ValueKey(entry.id),
              endActionPane: ActionPane(
                motion: const ScrollMotion(),
                children: [
                  SlidableAction(
                    onPressed: (_) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => FoodEntryScreen(
                            entry: entry,
                          ),
                        ),
                      );
                    },
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    icon: Icons.edit,
                    label: l10n.edit,
                  ),
                  SlidableAction(
                    onPressed: (_) {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text(l10n.deleteEntry),
                          content: Text(l10n.deleteEntryConfirm),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: Text(l10n.cancel),
                            ),
                            TextButton(
                              onPressed: () {
                                ref
                                    .read(foodEntryServiceProvider)
                                    .deleteFoodEntry(entry.id);
                                Navigator.pop(context);
                              },
                              child: Text(l10n.delete),
                            ),
                          ],
                        ),
                      );
                    },
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    icon: Icons.delete,
                    label: l10n.delete,
                  ),
                ],
              ),
              child: ListTile(
                title: Text(entry.name),
                subtitle: Text(entry.category),
                trailing: entry.isSynced
                    ? const Icon(Icons.cloud_done, color: Colors.green)
                    : const Icon(Icons.cloud_off, color: Colors.grey),
              ),
            );
          },
        );
      },
      loading: () => const Center(
        child: CircularProgressIndicator(),
      ),
      error: (error, stack) => Center(
        child: Text('Error: $error'),
      ),
    );
  }
}
