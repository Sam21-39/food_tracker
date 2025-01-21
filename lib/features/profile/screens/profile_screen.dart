import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_tracker/core/blocs/auth/auth_cubit.dart';
import 'package:food_tracker/core/blocs/auth/auth_state.dart';
import 'package:food_tracker/core/blocs/food_entry/food_entry_cubit.dart';
import 'package:food_tracker/core/blocs/food_entry/food_entry_state.dart';
import 'package:food_tracker/core/blocs/localization/localization_cubit.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, authState) {
        final email =
            authState is AuthAuthenticated ? authState.user.email : null;

        return Scaffold(
          body: ListView(
            children: [
              _buildHeader(theme, email),
              const SizedBox(height: 20),
              _buildLanguageSelector(context, l10n),
              const Divider(),
              _buildStatistics(context, theme),
              if (authState is! AuthAuthenticated) ...[
                const Divider(),
                _buildLoginButton(context),
              ],
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeader(ThemeData theme, String? email) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          const CircleAvatar(
            radius: 50,
            child: Icon(Icons.person, size: 50),
          ),
          const SizedBox(height: 10),
          Text(
            email ?? 'Guest User',
            style: theme.textTheme.titleLarge,
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageSelector(
    BuildContext context,
    AppLocalizations l10n,
  ) {
    final localizationCubit = context.read<LocalizationCubit>();

    return BlocBuilder<LocalizationCubit, Locale>(
      builder: (context, currentLocale) {
        return ListTile(
          leading: const Icon(Icons.language),
          title: const Text('Language'),
          subtitle: Text(_getLanguageName(currentLocale.languageCode)),
          onTap: () {
            showDialog<void>(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: const Text('Select Language'),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: localizationCubit.supportedLocales.map((locale) {
                      return ListTile(
                        title: Text(_getLanguageName(locale.languageCode)),
                        onTap: () {
                          localizationCubit.setLocale(locale);
                          Navigator.pop(context);
                        },
                        trailing:
                            locale.languageCode == currentLocale.languageCode
                                ? const Icon(Icons.check)
                                : null,
                      );
                    }).toList(),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  Widget _buildStatistics(BuildContext context, ThemeData theme) {
    return BlocBuilder<FoodEntryCubit, FoodEntryState>(
      builder: (context, state) {
        if (state is FoodEntryLoaded) {
          final entries = state.entries;
          final totalMeals = entries.length;
          final vegetarianMeals =
              entries.where((entry) => entry.isVegetarian).length;

          return Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Your Statistics',
                  style: theme.textTheme.titleMedium,
                ),
                const SizedBox(height: 10),
                _buildStatCard(
                  icon: Icons.restaurant,
                  title: 'Total Meals',
                  value: totalMeals.toString(),
                ),
                const SizedBox(height: 10),
                _buildStatCard(
                  icon: Icons.eco,
                  title: 'Vegetarian Meals',
                  value: vegetarianMeals.toString(),
                ),
              ],
            ),
          );
        }

        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Card(
      child: ListTile(
        leading: Icon(icon),
        title: Text(title),
        trailing: Text(
          value,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildLoginButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: FilledButton.icon(
        onPressed: () {
          // TODO: Implement login
        },
        icon: const Icon(Icons.login),
        label: const Text('Sign In'),
      ),
    );
  }

  String _getLanguageName(String languageCode) {
    switch (languageCode) {
      case 'en':
        return 'English';
      case 'es':
        return 'Español';
      default:
        return languageCode;
    }
  }
}
