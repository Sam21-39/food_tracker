import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:food_tracker/core/providers/objectbox_provider.dart';
import 'package:food_tracker/core/providers/sync_provider.dart';
import 'package:food_tracker/core/providers/localization_provider.dart';
import 'package:food_tracker/core/providers/theme_provider.dart';
import 'package:food_tracker/core/providers/auth_provider.dart';
import 'package:food_tracker/core/services/notification_service.dart';
import 'package:food_tracker/features/auth/screens/sign_in_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';

final notificationsEnabledProvider = StateProvider<bool>((ref) => true);

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final authState = ref.watch(authStateProvider);
    final isDarkMode = ref.watch(themeProvider);
    final autoSync = ref.watch(autoSyncProvider);
    final theme = Theme.of(context);
    final currentLocale = ref.watch(localeProvider);
    final supportedLocales = ref.watch(supportedLocalesProvider);
    final notificationsEnabled = ref.watch(notificationsEnabledProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.settings),
      ),
      body: ListView(
        children: [
          ListTile(
            title: Text(l10n.account),
            subtitle: Text(
              authState.isSignedIn ? l10n.signedIn : l10n.signInSubtitle,
            ),
            trailing: authState.isSignedIn
                ? IconButton(
                    icon: const Icon(Icons.logout),
                    onPressed: () {
                      ref.read(authStateProvider.notifier).signOut();
                    },
                  )
                : const Icon(Icons.chevron_right),
            onTap: authState.isSignedIn
                ? null
                : () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SignInScreen(),
                      ),
                    );
                  },
          ),
          const Divider(),
          ListTile(
            title: Text(l10n.syncSettings),
            subtitle: Text(
              authState.isSignedIn
                  ? l10n.autoSyncSubtitle
                  : l10n.syncUnavailable,
            ),
            trailing: Switch(
              value: autoSync && authState.isSignedIn,
              onChanged: authState.isSignedIn
                  ? (value) {
                      ref.read(autoSyncProvider.notifier).state = value;
                    }
                  : null,
            ),
          ),
          if (authState.isSignedIn && !autoSync)
            ListTile(
              title: Text(l10n.syncNow),
              subtitle: Text(l10n.syncNowSubtitle),
              trailing: const Icon(Icons.sync),
              onTap: () {
                // TODO: Implement manual sync
              },
            ),
          const Divider(),
          ListTile(
            title: Text(l10n.appearance),
            subtitle: Text(l10n.themeSubtitle),
            trailing: Switch(
              value: isDarkMode,
              onChanged: (value) {
                ref.read(themeProvider.notifier).state = value;
              },
            ),
          ),
          const Divider(),
          ListTile(
            title: Text(l10n.language),
            subtitle: Text(l10n.selectLanguage),
            trailing: DropdownButton<String>(
              value: ref.watch(localeProvider)?.languageCode ?? 'en',
              items: ref
                  .watch(supportedLocalesProvider)
                  .map(
                    (locale) => DropdownMenuItem(
                      value: locale.languageCode,
                      child: Text(locale.languageCode.toUpperCase()),
                    ),
                  )
                  .toList(),
              onChanged: (value) {
                if (value != null) {
                  ref.read(localeProvider.notifier).state = Locale(value);
                }
              },
            ),
          ),
          const Divider(),
          _buildSection(
            theme,
            title: l10n.notifications,
            children: [
              SwitchListTile(
                title: Text(l10n.mealReminders),
                subtitle: Text(l10n.mealRemindersSubtitle),
                value: notificationsEnabled,
                onChanged: (value) async {
                  final notificationService = NotificationService();
                  if (value) {
                    await notificationService.scheduleDailyReminder(
                      hour: 12,
                      minute: 0,
                      title: l10n.appTitle,
                      body: l10n.mealRemindersSubtitle,
                    );
                  } else {
                    await notificationService.cancelAllReminders();
                  }
                  ref.read(notificationsEnabledProvider.notifier).state = value;
                },
              ),
            ],
          ),
          _buildSection(
            theme,
            title: l10n.about,
            children: [
              ListTile(
                title: Text(l10n.version),
                subtitle: const Text('1.0.0'),
              ),
              ListTile(
                title: Text(l10n.termsOfService),
                onTap: () => _launchURL('https://example.com/terms'),
              ),
              ListTile(
                title: Text(l10n.privacyPolicy),
                onTap: () => _launchURL('https://example.com/privacy'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSection(
    ThemeData theme, {
    required String title,
    required List<Widget> children,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Text(
            title,
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.colorScheme.primary,
            ),
          ),
        ),
        ...children,
        const Divider(),
      ],
    );
  }

  Future<void> _launchURL(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    }
  }
}
