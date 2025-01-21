import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_tracker/core/blocs/food_entry/food_entry_cubit.dart';
import 'package:food_tracker/core/blocs/sync/sync_cubit.dart';
import 'package:food_tracker/shared/models/food_entry.dart';
import 'package:food_tracker/features/food_entry/widgets/category_selector.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class FoodEntryScreen extends StatefulWidget {
  final FoodEntry? entry;

  const FoodEntryScreen({
    super.key,
    this.entry,
  });

  @override
  State<FoodEntryScreen> createState() => _FoodEntryScreenState();
}

class _FoodEntryScreenState extends State<FoodEntryScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late bool _isVegetarian;
  late String? _categoryId;
  late String? _subcategoryId;
  late DateTime _dateTime;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.entry?.name);
    _isVegetarian = widget.entry?.isVegetarian ?? false;
    _categoryId = widget.entry?.category;
    _subcategoryId = null; // Not used in the model
    _dateTime = widget.entry?.timestamp ?? DateTime.now();
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final l10n = AppLocalizations.of(context)!;

    if (_formKey.currentState?.validate() ?? false) {
      if (_categoryId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.categoryRequired),
            behavior: SnackBarBehavior.floating,
          ),
        );
        return;
      }

      final entry = FoodEntry(
        id: widget.entry?.id ?? 0,
        name: _nameController.text.trim(),
        category: _categoryId!,
        isVegetarian: _isVegetarian,
        timestamp: _dateTime,
        isSynced: false,
      );

      try {
        final foodEntryCubit = context.read<FoodEntryCubit>();
        await foodEntryCubit.addEntry(entry);
        if (mounted) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(context.read<SyncCubit>().autoSync
                  ? l10n.entrySavedAndSynced
                  : l10n.entrySavedLocally),
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(l10n.errorOccurred(e.toString())),
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.addFoodEntry),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: l10n.foodName,
                border: const OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return l10n.foodNameRequired;
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            CategorySelector(
              initialCategoryId: _categoryId,
              initialSubcategoryId: _subcategoryId,
              onSelect: (categoryId, subcategoryId) {
                setState(() {
                  _categoryId = categoryId;
                  _subcategoryId = subcategoryId;
                });
              },
            ),
            const SizedBox(height: 16),
            SwitchListTile(
              title: Text(l10n.vegetarian),
              value: _isVegetarian,
              onChanged: (value) {
                setState(() {
                  _isVegetarian = value;
                });
              },
            ),
            const SizedBox(height: 16),
            ListTile(
              title: Text(l10n.dateAndTime),
              subtitle: Text(
                _dateTime.toString(),
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              trailing: const Icon(Icons.calendar_today),
              onTap: () async {
                final date = await showDatePicker(
                  context: context,
                  initialDate: _dateTime,
                  firstDate: DateTime(2000),
                  lastDate: DateTime.now(),
                );
                if (date != null) {
                  final time = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.fromDateTime(_dateTime),
                  );
                  if (time != null) {
                    setState(() {
                      _dateTime = DateTime(
                        date.year,
                        date.month,
                        date.day,
                        time.hour,
                        time.minute,
                      );
                    });
                  }
                }
              },
            ),
            const SizedBox(height: 32),
            FilledButton(
              onPressed: _save,
              child: Text(l10n.saveEntry),
            ),
          ],
        ),
      ),
    );
  }
}
