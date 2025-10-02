import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csv/csv.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';

class BackupService {
  final FirebaseFirestore _firestore;

  BackupService(this._firestore);

  Future<String> backupData(String userId) async {
    final transactionsRef = _firestore.collection('users').doc(userId).collection('transactions');
    final querySnapshot = await transactionsRef.get();

    final List<List<dynamic>> rows = [];
    rows.add(['id', 'amount', 'date', 'description', 'type']); // CSV Header

    for (var doc in querySnapshot.docs) {
      final data = doc.data();
      rows.add([
        doc.id,
        data['amount'],
        (data['date'] as Timestamp).toDate().toIso8601String(),
        data['description'],
        data['type'],
      ]);
    }

    final String csv = const ListToCsvConverter().convert(rows);
    final Directory tempDir = await getTemporaryDirectory();
    final String filePath = '${tempDir.path}/so_vuon_backup_${DateTime.now().toIso8601String()}.csv';
    final File file = File(filePath);
    await file.writeAsString(csv);

    return filePath;
  }

  Future<void> restoreData(String userId) async {
    final FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['csv'],
    );

    if (result != null && result.files.single.path != null) {
      final File file = File(result.files.single.path!);
      final String csvString = await file.readAsString();
      final List<List<dynamic>> rows = const CsvToListConverter().convert(csvString);

      if (rows.length < 2) { // Header + at least one data row
        throw Exception('Invalid or empty CSV file.');
      }

      final WriteBatch batch = _firestore.batch();
      final transactionsRef = _firestore.collection('users').doc(userId).collection('transactions');

      // Clear existing data
      final existingDocs = await transactionsRef.get();
      for (var doc in existingDocs.docs) {
        batch.delete(doc.reference);
      }

      // Add new data from CSV
      for (int i = 1; i < rows.length; i++) {
        final row = rows[i];
        final docRef = transactionsRef.doc(row[0]);
        batch.set(docRef, {
          'amount': row[1],
          'date': Timestamp.fromDate(DateTime.parse(row[2])),
          'description': row[3],
          'type': row[4],
        });
      }

      await batch.commit();
    }
  }
}

final backupServiceProvider = Provider<BackupService>((ref) {
  return BackupService(FirebaseFirestore.instance);
});
