import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:food_tracker/core/blocs/auth/auth_cubit.dart';
import 'package:food_tracker/core/blocs/food_entry/food_entry_cubit.dart';
import 'package:food_tracker/core/blocs/food_entry/food_entry_state.dart';
import 'package:food_tracker/core/blocs/sync/sync_cubit.dart';
import 'package:food_tracker/features/food_entry/screens/food_entry_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class FoodList extends StatelessWidget {
  const FoodList({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final authCubit = context.read<AuthCubit>();

    return Column(
      children: [
        if (authCubit.isSignedIn)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton.icon(
              onPressed: () async {
                try {
                  await context.read<SyncCubit>().syncAllEntries();
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(l10n.syncComplete),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  }
                } catch (e) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(l10n.syncError(e.toString())),
                        behavior: SnackBarBehavior.floating,
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                }
              },
              icon: const Icon(Icons.sync),
              label: Text(l10n.syncNow),
            ),
          ),
        Expanded(
          child: BlocBuilder<FoodEntryCubit, FoodEntryState>(
            builder: (context, state) {
              if (state is FoodEntryLoading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              if (state is FoodEntryError) {
                return Center(
                  child: Text('Error: ${state.message}'),
                );
              }

              if (state is FoodEntryLoaded) {
                final entries = state.entries;
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
                              Navigator.push<void>(
                                context,
                                MaterialPageRoute<void>(
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
                              showDialog<void>(
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
                                        context
                                            .read<FoodEntryCubit>()
                                            .deleteEntry(entry.id);
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
              }

              return const SizedBox.shrink();
            },
          ),
        ),
      ],
    );
  }
}
