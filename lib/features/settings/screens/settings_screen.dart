import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_tracker/core/blocs/auth/auth_cubit.dart';
import 'package:food_tracker/core/blocs/localization/localization_cubit.dart';
import 'package:food_tracker/core/blocs/sync/sync_cubit.dart';
import 'package:food_tracker/core/blocs/sync/sync_state.dart';
import 'package:food_tracker/core/blocs/theme/theme_cubit.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final authCubit = context.read<AuthCubit>();
    final syncCubit = context.read<SyncCubit>();
    final localizationCubit = context.read<LocalizationCubit>();

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.settings),
      ),
      body: ListView(
        children: [
          ListTile(
            title: Text(l10n.account),
            subtitle: Text(authCubit.isSignedIn ? l10n.signedIn : l10n.signIn),
            trailing: IconButton(
              icon: Icon(authCubit.isSignedIn ? Icons.logout : Icons.login),
              onPressed: () async {
                if (authCubit.isSignedIn) {
                  await authCubit.signOut();
                  Navigator.pop(context);
                } else {
                  // TODO: Navigate to sign in screen
                }
              },
            ),
          ),
          const Divider(),
          BlocBuilder<ThemeCubit, bool>(
            builder: (context, isDarkMode) {
              return SwitchListTile(
                title: const Text('Dark Mode'),
                value: isDarkMode,
                onChanged: (value) {
                  context.read<ThemeCubit>().setDarkMode(value);
                },
              );
            },
          ),
          const Divider(),
          BlocBuilder<SyncCubit, SyncState>(
            builder: (context, state) {
              return SwitchListTile(
                title: Text(l10n.autoSync),
                value: syncCubit.autoSync,
                onChanged: (value) {
                  syncCubit.setAutoSync(value);
                },
              );
            },
          ),
          ListTile(
            title: Text(l10n.syncNow),
            trailing: const Icon(Icons.sync),
            onTap: () async {
              try {
                await syncCubit.syncAllEntries();
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
          ),
          const Divider(),
          BlocBuilder<LocalizationCubit, Locale>(
            builder: (context, currentLocale) {
              return ListTile(
                title: Text(l10n.language),
                subtitle: Text(_getLanguageName(currentLocale.languageCode)),
                trailing: const Icon(Icons.language),
                onTap: () {
                  showDialog<void>(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text(l10n.selectLanguage),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children:
                              localizationCubit.supportedLocales.map((locale) {
                            return ListTile(
                              title:
                                  Text(_getLanguageName(locale.languageCode)),
                              trailing: locale.languageCode ==
                                      currentLocale.languageCode
                                  ? const Icon(Icons.check)
                                  : null,
                              onTap: () {
                                localizationCubit.setLocale(locale);
                                Navigator.pop(context);
                              },
                            );
                          }).toList(),
                        ),
                      );
                    },
                  );
                },
              );
            },
          ),
          const Divider(),
          ListTile(
            title: Text(l10n.about),
            onTap: () {
              showAboutDialog(
                context: context,
                applicationName: l10n.appTitle,
                applicationVersion: '1.0.0',
                applicationLegalese: '© 2024',
                children: [
                  TextButton(
                    onPressed: () {
                      launchUrl(Uri.parse(
                          'https://github.com/yourusername/food_tracker'));
                    },
                    child: const Text('GitHub'),
                  ),
                ],
              );
            },
          ),
        ],
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
