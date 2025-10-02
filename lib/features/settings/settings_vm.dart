import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:so_vuon/data/models/entry.dart';
import 'package:so_vuon/data/repositories/entry_repository.dart';

class SettingsViewModel {
  final EntryRepository _entryRepository;

  SettingsViewModel(this._entryRepository);

  Future<void> backupData() async {
    final entries = await _entryRepository.getEntries().first;
    final entriesJson = entries.map((entry) => entry.toJson()).toList();
    final jsonString = jsonEncode(entriesJson);

    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/so_vuon_backup.json');
    await file.writeAsString(jsonString);
  }

  Future<void> restoreData() async {
    final result = await FilePicker.platform.pickFiles();
    if (result != null) {
      final file = File(result.files.single.path!);
      final jsonString = await file.readAsString();
      final entriesJson = jsonDecode(jsonString) as List<dynamic>;

      for (var entryJson in entriesJson) {
        final entry = Entry.fromJson(entryJson);
        await _entryRepository.addEntry(entry);
      }
    }
  }
}

final settingsViewModelProvider = Provider<SettingsViewModel>((ref) {
  final entryRepository = ref.watch(entryRepositoryProvider);
  return SettingsViewModel(entryRepository);
});
