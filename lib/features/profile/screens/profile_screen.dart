import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:food_tracker/core/config/supabase_config.dart';
import 'package:food_tracker/core/providers/localization_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final currentUser = SupabaseConfig.currentUser;

    return Scaffold(
      body: ListView(
        children: [
          _buildHeader(theme, currentUser?.email),
          const SizedBox(height: 20),
          _buildLanguageSelector(context, ref, l10n),
          const Divider(),
          _buildStatistics(theme),
          if (currentUser == null) ...[
            const Divider(),
            _buildLoginButton(context),
          ],
        ],
      ),
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
    WidgetRef ref,
    AppLocalizations l10n,
  ) {
    final currentLocale = ref.watch(localeProvider);
    final supportedLocales = ref.watch(supportedLocalesProvider);

    return ListTile(
      leading: const Icon(Icons.language),
      title: const Text('Language'),
      subtitle: Text(_getLanguageName(currentLocale.languageCode)),
      onTap: () {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Select Language'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: supportedLocales.map((locale) {
                  return ListTile(
                    title: Text(_getLanguageName(locale.languageCode)),
                    onTap: () {
                      ref.read(localeProvider.notifier).state = locale;
                      Navigator.pop(context);
                    },
                    trailing: locale.languageCode == currentLocale.languageCode
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
  }

  Widget _buildStatistics(ThemeData theme) {
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
            value: '120',
          ),
          const SizedBox(height: 10),
          _buildStatCard(
            icon: Icons.eco,
            title: 'Vegetarian Meals',
            value: '80',
          ),
        ],
      ),
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
      case 'hi':
        return 'हिंदी';
      default:
        return languageCode;
    }
  }
}
