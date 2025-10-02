import 'package:cloud_firestore/cloud_firestore.dart';

enum EntryType { income, expense }

class Entry {
  String id;
  final double amount;
  final EntryType type;
  final DateTime date;
  final String category;
  final String description;

  Entry({
    this.id = '',
    required this.amount,
    required this.type,
    required this.date,
    required this.category,
    required this.description,
  });

  // Entry 객체를 Map으로 변환 (Firestore에 저장하기 위함)
  Map<String, dynamic> toJson() {
    return {
      'amount': amount,
      'type': type.toString(),
      'date': Timestamp.fromDate(date),
      'category': category,
      'description': description,
    };
  }

  // Map에서 Entry 객체로 변환
  factory Entry.fromJson(Map<String, dynamic> json) {
    return Entry(
      amount: (json['amount'] as num).toDouble(),
      type: EntryType.values.firstWhere((e) => e.toString() == json['type']),
      date: (json['date'] as Timestamp).toDate(),
      category: json['category'] as String,
      description: json['description'] as String,
    );
  }

  // 객체 복사를 위한 copyWith 메소드
  Entry copyWith({String? id}) {
    return Entry(
      id: id ?? this.id,
      amount: amount,
      type: type,
      date: date,
      category: category,
      description: description,
    );
  }
}
