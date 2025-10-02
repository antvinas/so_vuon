import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:so_vuon/core/services/backup_service.dart';
import 'package:so_vuon/features/auth/auth_vm.dart';

enum BackupState { initial, loading, success, error }

class BackupViewModel extends StateNotifier<BackupState> {
  final Ref _ref;
  String? errorMessage;

  BackupViewModel(this._ref) : super(BackupState.initial);

  Future<void> backupData() async {
    try {
      state = BackupState.loading;
      final userId = _ref.read(authViewModelProvider)?.uid;
      if (userId == null) {
        throw Exception('User not logged in');
      }
      await _ref.read(backupServiceProvider).backupData(userId);
      state = BackupState.success;
    } catch (e) {
      errorMessage = e.toString();
      state = BackupState.error;
    }
  }

  Future<void> restoreData() async {
    try {
      state = BackupState.loading;
      final userId = _ref.read(authViewModelProvider)?.uid;
      if (userId == null) {
        throw Exception('User not logged in');
      }
      await _ref.read(backupServiceProvider).restoreData(userId);
      state = BackupState.success;
    } catch (e) {
      errorMessage = e.toString();
      state = BackupState.error;
    }
  }

  void resetState() {
    state = BackupState.initial;
  }
}

final backupViewModelProvider = StateNotifierProvider<BackupViewModel, BackupState>((ref) {
  return BackupViewModel(ref);
});
