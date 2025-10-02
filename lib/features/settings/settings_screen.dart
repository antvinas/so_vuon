import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:so_vuon/core/utils/currency_formatter.dart';
import 'package:so_vuon/features/auth/auth_vm.dart';
import 'package:so_vuon/features/settings/backup_view_model.dart';
import 'package:so_vuon/features/settings/currency_provider.dart';
import 'package:so_vuon/features/settings/locale_provider.dart';
import 'package:so_vuon/features/settings/notification_settings_provider.dart';
import 'package:so_vuon/features/settings/profile_screen.dart';
import 'package:so_vuon/features/settings/theme_provider.dart';
import 'package:so_vuon/l10n/app_localizations.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;

    ref.listen<BackupState>(backupViewModelProvider, (previous, next) {
      if (next == BackupState.loading) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => const Center(child: CircularProgressIndicator()),
        );
      } else if (next == BackupState.success) {
        Navigator.of(context).pop(); // Close loading dialog
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.dataBackupSuccess)),
        );
        ref.read(backupViewModelProvider.notifier).resetState();
      } else if (next == BackupState.error) {
        Navigator.of(context).pop(); // Close loading dialog
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${l10n.error}: ${ref.read(backupViewModelProvider.notifier).errorMessage}')),
        );
        ref.read(backupViewModelProvider.notifier).resetState();
      }
    });

    final themeMode = ref.watch(themeProvider);
    final currency = ref.watch(currencyProvider);
    final locale = ref.watch(localeProvider);
    final notificationSettings = ref.watch(notificationSettingsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.settings),
      ),
      body: ListView(
        children: <Widget>[
          // Profile Section
          ListTile(
            leading: const Icon(Icons.person_outline),
            title: Text(l10n.profile),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ProfileScreen()),
            ),
          ),

          // App Settings Section
          _buildSectionTitle(context, l10n.appSettings),
          ListTile(
            leading: const Icon(Icons.palette_outlined),
            title: Text(l10n.theme),
            trailing: DropdownButton<ThemeMode>(
              value: themeMode,
              items: [
                DropdownMenuItem(value: ThemeMode.system, child: Text(l10n.themeSystem)),
                DropdownMenuItem(value: ThemeMode.light, child: Text(l10n.themeLight)),
                DropdownMenuItem(value: ThemeMode.dark, child: Text(l10n.themeDark)),
              ],
              onChanged: (ThemeMode? mode) {
                if (mode != null) {
                  ref.read(themeProvider.notifier).changeTheme(mode);
                }
              },
            ),
          ),
          ListTile(
            leading: const Icon(Icons.attach_money_outlined),
            title: Text(l10n.currency),
            trailing: DropdownButton<String>(
              value: currency,
              items: [
                DropdownMenuItem(value: 'KRW', child: Text(l10n.currencyKRW)),
                DropdownMenuItem(value: 'USD', child: Text(l10n.currencyUSD)),
                DropdownMenuItem(value: 'VND', child: Text(l10n.currencyVND)),
              ],
              onChanged: (String? newCurrency) {
                if (newCurrency != null) {
                  ref.read(currencyProvider.notifier).changeCurrency(newCurrency);
                }
              },
            ),
          ),
          ListTile(
            leading: const Icon(Icons.language_outlined),
            title: Text(l10n.language),
            trailing: DropdownButton<Locale>(
              value: locale,
              items: [
                DropdownMenuItem(value: const Locale('ko'), child: Text(l10n.languageKO)),
                DropdownMenuItem(value: const Locale('en'), child: Text(l10n.languageEN)),
                DropdownMenuItem(value: const Locale('vi'), child: Text(l10n.languageVI)),
              ],
              onChanged: (Locale? newLocale) {
                if (newLocale != null) {
                  ref.read(localeProvider.notifier).changeLocale(newLocale);
                }
              },
            ),
          ),

          // Notification Section
          const Divider(),
          _buildSectionTitle(context, l10n.notifications),
          SwitchListTile(
            title: Text(l10n.receiveNotifications),
            value: notificationSettings.areNotificationsEnabled,
            onChanged: (bool value) {
              ref.read(notificationSettingsProvider.notifier).setNotificationsEnabled(context, value);
            },
          ),
          if (notificationSettings.areNotificationsEnabled)
            ListTile(
              title: Text(l10n.notificationTime),
              subtitle: Text(notificationSettings.notificationTime.format(context)),
              onTap: () async {
                final TimeOfDay? picked = await showTimePicker(
                  context: context,
                  initialTime: notificationSettings.notificationTime,
                );
                if (picked != null) {
                  ref.read(notificationSettingsProvider.notifier).setNotificationTime(context, picked);
                }
              },
            ),

          // Data Section
          const Divider(),
          _buildSectionTitle(context, l10n.data),
          ListTile(
            leading: const Icon(Icons.backup_outlined),
            title: Text(l10n.dataBackup),
            onTap: () => ref.read(backupViewModelProvider.notifier).backupData(),
          ),
          ListTile(
            leading: const Icon(Icons.restore_outlined),
            title: Text(l10n.dataRestore),
            onTap: () => ref.read(backupViewModelProvider.notifier).restoreData(),
          ),

          // Logout Section
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: Text(l10n.logout, style: const TextStyle(color: Colors.red)),
            onTap: () => ref.read(authViewModelProvider.notifier).signOut(),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 8.0),
      child: Text(
        title.toUpperCase(),
        style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
      ),
    );
  }
}
